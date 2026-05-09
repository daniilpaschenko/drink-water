import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IWaterRepository {
  double get drankLiters;
  Map<String, double> get waterHistory;
  Future<void> load();
  Future<void> addWater(double liters);
  Future<void> clear();
}

class WaterRepository extends ChangeNotifier implements IWaterRepository {
  static final WaterRepository _instance = WaterRepository._internal();
  factory WaterRepository() => _instance;
  WaterRepository._internal();

  @override
  double drankLiters = 0.0;

  @override
  Map<String, double> waterHistory = {};

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String? get _uid => _auth.currentUser?.uid;

  // сохранение в Firestore
  Future<void> _saveToFirestore() async {
    if (_uid == null) return;
    await _firestore.collection("users").doc(_uid).update({
      "waterHistory": waterHistory,
      "drankLiters": drankLiters,
      "lastDate": DateTime.now().toIso8601String().substring(0, 10),
    });
  }

  // загрузка из Firestore
  Future<void> loadFromFirestore() async {
    if (_uid == null) return;
    final doc = await _firestore.collection("users").doc(_uid).get();
    if (doc.exists) {
      final data = doc.data()!;
      final today = DateTime.now().toIso8601String().substring(0, 10);
      final savedDate = data["lastDate"] as String?;

      if (savedDate == today) {
        drankLiters = (data["drankLiters"] as num?)?.toDouble() ?? 0.0;
      } else {
        drankLiters = 0.0;
      }

      final historyData = data["waterHistory"] as Map<String, dynamic>?;
      if (historyData != null) {
        waterHistory = historyData.map((k, v) => MapEntry(k, (v as num).toDouble()));
      }

      // синхронизируем с SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble("drank_liters", drankLiters);
      await prefs.setString("water_history", jsonEncode(waterHistory));
      await prefs.setString("last_date", today);
      notifyListeners();
    }
  }

  @override
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    // если новый день, сброс счётчика
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final savedDate = prefs.getString("last_date");
    if (savedDate == today) {
      drankLiters = prefs.getDouble("drank_liters") ?? 0.0;
    } else {
      drankLiters = 0.0;
      await prefs.setString("last_date", today);
      await prefs.setDouble("drank_liters", 0.0);
    }

    // загрузка истории
    final historyJson = prefs.getString("water_history");
    if (historyJson != null) {
      final Map<String, dynamic> decoded = jsonDecode(historyJson);
      waterHistory = decoded.map((k, v) => MapEntry(k, v.toDouble()));
    }
  }

  @override
  Future<void> addWater(double liters) async {
    if (drankLiters + liters > 100) return; // ограничение 100л
    drankLiters += liters;
    final today = DateTime.now().toIso8601String().substring(0, 10);
    waterHistory[today] = drankLiters;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("drank_liters", drankLiters);
    await prefs.setString("water_history", jsonEncode(waterHistory));
    await _saveToFirestore();
    notifyListeners();
  }

  @override
  Future<void> clear() async {
    drankLiters = 0.0;
    waterHistory = {};
    notifyListeners();
  }
}