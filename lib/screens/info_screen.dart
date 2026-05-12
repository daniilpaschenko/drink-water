import 'package:flutter/material.dart';
import '../widgets/appbar.dart'; // appbar из отдельного файла
import '../core/constants.dart';
import '../widgets/info_section.dart';
import '../widgets/faq_item.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenW = MediaQuery.of(context).size.width;
    double titleSize = screenW * 0.04;

    return Scaffold(
      appBar: buildMainAppBar(context: context, isInfoEnabled: false),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenW * 0.05),
          child: Column(
            children: [
              SizedBox(height: screenW * 0.02),

              InfoSection(
                title: "О приложении",
                titleSize: titleSize,
                screenW: screenW,
                child: _buildAboutText(titleSize),
              ),

              InfoSection(
                title: "Формула дневной нормы",
                titleSize: titleSize,
                screenW: screenW,
                child: _buildFormulaSection(titleSize, screenW),
              ),

              InfoSection(
                title: "Частые вопросы",
                titleSize: titleSize,
                screenW: screenW,
                child: Column(
                  children: faq.map((item) => FaqItem(
                    question: item["question"]!,
                    answer: item["answer"]!,
                    titleSize: titleSize,
                    screenW: screenW,
                  )).toList(),
                ),
              ),

              InfoSection(
                title: "Контакты разработчика",
                titleSize: titleSize,
                screenW: screenW,
                child: _buildContacts(titleSize),
              ),

              SizedBox(height: screenW * 0.05),
              Center(
                child: Text(
                  "Пейте воду — будете здоровы",
                  style: TextStyle(
                    fontSize: titleSize * 0.75,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(height: screenW * 0.05),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAboutText(double titleSize) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(
          fontSize: titleSize,
          fontWeight: FontWeight.w300,
          color: Colors.black,
          fontFamily: 'Rubik',
        ),
        children: const [
          TextSpan(
            text: "Drink Water",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: " — приложение для отслеживания потребления воды. "
                "Оно помогает следить за дневной нормой, добавляя выпитое количество воды.",
          ),
        ],
      ),
    );
  }

  Widget _buildFormulaSection(double titleSize, double screenW) {
    return Column(
      children: [
        Text(
          "Норма = вес (кг) × 33 мл",
          style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: screenW * 0.02),
        Text(
          "Например, при весе 70 кг:\n70 × 33 = 2310 мл = 2.31 л",
          style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.w300),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: screenW * 0.02),
        Text(
          "Минимальная норма: 1.5 л\nМаксимальная норма: 4 л",
          style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.w300),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildContacts(double titleSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Telegram: @daniil_paschenko", 
            style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.w300)),
        SizedBox(height: 12),
        Text("GitHub: github.com/daniilpaschenko", 
            style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.w300)),
      ],
    );
  }
}