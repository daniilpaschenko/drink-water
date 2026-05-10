abstract class BaseCard {
  String get title;
  double get liters;
  String get iconName;
  Map<String, dynamic> toJson();
}

class CustomCard extends BaseCard {
  @override
  final String title;
  @override
  final double liters;
  @override
  final String iconName;

  CustomCard({required this.title, required this.liters, this.iconName = "droplet"});

  @override
  Map<String, dynamic> toJson() => {"title": title, "liters": liters, "iconName": iconName};

  factory CustomCard.fromJson(Map<String, dynamic> json) =>
      CustomCard(title: json["title"], liters: json["liters"], iconName: json["iconName"] ?? "droplet");
}