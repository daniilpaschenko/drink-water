import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class UserData {
  final String name;
  final double weight;
  final double dailyGoal;
  final double? customGoal; // пользовательская цель

  UserData({
    required this.name,
    required this.weight,
    this.customGoal,
  }) : dailyGoal = customGoal ?? (weight * 0.033).clamp(1.5, 4.0);
}

abstract class IUserRepository {
  UserData? get currentUser;
  bool get isLoggedIn;
  Future<void> load();
  Future<void> register(String name, double weight, {double? customGoal});
  Future<void> setCustomGoal(double? goal);
  Future<void> clear();
}

class UserRepository extends ChangeNotifier implements IUserRepository{
  static final UserRepository _instance = UserRepository._internal();
  factory UserRepository() => _instance;
  UserRepository._internal();

  @override
  UserData? currentUser;

  @override
  bool get isLoggedIn => currentUser != null;

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

  @override
  Future<void> register(String name, double weight, {double? customGoal}) async {
    currentUser = UserData(name: name, weight: weight, customGoal: customGoal ?? currentUser?.customGoal);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_name", name);
    await prefs.setDouble("user_weight", weight);
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
    notifyListeners();
  }

  @override
  Future<void> clear() async {
    currentUser = null;
    notifyListeners();
  }
}