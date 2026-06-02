import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants.dart';
import '../../../water/domain/repositories/i_water_repository.dart';
import '../../../card/domain/repositories/i_card_repository.dart';
import '../../domain/entities/user_data.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/i_user_repository.dart';

@LazySingleton(as: IUserRepository)
class UserRepository extends ChangeNotifier implements IUserRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final IWaterRepository _waterRepository;
  final ICardRepository _cardRepository;

  UserRepository(
    this._auth,
    this._firestore,
    this._waterRepository,
    this._cardRepository,
  );

  bool _isLoading = false;
  String? _errorMessage;
  bool _isProcessingLink = false;

  @override
  bool get isProcessingLink => _isProcessingLink;

  @override
  bool get isLoading => _isLoading;

  @override
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  @override
  void clearError() {
    _setError(null);
  }

  @override
  UserData? currentUser;

  @override
  bool get isLoggedIn => currentUser != null;

  String? get _uid => _auth.currentUser?.uid;

  @override
  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString("user_name");
      final weight = prefs.getDouble("user_weight");
      final customGoal = prefs.getDouble("custom_goal");

      if (name != null && weight != null) {
        currentUser = UserData(
          name: name,
          weight: weight,
          customGoal: customGoal,
        );
        notifyListeners();
      }
    } catch (e) {
      _setError("Error loading local data");
    }
  }

  Future<void> loadFromFirestore() async {
    if (_uid == null) return;
    _setLoading(true);
    _setError(null);

    try {
      final doc = await _firestore.collection("users").doc(_uid).get();
      if (doc.exists) {
        final data = doc.data()!;

        final name = data["name"] as String;
        final weight = (data["weight"] as num).toDouble();
        final customGoal = data["customGoal"] != null
            ? (data["customGoal"] as num).toDouble()
            : null;

        currentUser = UserData(name: name, weight: weight, customGoal: customGoal);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("user_name", name);
        await prefs.setDouble("user_weight", weight);
        if (customGoal != null) {
          await prefs.setDouble("custom_goal", customGoal);
        } else {
          await prefs.remove("custom_goal");
        }

        notifyListeners();
      }
    } catch (e) {
      _setError("Failed to load data from the cloud");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _saveToFirestore() async {
    if (_uid == null || currentUser == null) return;

    try {
      await _firestore.collection("users").doc(_uid).set({
        "name": currentUser!.name,
        "weight": currentUser!.weight,
        "customGoal": currentUser?.customGoal,
      }, SetOptions(merge: true));
    } catch (e) {
      _setError("Failed to save data to the cloud");
      rethrow;
    }
  }

  @override
  Future<bool> sendSignInLink(String email, {String languageCode = 'ru'}) async {
    _setLoading(true);
    _setError(null);
    try {
      await _auth.setLanguageCode(languageCode);
      final actionCodeSettings = ActionCodeSettings(
        url: 'https://drink-water-a5f9e.web.app/finishSignIn',
        handleCodeInApp: true,
        androidPackageName: 'com.example.drink_water',
        androidInstallApp: true,
        androidMinimumVersion: '21',
      );
      await _auth.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: actionCodeSettings,
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('pending_email', email);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(translateFirebaseError(e.code));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  @override
  Future<bool> signInWithLink(String emailLink) async {
    _isProcessingLink = true;
    notifyListeners();
    _setLoading(true);
    _setError(null);
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('pending_email');
      if (email == null) {
        _setError('Email not found. Enter your email and request the link again.');
        return false;
      }
      if (!_auth.isSignInWithEmailLink(emailLink)) {
        _setError('Invalid link');
        return false;
      }
      await _auth.signInWithEmailLink(email: email, emailLink: emailLink);
      await prefs.remove('pending_email');

      // Firestore в отдельном try-catch — если недоступен, вход всё равно проходит
      try {
        final doc = await _firestore.collection('users').doc(_uid).get();
        if (doc.exists) {
          await loadFromFirestore();
          await _waterRepository.loadFromFirestore();
          await _cardRepository.loadFromFirestore();
        }
      } catch (e) {
        // Firestore временно недоступен — не страшно
        // currentUser останется null, completePendingRegistration отработает
      }

      _isProcessingLink = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isProcessingLink = false;
      _setError(translateFirebaseError(e.code));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // сохраняем имя и вес пока пользователь ждёт ссылку на почте
  @override
  Future<void> savePendingRegistration(String name, double weight) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pending_name', name);
    await prefs.setDouble('pending_weight', weight);
  }

  // достаёт сохранённые имя/вес и завершает регистрацию.
  @override
  Future<bool> completePendingRegistration() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('pending_name');
    final weight = prefs.getDouble('pending_weight');

    if (name == null || weight == null) return false;

    await prefs.remove('pending_name');
    await prefs.remove('pending_weight');

    await register(name, weight);
    return true;
  }

  @override
  Future<void> register(String name, double weight, {double? customGoal}) async {
    _setLoading(true);
    _setError(null);

    try {
      currentUser = UserData(
        name: name,
        weight: weight,
        customGoal: customGoal,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("user_name", name);
      await prefs.setDouble("user_weight", weight);
      if (customGoal != null) {
        await prefs.setDouble("custom_goal", customGoal);
      } else {
        await prefs.remove("custom_goal");
      }

      await _saveToFirestore();
      notifyListeners();
    } catch (e) {
      _setError("Error saving user data");
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  @override
  Future<void> setCustomGoal(double? goal) async {
    if (currentUser == null) return;

    _setLoading(true);
    _setError(null);

    try {
      currentUser = UserData(
        name: currentUser!.name,
        weight: currentUser!.weight,
        customGoal: goal,
      );

      final prefs = await SharedPreferences.getInstance();
      if (goal != null) {
        await prefs.setDouble("custom_goal", goal);
      } else {
        await prefs.remove("custom_goal");
      }

      await _saveToFirestore();
      notifyListeners();
    } catch (e) {
      _setError("Failed to change daily goal");
    } finally {
      _setLoading(false);
    }
  }

  @override
  Future<void> signOut() async {
    _setLoading(true);
    _setError(null);

    try {
      await _auth.signOut();
      await clear();
    } catch (e) {
      _setError("Error signing out of account");
    } finally {
      _setLoading(false);
    }
  }

  @override
  Future<void> clear() async {
    try {
      currentUser = null;
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      notifyListeners();
    } catch (e) {
      _setError("Error clearing data");
    }
  }
}