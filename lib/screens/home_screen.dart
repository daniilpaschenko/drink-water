import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../logic/user_repository.dart';
import '../logic/water_repository.dart';
import '../logic/card_repository.dart';
import '../widgets/appbar.dart';
import '../widgets/water_card.dart';
import '../widgets/water_progress_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/water_entry_tile.dart';
// import '../models/water_entry.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Map<String, dynamic> _iconMap = {
    "droplet": FontAwesomeIcons.droplet,
    "glass": FontAwesomeIcons.glassWater,
    "bottle": FontAwesomeIcons.bottleWater,
    "mug": FontAwesomeIcons.mugHot,
    "bucket": FontAwesomeIcons.bucket,
    "plate": FontAwesomeIcons.bowlFood
  };

  final Map<String, String> _iconLabels = {
    "droplet": "Капля",
    "glass": "Стакан",
    "bottle": "Бутылка",
    "mug": "Кружка",
    "bucket": "Ведро",
    "plate": "Тарелка",
  };

  void _showSuccess(double liters) {
    ScaffoldMessenger.of(context).clearSnackBars();
    final controller = ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Успешно!", textAlign: TextAlign.start),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: "Отменить",
          onPressed: () {
            context.read<WaterRepository>().addWater(-liters);
          },
        ),
      ),
    );
    Future.delayed(const Duration(seconds: 3), () {
      controller.close();
    });
  }

  void _showAddCardDialog() {
    double screenW = MediaQuery.of(context).size.width;
    double titleSize = screenW * 0.04;
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
                  items: _iconLabels.entries.map((e) => DropdownMenuItem(
                    value: e.key,
                    child: Row(
                      children: [
                        FaIcon(_iconMap[e.key], size: titleSize * 1.2),
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

  @override
  Widget build(BuildContext context) {
    final userRepo = context.watch<UserRepository>();
    final waterRepo = context.watch<WaterRepository>();
    final cardRepo = context.watch<CardRepository>();
    if (userRepo.currentUser == null) return const SizedBox();
    final user = userRepo.currentUser!;
    return Scaffold(
      appBar: buildMainAppBar(context: context),
      body: LayoutBuilder(
        builder: (context, screenConstraints) {
          double screenW = screenConstraints.maxWidth;
          double titleSize = screenW * 0.04;
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenW * 0.05), // отступы 5% от ширины
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenW * 0.05),
                  WaterProgressBar(
                      drankLiters: waterRepo.drankLiters,
                      dailyGoal: user.dailyGoal,
                      width: screenConstraints.maxWidth - (screenW * 0.1),
                      lineHeight: screenW * 0.08,
                      fontSize: screenW * 0.04,
                    ),
                  Text(
                    "Привет, ${user.name}!\nСегодня Вы выпили ${waterRepo.drankLiters.toStringAsFixed(2)} л из ${user.dailyGoal.toStringAsFixed(2)} л",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: titleSize, 
                    ),
                  ),
                  SizedBox(height: screenW * 0.05),
                  Text(
                    "Добавьте выпитое количество воды:",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: titleSize, 
                    ),
                  ),
                  SizedBox(height: screenW * 0.01),
                  Text("(Долгое нажатие на карточку удаляет её)", textAlign: TextAlign.center,
                  style: TextStyle(fontSize: titleSize*0.8, fontWeight: FontWeight.w300)),
                  SizedBox(height: screenW * 0.06),
                  GridView.count(
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
                        // ?? - защита от ошибки при будующих удалений иконок
                        return WaterCard(
                          title: card.title,
                          value: "$ml мл",
                          icon: _iconMap[card.iconName] ?? FontAwesomeIcons.glassWater,
                          color: Colors.blue,
                          onTap: () {
                            waterRepo.addWater(card.liters, cardTitle: card.title, iconName: card.iconName);
                            _showSuccess(card.liters);
                          },
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                actionsAlignment: MainAxisAlignment.spaceBetween,
                                title: Text("Удалить карточку?", textAlign: TextAlign.center, style: TextStyle(fontSize: screenW * 0.04)),
                                content: Text("Вы уверены что хотите удалить '${card.title}'?", style: TextStyle(fontSize: screenW * 0.04)),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("Отмена", style: TextStyle(fontSize: screenW * 0.04)),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await cardRepo.removeCard(index);
                                      if (context.mounted) Navigator.of(context).pop();
                                    },
                                    child: Text("Удалить", style: TextStyle(color: Colors.red, fontSize: screenW * 0.04)),
                                  ),
                                ],
                              ),
                            );
                          }
                        );
                      }),
                      WaterCard(
                        title: "Новая тара",
                        value: "Жми сюда",
                        icon: FontAwesomeIcons.plus,
                        color: Colors.red,
                        onTap: _showAddCardDialog,
                      ),
                    ],
                  ),
                  SizedBox(height: screenW * 0.1),
                  Text(
                    "Записи за сегодня",
                    style: TextStyle(fontSize: titleSize),
                  ),
                  // лог выпитой воды
                  if (waterRepo.todayEntries.isNotEmpty) ...[
                    SizedBox(height: screenW * 0.02),
                    ...waterRepo.todayEntries.asMap().entries.map((entry) {
                      return WaterEntryTile(
                        entry: entry.value,
                        index: entry.key,
                        iconMap: _iconMap,
                        onDelete: () => waterRepo.removeEntry(entry.key),
                      );
                    }),
                  ],
                  SizedBox(height: screenW * 0.1),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}