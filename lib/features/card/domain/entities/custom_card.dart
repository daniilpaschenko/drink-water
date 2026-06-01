abstract class BaseCard {
  String get title;
  double get liters;
  String get iconName;
}

class CustomCard extends BaseCard {
  @override
  final String title;
  @override
  final double liters;
  @override
  final String iconName;

  CustomCard({
    required this.title,
    required this.liters,
    this.iconName = "droplet",
  });
}