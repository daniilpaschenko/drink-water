import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../logic/card_repository.dart';
import '../widgets/water_card.dart';
import '../core/constants.dart';

class WaterCardsGrid extends StatelessWidget {
  final Function(dynamic card) onCardTap;

  const WaterCardsGrid({super.key, required this.onCardTap});

  @override
  Widget build(BuildContext context) {
    final cardRepo = context.watch<CardRepository>();
    double screenW = MediaQuery.of(context).size.width;
    // double titleSize = screenW * 0.04;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: screenW * 0.05,
      mainAxisSpacing: screenW * 0.05,
      children: [
        ...cardRepo.customCards.asMap().entries.map((entry) {
          final index = entry.key;
          final card = entry.value;
          final ml = (card.liters * 1000).toInt();

          return WaterCard(
            title: card.title,
            value: "$ml мл",
            icon: appIcons[card.iconName] ?? FontAwesomeIcons.glassWater,
            color: Colors.blue,
            onTap: () => onCardTap(card),
            onLongPress: () => _showDeleteDialog(context, card.title, index),
          );
        }),
        WaterCard(
          title: "Новая тара",
          value: "Жми сюда",
          icon: FontAwesomeIcons.plus,
          color: Colors.red,
          onTap: () => _showAddCardDialog(context),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context, String title, int index) {
    final cardRepo = context.read<CardRepository>();
    double screenW = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        actionsAlignment: MainAxisAlignment.spaceBetween,
        title: Text("Удалить карточку?", 
            textAlign: TextAlign.center, 
            style: TextStyle(fontSize: screenW * 0.04)),
        content: Text("Вы уверены что хотите удалить '$title'?", 
            style: TextStyle(fontSize: screenW * 0.04)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Отмена", style: TextStyle(fontSize: screenW * 0.04)),
          ),
          TextButton(
            onPressed: () async {
              await cardRepo.removeCard(index);
              if (context.mounted) Navigator.pop(context);
            },
            child: Text("Удалить", 
                style: TextStyle(color: Colors.red, fontSize: screenW * 0.04)),
          ),
        ],
      ),
    );
  }

  void _showAddCardDialog(BuildContext context) {
    double screenW = MediaQuery.of(context).size.width;
    double titleSize = screenW * 0.05;
    final titleController = TextEditingController();
    final mlController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    String selectedIcon = "glass"; // дефолтная иконка
    final cardRepo = context.read<CardRepository>();
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder( // нужен чтобы dropdown обновлялся внутри диалога
        builder: (context, setDialogState) => AlertDialog(
          title: Text("Новая тара", style: TextStyle(fontSize: titleSize * 1.2)),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: "Название", labelStyle: TextStyle(fontSize: titleSize * 0.75)),
                  style: TextStyle(fontSize: titleSize),
                  inputFormatters: [LengthLimitingTextInputFormatter(16)],
                  validator: (v) => (v == null || v.trim().isEmpty) ? "Введите название" : null,
                ),
                SizedBox(height: screenW * 0.03),
                TextFormField(
                  controller: mlController,
                  decoration: InputDecoration(labelText: "Количество (мл)", labelStyle: TextStyle(fontSize: titleSize * 0.75)),
                  style: TextStyle(fontSize: titleSize),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (v) {
                    final n = int.tryParse(v ?? "");
                    if (n == null || n < 10 || n > 5000) return "Введите от 10 до 5000 мл";
                    return null;
                  },
                ),
                SizedBox(height: screenW * 0.03),
                DropdownButtonFormField<String>(
                  initialValue: selectedIcon,
                  decoration: InputDecoration(labelText: "Иконка", labelStyle: TextStyle(fontSize: titleSize * 0.75)),
                  items: iconLabels.entries.map((e) => DropdownMenuItem(
                    value: e.key,
                    child: Row(
                      children: [
                        FaIcon(appIcons[e.key], size: titleSize * 1.2),
                        SizedBox(width: screenW * 0.03),
                        Text(e.value, style: TextStyle(fontSize: titleSize)),
                      ],
                    ),
                  )).toList(),
                  onChanged: (v) => setDialogState(() => selectedIcon = v!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Отмена", style: TextStyle(fontSize: titleSize * 0.75)),
            ),
            TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final title = titleController.text.trim();
                  final ml = int.parse(mlController.text.trim());
                  await cardRepo.addCard(title, ml / 1000, selectedIcon);
                  if (context.mounted) Navigator.of(context).pop();
                }
              },
              child: Text("Добавить", style: TextStyle(fontSize: titleSize * 0.75)),
            ),
          ],
        ),
      ),
    );
  }
}