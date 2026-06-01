import '../../domain/entities/custom_card.dart';

class CustomCardModel extends CustomCard {
  CustomCardModel({
    required super.title,
    required super.liters,
    super.iconName,
  });

  Map<String, dynamic> toJson() => {
    "title": title,
    "liters": liters,
    "iconName": iconName,
  };

  factory CustomCardModel.fromJson(Map<String, dynamic> json) => CustomCardModel(
    title: json["title"],
    liters: json["liters"],
    iconName: json["iconName"] ?? "droplet",
  );

  static CustomCardModel fromEntity(CustomCard card) => CustomCardModel(
    title: card.title,
    liters: card.liters,
    iconName: card.iconName,
  );
}