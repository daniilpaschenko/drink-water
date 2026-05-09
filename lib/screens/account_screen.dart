import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/appbar.dart'; // appbar из отдельного файла
import '../widgets/editable_field.dart';
import '../logic/auth_logic.dart';
import 'auth_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _goalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = context.read<UserRepository>().currentUser;
    if (user != null) {
      _nameController = TextEditingController(text: user.name);
      _weightController = TextEditingController(text: user.weight.toStringAsFixed(1));
      _goalController = TextEditingController(text: user.dailyGoal.toStringAsFixed(2));
    }
  }

  // флаги редактирования
  bool _editingName = false;
  bool _editingWeight = false;
  bool _editingGoal = false;

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  Future<void> _logout() async {
    await context.read<UserRepository>().signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context, MaterialPageRoute(builder: (_) => const AuthScreen()), (route) => false,
    );
  }

  Future<void> _saveName() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    await context.read<UserRepository>().register(name, context.read<UserRepository>().currentUser!.weight);
    setState(() => _editingName = false);
  }

  Future<void> _saveWeight() async {
    final weight = double.tryParse(_weightController.text.trim().replaceAll(',', '.'));
    if (weight == null || weight < 20 || weight > 300) return;
    await context.read<UserRepository>().register(context.read<UserRepository>().currentUser!.name, weight);
    setState(() => _editingWeight = false);
  }

  Future<void> _saveGoal() async {
    final goal = double.tryParse(_goalController.text.trim().replaceAll(',', '.'));
    if (goal == null || goal < 1 || goal > 20) return;
    await context.read<UserRepository>().setCustomGoal(goal);
    setState(() => _editingGoal = false);
  }

  @override
  Widget build(BuildContext context) {
    double screenW = MediaQuery.of(context).size.width;
    double titleSize = screenW * 0.04;
    final userRepo = context.watch<UserRepository>();
    if (userRepo.currentUser == null) return const SizedBox();
    final user = userRepo.currentUser!;
    final waterRepo = context.watch<WaterRepository>();
    return Scaffold(
      appBar: buildMainAppBar(context: context, isAccountEnabled: false), // отключение кнопки аккаунта, т.к. уже на этом экране
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenW * 0.08),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: screenW * 0.05),
              Icon(Icons.account_circle, size: screenW * 0.3, color: const Color.fromARGB(255, 15, 11, 218)),
              SizedBox(height: screenW * 0.05),
              EditableField(
                label: "Имя",
                value: "Имя: ${user.name}",
                isEditing: _editingName,
                controller: _nameController,
                onEdit: () => setState(() => _editingName = true),
                onSave: _saveName,
                inputFormatters: [LengthLimitingTextInputFormatter(16)],
                titleSize: titleSize,
              ),
              SizedBox(height: screenW * 0.01),
              EditableField(
                label: "Вес (кг)",
                value: "Вес: ${user.weight.toStringAsFixed(1)} кг",
                isEditing: _editingWeight,
                controller: _weightController,
                onEdit: () => setState(() => _editingWeight = true),
                onSave: _saveWeight,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
                titleSize: titleSize,
              ),
              SizedBox(height: screenW * 0.01),
              Row(
                children: [
                  Expanded(
                    child: _editingGoal
                        ? TextFormField(
                            controller: _goalController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
                            style: TextStyle(fontSize: titleSize),
                            decoration: InputDecoration(
                              labelText: "Дневная цель (л)",
                              labelStyle: TextStyle(fontSize: titleSize * 0.75),
                            ),
                          )
                        : Text("Дневная цель: ${user.dailyGoal.toStringAsFixed(2)} л", style: TextStyle(fontSize: titleSize)),
                  ),
                  IconButton(
                    icon: Icon(_editingGoal ? Icons.check : Icons.edit, color: const Color.fromARGB(255, 15, 11, 218)),
                    onPressed: _editingGoal ? _saveGoal : () => setState(() => _editingGoal = true),
                  ),
                  // кнопка сброса к формуле
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.grey),
                    onPressed: () async {
                      await context.read<UserRepository>().setCustomGoal(null); 
                      if (context.mounted) {
                        _goalController.text = context.read<UserRepository>().currentUser!.dailyGoal.toStringAsFixed(2);
                      }
                      setState(() => _editingGoal = false);
                    },
                  ),
                ],
              ),
              SizedBox(height: screenW * 0.01),
              Row(
                children: [
                  Text("Выпито сегодня: ${waterRepo.drankLiters.toStringAsFixed(2)} л", style: TextStyle(fontSize: titleSize)),
                ],
              ),
              SizedBox(height: screenW * 0.1),
              SizedBox(
                width: screenW * 0.6,
                height: screenW * 0.1,
                child: ElevatedButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      actionsAlignment: MainAxisAlignment.spaceBetween,
                      content: Text("Вы уверены, что хотите выйти из аккаунта?", style: TextStyle(fontSize: screenW * 0.04)),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Отмена", style: TextStyle(fontSize: screenW * 0.04)),
                        ),
                        TextButton(
                          onPressed: _logout,
                          child: Text("Выйти", style: TextStyle(fontSize: screenW * 0.04, color: Colors.red)),
                        )
                      ],
                    )
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text("Выйти из аккаунта", style: TextStyle(fontSize: titleSize, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}