class UserData {
  final String name;
  final double weight;
  final double dailyGoal;
  final double? customGoal;

  UserData({
    required this.name,
    required this.weight,
    this.customGoal,
  }) : dailyGoal = customGoal ?? (weight * 0.033).clamp(1.5, 4.0);
}