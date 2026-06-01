import 'package:flutter/foundation.dart';
import '../../domain/entities/custom_card.dart';
import '../../../../core/l10n/app_localizations.dart';

abstract class ICardRepository extends ChangeNotifier {
  List<BaseCard> get customCards;
  bool get isLoading;
  String? get errorMessage;

  Future<void> load();
  Future<bool> addCard(String title, double liters, String iconName);
  Future<bool> removeCard(int index);
  Future<bool> addDefaultCards(AppLocalizations loc);
  Future<void> clear();
  void clearError();
  Future<void> loadFromFirestore();
}