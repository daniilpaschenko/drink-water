import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/water_entry.dart';
import 'package:injectable/injectable.dart';

abstract class IWaterRepository extends ChangeNotifier{
  double get drankLiters;
  Map<String, double> get waterHistory;
  List<WaterEntry> get todayEntries;

  bool get isLoading;
  String? get errorMessage;

  Future<void> load();
  Future<bool> addWater(double liters, {String cardTitle = "", String iconName = "droplet"});
  Future<bool> removeEntry(int index);
  Future<void> clear();
  void clearError();
  Future<void> loadFromFirestore();
}

@LazySingleton(as: IWaterRepository)
class WaterRepository extends ChangeNotifier implements IWaterRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  WaterRepository(this._auth, this._firestore);

  // флаги обработки ошибок
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
  double drankLiters = 0.0;

  @override
  Map<String, double> waterHistory = {};

  @override
  List<WaterEntry> todayEntries = [];

  String? get _uid => _auth.currentUser?.uid;

  Future<void> _saveToFirestore() async {
    if (_uid == null) return;
    try {
      await _firestore.collection("users").doc(_uid).update({
        "waterHistory": waterHistory,
        "drankLiters": drankLiters,
        "lastDate": DateTime.now().toIso8601String().substring(0, 10),
        "todayEntries": todayEntries.map((e) => e.toJson()).toList(),
      });
    } catch (e) {
      _setError("Failed to save water data to the cloud");
      rethrow;
    }
  }

  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final today = DateTime.now().toIso8601String().substring(0, 10);
      await prefs.setDouble("drank_liters", drankLiters);
      await prefs.setString("water_history", jsonEncode(waterHistory));
      await prefs.setString("last_date", today);
      await prefs.setString(
        "today_entries",
        jsonEncode(todayEntries.map((e) => e.toJson()).toList()),
      );
    } catch (e) {
      _setError("Error saving data locally");
    }
  }

  @override
  Future<void> loadFromFirestore() async {
    if (_uid == null) return;
    _setLoading(true);
    _setError(null);
    try {
      final doc = await _firestore.collection("users").doc(_uid).get();
      if (!doc.exists || doc.data() == null) return;
      final data = doc.data()!;
      final today = DateTime.now().toIso8601String().substring(0, 10);
      final savedDate = data["lastDate"] as String?;

      drankLiters = (savedDate == today) ? (data["drankLiters"] as num?)?.toDouble() ?? 0.0 : 0.0;

      final historyData = data["waterHistory"] as Map<String, dynamic>?;
      waterHistory = historyData?.map((k, v) => MapEntry(k, (v as num).toDouble())) ?? {};

      final entriesData = data["todayEntries"] as List<dynamic>?;
      todayEntries = (savedDate == today && entriesData != null)
      ? entriesData.map((e) => WaterEntry.fromJson(e as Map<String, dynamic>)).toList() : [];
      await _saveToPrefs();
      notifyListeners();
    } catch (e) {
      _setError("Failed to load water data from the cloud");
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

      final historyJson = prefs.getString("water_history");
      if (historyJson != null) {
        final Map<String, dynamic> decoded = jsonDecode(historyJson);
        waterHistory = decoded.map((k, v) => MapEntry(k, (v as num).toDouble()));
      }
      notifyListeners();
    } catch (e) {
      _setError("Error loading water data from local storage");
    } finally {
      _setLoading(false);
    }
  }

  @override
  Future<bool> addWater(double liters, {String cardTitle = "", String iconName = "droplet"}) async {
    if (liters <= 0) {
      _setError("The volume must be greater than zero");
      return false;
    }
    _setLoading(true);
    _setError(null);
    try {
      drankLiters += liters;
      final today = DateTime.now().toIso8601String().substring(0, 10);
      waterHistory[today] = drankLiters;
      todayEntries.add(WaterEntry(
        cardTitle: cardTitle,
        iconName: iconName,
        liters: liters,
        time: DateTime.now(),
      ));
      await _saveToPrefs();
      await _saveToFirestore();
      notifyListeners();
      return true;
    } catch (e) {
      _setError("Error adding water record");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  @override
  Future<bool> removeEntry(int index) async {
    if (index < 0 || index >= todayEntries.length) {
      _setError("Invalid record index");
      return false;
    }
    _setLoading(true);
    _setError(null);
    try {
      final entry = todayEntries[index];
      drankLiters -= entry.liters;
      if (drankLiters < 0) drankLiters = 0.0;
      todayEntries.removeAt(index);
      final today = DateTime.now().toIso8601String().substring(0, 10);
      waterHistory[today] = drankLiters;
      await _saveToPrefs();
      await _saveToFirestore();
      notifyListeners();
      return true;
    } catch (e) {
      _setError("Error deleting a record");
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
      drankLiters = 0.0;
      todayEntries = [];
      waterHistory = {};
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove("drank_liters");
      await prefs.remove("today_entries");
      await prefs.remove("water_history");
      notifyListeners();
    } catch (e) {
      _setError("Error clearing water data");
    } finally {
      _setLoading(false);
    }
  }
}