import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/auth_logic.dart';
import 'home_screen.dart';
import 'package:flutter/services.dart'; // для FilteringTextInputFormatter

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // чтобы вызвать проверку всех полей

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final weight = double.parse(_weightController.text.trim().replaceAll(',', '.'));

      final userRepo = context.read<UserRepository>();
      final cardRepo = context.read<CardRepository>();

      await userRepo.register(name, weight);
      if (cardRepo.customCards.isEmpty) {
        await cardRepo.addDefaultCards();
      }

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (_) => const HomeScreen()), (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenW = MediaQuery.of(context).size.width;
    double titleSize = screenW * 0.04;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenW * 0.15),
        child: AppBar(title: Text("Регистрация", style: TextStyle(fontSize: titleSize)))
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                style: TextStyle(fontSize: titleSize),
                decoration: InputDecoration(labelText: "Имя", labelStyle: TextStyle(fontSize: titleSize * 0.75)),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(16),
                ],
                validator: (v) => (v == null || v.trim().isEmpty) ? "Введите имя" : null,
              ),
              SizedBox(height: screenW*0.08),
              TextFormField(
                style: TextStyle(fontSize: titleSize),
                controller: _weightController,
                decoration: InputDecoration(labelText: "Вес (кг)", labelStyle: TextStyle(fontSize: titleSize * 0.75)),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                ],
                validator: (v) {
                  final n = double.tryParse(v?.replaceAll(',', '.') ?? "");
                  if (n == null || n < 20 || n > 300) return "Введите корректный вес";
                  return null;
                },
              ),
              SizedBox(height: screenW*0.08),
              SizedBox(
                width: screenW * 0.7,
                height: screenW * 0.07,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: Text("Зарегистрироваться", style: TextStyle(fontSize: titleSize * 0.75, color: Color.fromARGB(255, 15, 11, 218))),
                ),
              ),
            ],
          ),
        ),
      )    
    );
  }
}