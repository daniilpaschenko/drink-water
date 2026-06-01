import 'package:flutter/foundation.dart';
import '../../domain/entities/water_entry.dart';

abstract class IWaterRepository extends ChangeNotifier {
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