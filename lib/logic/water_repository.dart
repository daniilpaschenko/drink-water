import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/water_entry.dart';

abstract class IWaterRepository {
  double get drankLiters;
  Map<String, double> get waterHistory;
  List<WaterEntry> get todayEntries;
  Future<void> load();
  Future<void> addWater(double liters, {String cardTitle, String iconName});
  Future<void> removeEntry(int index);
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
  @override
  List<WaterEntry> todayEntries = [];

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
      "todayEntries": todayEntries.map((e) => e.toJson()).toList(),
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

      final entriesData = data["todayEntries"] as List<dynamic>?;
      if (entriesData != null && savedDate == today) {
        todayEntries = entriesData.map((e) => WaterEntry.fromJson(e as Map<String, dynamic>)).toList();
      } else {
        todayEntries = [];
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
    final entriesJson = prefs.getString("today_entries");
    if (entriesJson != null && savedDate == today) {
      final List<dynamic> decoded = jsonDecode(entriesJson);
      todayEntries = decoded.map((e) => WaterEntry.fromJson(e)).toList();
    } else {
      todayEntries = [];
    }

    // загрузка истории
    final historyJson = prefs.getString("water_history");
    if (historyJson != null) {
      final Map<String, dynamic> decoded = jsonDecode(historyJson);
      waterHistory = decoded.map((k, v) => MapEntry(k, v.toDouble()));
    }
  }

  @override
  Future<void> addWater(double liters, {String cardTitle = "", String iconName = "droplet"}) async {
    if (drankLiters + liters > 100) return;
    drankLiters += liters;
    final today = DateTime.now().toIso8601String().substring(0, 10);
    waterHistory[today] = drankLiters;
    
    todayEntries.add(WaterEntry(
      cardTitle: cardTitle,
      iconName: iconName,
      liters: liters,
      time: DateTime.now(),
    ));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("drank_liters", drankLiters);
    await prefs.setString("water_history", jsonEncode(waterHistory));
    await prefs.setString("today_entries", jsonEncode(todayEntries.map((e) => e.toJson()).toList()));
    await _saveToFirestore();
    notifyListeners();
  }

  @override // или нет ?
  Future<void> removeEntry(int index) async {
    final entry = todayEntries[index];
    drankLiters -= entry.liters;
    if (drankLiters < 0) drankLiters = 0;
    todayEntries.removeAt(index);
    
    final today = DateTime.now().toIso8601String().substring(0, 10);
    waterHistory[today] = drankLiters;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("drank_liters", drankLiters);
    await prefs.setString("today_entries", jsonEncode(todayEntries.map((e) => e.toJson()).toList()));
    await _saveToFirestore();
    notifyListeners();
  }

  @override
  Future<void> clear() async {
    drankLiters = 0.0;
    todayEntries = [];
    waterHistory = {};
    notifyListeners();
  }
}