import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/appbar.dart';
import '../widgets/editable_field.dart';
import '../logic/user_repository.dart';
// import '../logic/water_repository.dart';
import 'auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../l10n/app_localizations.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late TextEditingController _nameController;
  late TextEditingController _weightController;
  late TextEditingController _goalController;

  bool _editingName = false;
  bool _editingWeight = false;
  bool _editingGoal = false;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    final user = context.read<UserRepository>().currentUser;
    _nameController = TextEditingController(text: user?.name ?? '');
    _weightController = TextEditingController(text: user?.weight.toStringAsFixed(1) ?? '');
    _goalController = TextEditingController(text: user?.dailyGoal.toStringAsFixed(2) ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  Future<void> _saveName() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final userRepo = context.read<UserRepository>();
    await userRepo.register(name, userRepo.currentUser!.weight);

    if (!mounted) return;
    setState(() => _editingName = false);
  }

  Future<void> _saveWeight() async {
    final weight = double.tryParse(_weightController.text.trim().replaceAll(',', '.'));
    if (weight == null || weight < 20 || weight > 300) return;

    final userRepo = context.read<UserRepository>();
    await userRepo.register(userRepo.currentUser!.name, weight);

    if (!mounted) return;
    setState(() => _editingWeight = false);
  }

  Future<void> _saveGoal() async {
    final goal = double.tryParse(_goalController.text.trim().replaceAll(',', '.'));
    if (goal == null || goal < 1 || goal > 20) return;

    await context.read<UserRepository>().setCustomGoal(goal);

    if (!mounted) return;
    setState(() => _editingGoal = false);
  }

  Future<void> _logout() async {
    await context.read<UserRepository>().signOut();

    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const AuthScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userRepo = context.watch<UserRepository>();
    if (userRepo.currentUser == null) return const SizedBox();
    final user = userRepo.currentUser!;
    // final waterRepo = context.watch<WaterRepository>();

    final loc = AppLocalizations.of(context)!;

    double screenW = MediaQuery.of(context).size.width;
    double titleSize = screenW * 0.04;

    return Scaffold(
      appBar: buildMainAppBar(context: context, isAccountEnabled: false),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenW * 0.08),
          child: Column(
            children: [
              SizedBox(height: screenW * 0.05),
              Icon(Icons.account_circle, size: screenW * 0.3, color: const Color.fromARGB(255, 15, 11, 218)),
              SizedBox(height: screenW * 0.05),

              EditableField(
                label: loc.name,
                value: "${loc.name}: ${user.name}",
                isEditing: _editingName,
                controller: _nameController,
                onEdit: () => setState(() => _editingName = true),
                onSave: _saveName,
                inputFormatters: [LengthLimitingTextInputFormatter(16)],
                titleSize: titleSize,
              ),

              SizedBox(height: screenW * 0.01),

              EditableField(
                label: "${loc.weight} (${loc.kg})",
                value: "${loc.weight}: ${user.weight.toStringAsFixed(1)} кг",
                isEditing: _editingWeight,
                controller: _weightController,
                onEdit: () => setState(() => _editingWeight = true),
                onSave: _saveWeight,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
                titleSize: titleSize,
              ),

              SizedBox(height: screenW * 0.01),

              // Цель (особая обработка)
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
                              labelText: "${loc.dailyGoal} (${loc.unitL})",
                              labelStyle: TextStyle(fontSize: titleSize * 0.75),
                            ),
                          )
                        : Text(
                            "${loc.dailyGoal}: ${user.dailyGoal.toStringAsFixed(2)} ${loc.unitL}",
                            style: TextStyle(fontSize: titleSize),
                          ),
                  ),
                  IconButton(
                    icon: Icon(_editingGoal ? Icons.check : Icons.edit, color: const Color.fromARGB(255, 15, 11, 218)),
                    onPressed: _editingGoal ? _saveGoal : () => setState(() => _editingGoal = true),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.grey),
                    onPressed: () async {
                      await context.read<UserRepository>().setCustomGoal(null);
                      if (!context.mounted) return;
                      _goalController.text = context.read<UserRepository>().currentUser!.dailyGoal.toStringAsFixed(2);
                      setState(() => _editingGoal = false);
                    },
                  ),
                ],
              ),

              SizedBox(height: screenW * 0.1),

              Text(
                "${loc.email}: ${FirebaseAuth.instance.currentUser?.email ?? '—'}",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: titleSize)
              ),

              SizedBox(height: screenW * 0.1),

              // Кнопка выхода
              SizedBox(
                width: screenW * 0.6,
                height: screenW * 0.1,
                child: ElevatedButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      content: Text(
                        loc.wantToLogout,
                        style: TextStyle(fontSize: screenW * 0.04),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(loc.cancel, style: TextStyle(fontSize: screenW * 0.04)),
                        ),
                        TextButton(
                          onPressed: _logout,
                          child: Text(loc.logout, 
                              style: TextStyle(fontSize: screenW * 0.04, color: Colors.red)),
                        ),
                      ],
                    ),
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text(
                    loc.logoutFromAccount,
                    style: TextStyle(fontSize: titleSize, color: Colors.white),
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
}