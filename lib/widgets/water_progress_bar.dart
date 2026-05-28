import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class WaterProgressBar extends StatelessWidget {
  final double drankLiters;
  final double dailyGoal;
  final double width;
  final double lineHeight;
  final double fontSize;

  const WaterProgressBar({
    super.key,
    required this.drankLiters,
    required this.dailyGoal,
    required this.width,
    required this.lineHeight,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return LinearPercentIndicator(
      animateFromLastPercent: true,
      width: width,
      lineHeight: lineHeight,
      percent: (drankLiters / dailyGoal).clamp(0.0, 1.0),
      center: Text(
        "${(drankLiters / dailyGoal * 100).toStringAsFixed(2)}%",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
      ),
      barRadius: const Radius.circular(10),
      alignment: MainAxisAlignment.center,
      linearGradient: const LinearGradient(
        colors: [
          Color.fromARGB(255, 15, 11, 218),
          Color.fromARGB(255, 54, 132, 235),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 182, 182, 182),
      animation: true,
    );
  }
}
