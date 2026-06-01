import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../card/domain/repositories/i_card_repository.dart';
import 'water_card.dart';
import '../../../../core/constants.dart';
import '../../../../core/l10n/app_localizations.dart';

class WaterCardsGrid extends StatelessWidget {
  final Function(dynamic card) onCardTap;

  const WaterCardsGrid({super.key, required this.onCardTap});

  @override
  Widget build(BuildContext context) {
    final cardRepo = context.watch<ICardRepository>();
    final loc = AppLocalizations.of(context)!;
    double screenW = MediaQuery.of(context).size.width;

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
          final amount = (card.liters * 1000).toInt().toString();

          return WaterCard(
            title: card.title,
            value: loc.ml(amount),
            icon: appIcons[card.iconName] ?? FontAwesomeIcons.glassWater,
            color: Color.fromARGB(255, 15, 11, 218),
            onTap: () => onCardTap(card),
            onLongPress: () => _showDeleteDialog(context, card.title, index),
          );
        }),
        WaterCard(
          title: loc.newContainer,
          value: loc.tapHere,
          icon: FontAwesomeIcons.plus,
          color: Colors.red,
          onTap: () => _showAddCardDialog(context),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context, String title, int index) {
    final cardRepo = context.read<ICardRepository>();
    final loc = AppLocalizations.of(context)!;
    double screenW = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        actionsAlignment: MainAxisAlignment.spaceBetween,
        title: Text(loc.deleteCard,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: screenW * 0.04)),
        content: Text(loc.confirmDeleteCard(title),
            style: TextStyle(fontSize: screenW * 0.04)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(loc.cancel, style: TextStyle(fontSize: screenW * 0.04)),
          ),
          TextButton(
            onPressed: () async {
              await cardRepo.removeCard(index);
              if (context.mounted) Navigator.pop(context);
            },
            child: Text(loc.delete,
                style: TextStyle(color: Colors.red, fontSize: screenW * 0.04)),
          ),
        ],
      ),
    );
  }

  void _showAddCardDialog(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    double screenW = MediaQuery.of(context).size.width;
    double titleSize = screenW * 0.05;
    final titleController = TextEditingController();
    final mlController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    String selectedIcon = "glass";
    final cardRepo = context.read<ICardRepository>();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(loc.newContainer, style: TextStyle(fontSize: titleSize * 1.2)),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                      labelText: loc.cardTitle,
                      labelStyle: TextStyle(fontSize: titleSize * 0.75)),
                  style: TextStyle(fontSize: titleSize),
                  inputFormatters: [LengthLimitingTextInputFormatter(16)],
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? loc.enterTitle : null,
                ),
                SizedBox(height: screenW * 0.03),
                TextFormField(
                  controller: mlController,
                  decoration: InputDecoration(
                      labelText: loc.amountMl,
                      labelStyle: TextStyle(fontSize: titleSize * 0.75)),
                  style: TextStyle(fontSize: titleSize),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (v) {
                    final n = int.tryParse(v ?? "");
                    if (n == null || n < 10 || n > 5000) return loc.invalidMl;
                    return null;
                  },
                ),
                SizedBox(height: screenW * 0.03),
                DropdownButtonFormField<String>(
                  initialValue: selectedIcon,
                  decoration: InputDecoration(
                      labelText: loc.icon,
                      labelStyle: TextStyle(fontSize: titleSize * 0.75)),
                  items: getIconLabels(loc).entries.map((e) => DropdownMenuItem(
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
              child: Text(loc.cancel, style: TextStyle(fontSize: titleSize * 0.75)),
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
              child: Text(loc.add, style: TextStyle(fontSize: titleSize * 0.75)),
            ),
          ],
        ),
      ),
    );
  }
}