import '../../domain/entities/water_entry.dart';

class WaterEntryModel extends WaterEntry {
  WaterEntryModel({
    required super.cardTitle,
    required super.iconName,
    required super.liters,
    required super.time,
  });

  Map<String, dynamic> toJson() => {
    "cardTitle": cardTitle,
    "iconName": iconName,
    "liters": liters,
    "time": time.toIso8601String(),
  };

  factory WaterEntryModel.fromJson(Map<String, dynamic> json) => WaterEntryModel(
    cardTitle: json["cardTitle"],
    iconName: json["iconName"],
    liters: json["liters"],
    time: DateTime.parse(json["time"]),
  );

  static WaterEntryModel fromEntity(WaterEntry entry) => WaterEntryModel(
    cardTitle: entry.cardTitle,
    iconName: entry.iconName,
    liters: entry.liters,
    time: entry.time,
  );
}