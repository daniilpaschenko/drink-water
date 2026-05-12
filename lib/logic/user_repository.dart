import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'water_repository.dart';
import 'card_repository.dart';
import '../models/user_data.dart';

abstract class IUserRepository {
  UserData? get currentUser;
  bool get isLoggedIn;
  bool get isLoading;
  String? get errorMessage;

  Future<void> load();
  Future<void> register(String name, double weight, {double? customGoal});
  Future<void> setCustomGoal(double? goal);
  Future<void> clear();
  Future<bool> signUp(String email, String password, String name, double weight);
  Future<bool> signIn(String email, String password);
  Future<void> signOut();
  void clearError();
}

class UserRepository extends ChangeNotifier implements IUserRepository {
  static final UserRepository _instance = UserRepository._internal();
  factory UserRepository() => _instance;
  UserRepository._internal();

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  // флаги для обработки ошибок
  bool _isLoading = false;
  String? _errorMessage;

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

  // Перевод ошибок Firebase
  String _translateFirebaseError(String code) {
    switch (code) {
      case 'weak-password':
        return 'Слишком слабый пароль (минимум 6 символов)';
      case 'email-already-in-use':
        return 'Этот email уже используется';
      case 'invalid-email':
        return 'Неверный формат email';
      case 'user-not-found':
        return 'Пользователь с таким email не найден';
      case 'wrong-password':
        return 'Неверный пароль';
      case 'too-many-requests':
        return 'Слишком много попыток. Попробуйте позже';
      case 'network-request-failed':
        return 'Проблема с подключением к интернету';
      case 'invalid-credential':
        return 'Неверные данные для входа';
      default:
        return 'Ошибка: $code';
    }
  }

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
      _setError("Ошибка загрузки локальных данных");
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

        // Обновляем SharedPreferences
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
      _setError("Не удалось загрузить данные из облака");
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
      }, SetOptions(merge: true)); // чтобы не затереть другие данные
    } catch (e) {
      _setError("Не удалось сохранить данные в облако");
      rethrow;
    }
  }

  @override
  Future<bool> signUp(String email, String password, String name, double weight) async {
    _setLoading(true);
    _setError(null);

    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await register(name, weight);
      await _saveToFirestore();
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_translateFirebaseError(e.code));
      return false;
    } catch (e) {
      _setError("Неизвестная ошибка при регистрации");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  @override
  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    _setError(null);

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await loadFromFirestore();

      // Загружаем данные воды и карточек
      await WaterRepository().loadFromFirestore();
      await CardRepository().loadFromFirestore();

      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_translateFirebaseError(e.code));
      return false;
    } catch (e) {
      _setError("Неизвестная ошибка при входе");
      return false;
    } finally {
      _setLoading(false);
    }
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
      _setError("Ошибка при сохранении данных пользователя");
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
      _setError("Не удалось изменить дневную цель");
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
      _setError("Ошибка при выходе из аккаунта");
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
      _setError("Ошибка очистки данных");
    }
  }
}