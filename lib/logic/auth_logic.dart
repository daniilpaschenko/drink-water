import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_repository.dart';
import 'water_repository.dart';
import 'card_repository.dart';

export 'user_repository.dart';
export 'water_repository.dart';
export 'card_repository.dart';

class AuthLogic extends ChangeNotifier{
  static final AuthLogic _instance = AuthLogic._internal(
    UserRepository(),
    WaterRepository(),
    CardRepository(),
  );
  factory AuthLogic() => _instance;

  final IUserRepository user;
  final IWaterRepository water;
  final ICardRepository cards;

  AuthLogic._internal(this.user, this.water, this.cards);

  bool get isLoggedIn => user.isLoggedIn;

  Future<void> load() async {
    await user.load();
    await water.load();
    await cards.load();
    notifyListeners();
  }

  Future<void> register(String name, double weight) async {
    await user.register(name, weight);
    if (cards.customCards.isEmpty) {
      await cards.addDefaultCards();
    }
    notifyListeners();
  }

  Future<void> logout() async {
    await user.clear();
    await water.clear();
    await cards.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }
  
  Future<void> addWater(double liters) async {
    await water.addWater(liters);
    notifyListeners();
  }

  Future<void> addCard(String title, double liters, String iconName) async {
    await cards.addCard(title, liters, iconName);
    notifyListeners();
  }

  Future<void> removeCard(int index) async {
    await cards.removeCard(index);
    notifyListeners();
  }

  Future<void> setCustomGoal(double? goal) async {
    await user.setCustomGoal(goal);
    notifyListeners();
  }
}