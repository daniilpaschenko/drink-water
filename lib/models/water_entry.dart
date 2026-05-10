class WaterEntry {
  final String cardTitle;
  final String iconName;
  final double liters;
  final DateTime time;

  WaterEntry({
    required this.cardTitle,
    required this.iconName,
    required this.liters,
    required this.time,
  });

  Map<String, dynamic> toJson() => {
    "cardTitle": cardTitle,
    "iconName": iconName,
    "liters": liters,
    "time": time.toIso8601String(),
  };

  factory WaterEntry.fromJson(Map<String, dynamic> json) => WaterEntry(
    cardTitle: json["cardTitle"],
    iconName: json["iconName"],
    liters: json["liters"],
    time: DateTime.parse(json["time"]),
  );
}