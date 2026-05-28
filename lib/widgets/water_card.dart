import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WaterCard extends StatefulWidget {
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
  State<WaterCard> createState() => _WaterCardState();
}

class _WaterCardState extends State<WaterCard> {
  bool _tapped = false;

  void _handleTap() {
    setState(() => _tapped = true);
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _tapped = false);
    });
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double iconSize = constraints.maxWidth * 0.3;
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: _handleTap,
            onLongPress: widget.onLongPress,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              decoration: BoxDecoration(
                color: _tapped
                    ? const Color.fromARGB(255, 180, 180, 180)
                    : Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: const Color.fromARGB(255, 15, 11, 218),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.icon is IconData && widget.icon is! FaIconData
                      ? Icon(widget.icon, color: widget.color, size: iconSize)
                      : FaIcon(widget.icon, color: widget.color, size: iconSize),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  Text(
                    widget.title,
                    style: TextStyle(fontSize: constraints.maxWidth * 0.08),
                  ),
                  Text(
                    widget.value,
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