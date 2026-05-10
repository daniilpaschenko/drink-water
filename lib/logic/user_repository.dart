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
  Future<void> load();
  Future<void> register(String name, double weight, {double? customGoal});
  Future<void> setCustomGoal(double? goal);
  Future<void> clear();
  Future<void> signUp(String email, String password, String name, double weight);
  Future<void> signIn(String email, String password);
  Future<void> signOut();
}

class UserRepository extends ChangeNotifier implements IUserRepository {
  static final UserRepository _instance = UserRepository._internal();
  factory UserRepository() => _instance;
  UserRepository._internal();

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  UserData? currentUser;

  @override
  bool get isLoggedIn => currentUser != null;

  // получаем uid текущего пользователя
  String? get _uid => _auth.currentUser?.uid;

  @override
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString("user_name");
    final weight = prefs.getDouble("user_weight");
    final customGoal = prefs.getDouble("custom_goal");
    if (name != null && weight != null) {
      currentUser = UserData(name: name, weight: weight, customGoal: customGoal);
    }
  }

  // загрузка из Firestore
  Future<void> loadFromFirestore() async {
    if (_uid == null) return;
    final doc = await _firestore.collection("users").doc(_uid).get();
    if (doc.exists) {
      final data = doc.data()!;
      final name = data["name"] as String;
      final weight = (data["weight"] as num).toDouble();
      final customGoal = data["customGoal"] != null ? (data["customGoal"] as num).toDouble() : null;

      // сохраняем локально
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("user_name", name);
      await prefs.setDouble("user_weight", weight);
      if (customGoal != null) await prefs.setDouble("custom_goal", customGoal);

      currentUser = UserData(name: name, weight: weight, customGoal: customGoal);
      notifyListeners();
    }
  }

  // сохранение в Firestore
  Future<void> _saveToFirestore() async {
    if (_uid == null) return;
    await _firestore.collection("users").doc(_uid).set({
      "name": currentUser!.name,
      "weight": currentUser!.weight,
      "customGoal": currentUser?.customGoal,
      "waterHistory": {},
      "drankLiters": 0.0,
      "lastDate": DateTime.now().toIso8601String().substring(0, 10),
      "cards": [],
    });
  }

  @override
  Future<void> signUp(String email, String password, String name, double weight) async {
    await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await register(name, weight);
    await _saveToFirestore();
    notifyListeners();
  }

  @override
  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    await loadFromFirestore(); // загружаем из облака
    await WaterRepository().loadFromFirestore();
    await CardRepository().loadFromFirestore();
    notifyListeners();
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
    await clear();
  }

  @override
  Future<void> register(String name, double weight, {double? customGoal}) async {
    currentUser = UserData(name: name, weight: weight, customGoal: customGoal ?? currentUser?.customGoal);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_name", name);
    await prefs.setDouble("user_weight", weight);
    await _saveToFirestore(); // сохраняем в облако
    notifyListeners();
  }

  @override
  Future<void> setCustomGoal(double? goal) async {
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
    await _saveToFirestore(); // сохраняем в облако
    notifyListeners();
  }

  @override
  Future<void> clear() async {
    currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }
}