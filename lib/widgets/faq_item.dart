import 'package:flutter/material.dart';

class FaqItem extends StatelessWidget {
  final String question;
  final String answer;
  final double titleSize;
  final double screenW;

  const FaqItem({
    super.key,
    required this.question,
    required this.answer,
    required this.titleSize,
    required this.screenW,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(question, style: TextStyle(fontSize: titleSize)),
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: screenW * 0.04,
            right: screenW * 0.04,
            bottom: screenW * 0.03,
          ),
          child: Text(
            answer,
            style: TextStyle(
              fontSize: titleSize,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }
}