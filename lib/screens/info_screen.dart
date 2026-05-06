import 'package:flutter/material.dart';
import '../widgets/appbar.dart'; // appbar из отдельного файла

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  // список FAQ
  final List<Map<String, String>> _faq = [
    {
      "question": "Как работает счётчик воды?",
      "answer": "Счётчик выпитой воды сбрасывается автоматически каждый день в полночь."
    },
    {
      "question": "Можно ли добавить свою тару?",
      "answer": "Да! На главном экране нажмите карточку 'Новая тара' и введите название и объём. Для удаления — долгое нажатие на карточку."
    },
  ];

  @override
  Widget build(BuildContext context) {
    double screenW = MediaQuery.of(context).size.width;
    double titleSize = screenW * 0.04;
    return Scaffold(
      appBar: buildMainAppBar(context: context, isInfoEnabled: false), // отключаем кнопку инфо так как уже на этом экране
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenW * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenW * 0.02),
              // описание приложения
              _buildSection(
                screenW: screenW,
                titleSize: titleSize,
                title: "О приложении",
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.w300, color: Colors.black, fontFamily: 'Rubik'),
                    children: [
                      TextSpan(text: "Drink Water", style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: " — приложение для отслеживания потребления воды. Оно помогает следить за дневной нормой, добавлять выпитое количество воды."),
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenW * 0.02),
              // как считается норма
              _buildSection(
                screenW: screenW,
                titleSize: titleSize,
                title: "Формула дневной нормы",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Норма = вес (кг) × 33 мл",
                      style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: screenW * 0.02),
                    Text(
                      "Например, при весе 70 кг:\n70 × 33 = 2310 мл = 2.31 л",
                      style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.w300),
                    ),
                    SizedBox(height: screenW * 0.02),
                    Text(
                      "Минимальная норма: 1.5 л\nМаксимальная норма: 4 л",
                      style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenW * 0.02),
              // FAQ
              _buildSection(
                screenW: screenW,
                titleSize: titleSize,
                title: "Частые вопросы",
                child: Column(
                  children: _faq.map((item) => _buildFaqItem(
                    screenW: screenW,
                    titleSize: titleSize,
                    question: item["question"]!,
                    answer: item["answer"]!,
                  )).toList(),
                ),
              ),
              SizedBox(height: screenW * 0.02),
              // контакты
              _buildSection(
                screenW: screenW,
                titleSize: titleSize,
                title: "Контакты разработчика",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Telegram: @daniil_paschenko", style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.w300)),
                    SizedBox(height: screenW * 0.02),
                    Text("GitHub: github.com/daniilpaschenko", style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.w300)),
                    SizedBox(height: screenW * 0.02),
                  ],
                ),
              ),
              SizedBox(height: screenW * 0.05),
              // текст в самом низу
              Center(
                child: Text(
                  "Пейте воду — будете здоровы",
                  style: TextStyle(fontSize: titleSize * 0.75, color: Colors.grey),
                ),
              ),
              SizedBox(height: screenW * 0.05),
            ],
          ),
        ),
      ),
    );
  }

  // секция с заголовком и контентом
  Widget _buildSection({
    required double screenW,
    required double titleSize,
    required String title,
    required Widget child,
  }) {
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
        Divider(color: Colors.grey.shade300),
      ],
    );
  }

  // элемент FAQ с раскрывающимся ответом
  Widget _buildFaqItem({
    required double screenW,
    required double titleSize,
    required String question,
    required String answer,
  }) {
    return ExpansionTile(
      title: Text(question, style: TextStyle(fontSize: titleSize)),
      children: [
        Padding(
          padding: EdgeInsets.only(left: screenW * 0.04, right: screenW * 0.04, bottom: screenW * 0.03),
          child: Text(answer, style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.w300)),
        ),
      ],
    );
  }
}