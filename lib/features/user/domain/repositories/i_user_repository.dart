import 'package:flutter/foundation.dart';
import '../../domain/entities/user_data.dart';

abstract class IUserRepository extends ChangeNotifier {
  UserData? get currentUser;
  bool get isLoggedIn;
  bool get isLoading;
  String? get errorMessage;
  bool get isProcessingLink;

  Future<void> load();
  Future<void> register(String name, double weight, {double? customGoal});
  Future<void> setCustomGoal(double? goal);
  Future<void> clear();
  Future<bool> sendSignInLink(String email, {String languageCode = 'ru'});
  Future<bool> signInWithLink(String emailLink);
  Future<void> savePendingRegistration(String name, double weight);
  Future<bool> completePendingRegistration();
  Future<void> signOut();
  void clearError();
}