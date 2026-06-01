import 'package:flutter/material.dart';

class InfoSection extends StatelessWidget {
  final String title;
  final double titleSize;
  final double screenW;
  final Widget child;

  const InfoSection({
    super.key,
    required this.title,
    required this.titleSize,
    required this.screenW,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: titleSize * 1.2,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 15, 11, 218),
          ),
        ),
        SizedBox(height: screenW * 0.03),
        child,
        Divider(color: Colors.grey.shade300, height: screenW * 0.08),
      ],
    );
  }
}