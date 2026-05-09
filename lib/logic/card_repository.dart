import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseCard {
  String get title;
  double get liters;
  String get iconName;
  Map<String, dynamic> toJson();
}

class CustomCard extends BaseCard {
  @override
  final String title;
  @override
  final double liters;
  @override
  final String iconName;

  CustomCard({required this.title, required this.liters, this.iconName = "droplet"});

  @override
  Map<String, dynamic> toJson() => {"title": title, "liters": liters, "iconName": iconName};

  factory CustomCard.fromJson(Map<String, dynamic> json) =>
      CustomCard(title: json["title"], liters: json["liters"], iconName: json["iconName"] ?? "droplet");
}

abstract class ICardRepository {
  List<BaseCard> get customCards;
  Future<void> load();
  Future<void> addCard(String title, double liters, String iconName);
  Future<void> removeCard(int index);
  Future<void> addDefaultCards();
  Future<void> clear();
}

class CardRepository extends ChangeNotifier implements ICardRepository {
  static final CardRepository _instance = CardRepository._internal();
  factory CardRepository() => _instance;
  CardRepository._internal();

  @override
  List<BaseCard> customCards = [];

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String? get _uid => _auth.currentUser?.uid;

  Future<void> _saveToFirestore() async {
    if (_uid == null) return;
    await _firestore.collection("users").doc(_uid).update({
      "cards": customCards.map((e) => e.toJson()).toList(),
    });
  }

  Future<void> loadFromFirestore() async {
    if (_uid == null) return;
    final doc = await _firestore.collection("users").doc(_uid).get();
    if (doc.exists) {
      final data = doc.data()!;
      final cardsData = data["cards"] as List<dynamic>?;
      if (cardsData != null) {
        customCards = cardsData.map((e) => CustomCard.fromJson(e as Map<String, dynamic>)).toList();
        await _save(); // синхронизируем с SharedPreferences
      }
      notifyListeners();
    }
  }

  @override
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final cardsJson = prefs.getStringList("custom_cards") ?? [];
    customCards = cardsJson.map((e) => CustomCard.fromJson(jsonDecode(e))).toList();
  }

  @override
  Future<void> addCard(String title, double liters, String iconName) async {
    customCards.add(CustomCard(title: title, liters: liters, iconName: iconName));
    await _save();
    await _saveToFirestore();
    notifyListeners();
  }

  @override
  Future<void> removeCard(int index) async {
    customCards.removeAt(index);
    await _save();
    await _saveToFirestore();
    notifyListeners();
  }

  @override
  Future<void> addDefaultCards() async {
    customCards = [
      CustomCard(title: "Стакан", liters: 0.25, iconName: 'glass'),
      CustomCard(title: "Бутылка", liters: 0.5, iconName: 'bottle'),
    ];
    await _save();
    await _saveToFirestore();
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      "custom_cards",
      customCards.map((e) => jsonEncode(e.toJson())).toList(),
    );
    await _saveToFirestore();
  }

  @override
  Future<void> clear() async {
    customCards = [];
    notifyListeners();
  }
}