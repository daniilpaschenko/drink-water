import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WaterCard extends StatelessWidget {
  final String title;
  final String value;
  final dynamic icon;
  final Color color;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const WaterCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double iconSize = constraints.maxWidth * 0.3;
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onTap,
            onLongPress: onLongPress,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color.fromARGB(255, 15, 11, 218)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon is IconData && icon is! FaIconData
                      ? Icon(icon, color: color, size: iconSize)
                      : FaIcon(icon, color: color, size: iconSize),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  Text(
                    title,
                    style: TextStyle(fontSize: constraints.maxWidth * 0.08),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: constraints.maxWidth * 0.12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}