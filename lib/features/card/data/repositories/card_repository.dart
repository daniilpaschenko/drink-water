import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/custom_card.dart';
import '../../../../core/l10n/app_localizations.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/i_card_repository.dart';
import '../models/custom_card_model.dart';

@LazySingleton(as: ICardRepository)
class CardRepository extends ChangeNotifier implements ICardRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  CardRepository(this._auth, this._firestore);

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
  List<BaseCard> customCards = [];

  String? get _uid => _auth.currentUser?.uid;

  bool get _isAnonymous => _auth.currentUser?.isAnonymous ?? false;

  Future<void> _saveToFirestore() async {
    if (_uid == null) return;
    try {
      await _firestore.collection("users").doc(_uid).set({
        "cards": customCards.map((e) => CustomCardModel.fromEntity(e as CustomCard).toJson()).toList(),
      }, SetOptions(merge: true)); // ← set вместо update
    } catch (e) {
      _setError("Failed to save cards to the cloud");
      rethrow;
    }
}

  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        "custom_cards",
        customCards.map((e) => jsonEncode(CustomCardModel.fromEntity(e as CustomCard).toJson())).toList(),
      );
    } catch (e) {
      _setError("Error saving cards locally");
    }
  }

  @override
  Future<void> loadFromFirestore() async {
    if (_uid == null) return;
    _setLoading(true);
    _setError(null);
    try {
      final doc = await _firestore.collection("users").doc(_uid).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        final cardsData = data["cards"] as List<dynamic>? ?? [];
        customCards = cardsData
            .map((e) => CustomCardModel.fromJson(e as Map<String, dynamic>))
            .toList();
        await _saveToPrefs();
        notifyListeners();
      }
    } catch (e) {
      _setError("Failed to load cards from the cloud");
    } finally {
      _setLoading(false);
    }
  }

  @override
  Future<void> load() async {
    _setLoading(true);
    _setError(null);
    try {
      final prefs = await SharedPreferences.getInstance();
      final cardsJson = prefs.getStringList("custom_cards") ?? [];
      customCards = cardsJson
          .map((e) => CustomCardModel.fromJson(jsonDecode(e)))
          .toList();
      notifyListeners();
    } catch (e) {
      _setError("Error loading cards from local storage");
    } finally {
      _setLoading(false);
    }
  }

  @override
  Future<bool> addCard(String title, double liters, String iconName) async {
    _setLoading(true);
    _setError(null);
    try {
      customCards.add(
        CustomCard(title: title, liters: liters, iconName: iconName),
      );
      await _saveToPrefs();
      if (!_isAnonymous) await _saveToFirestore();
      notifyListeners();
      return true;
    } catch (e) {
      _setError("Failed to add card");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  @override
  Future<bool> removeCard(int index) async {
    if (index < 0 || index >= customCards.length) {
      _setError("Invalid card index");
      return false;
    }
    _setLoading(true);
    _setError(null);
    try {
      customCards.removeAt(index);
      await _saveToPrefs();
      if (!_isAnonymous) await _saveToFirestore();
      notifyListeners();
      return true;
    } catch (e) {
      _setError("Failed to delete card");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  @override
  Future<bool> addDefaultCards(AppLocalizations loc) async {
    _setLoading(true);
    _setError(null);
    try {
      customCards = [
        CustomCard(
          title: loc.defaultCardGlass,
          liters: 0.25,
          iconName: 'glass',
        ),
        CustomCard(
          title: loc.defaultCardBottle,
          liters: 0.5,
          iconName: 'bottle',
        ),
      ];
      await _saveToPrefs();
      if (!_isAnonymous) await _saveToFirestore();
      notifyListeners();
      return true;
    } catch (e) {
      _setError("Failed to add default cards");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  @override
  Future<void> clear() async {
    _setLoading(true);
    _setError(null);
    try {
      customCards = [];
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove("custom_cards");
      notifyListeners();
    } catch (e) {
      _setError("Error clearing cards");
    } finally {
      _setLoading(false);
    }
  }
}