import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../logic/user_repository.dart';
import '../logic/card_repository.dart';
import '../screens/home_screen.dart';

class RegisterForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController weightController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const RegisterForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.weightController,
    required this.emailController,
    required this.passwordController,
  });

  Future<void> _submit(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    final name = nameController.text.trim();
    final weight = double.parse(weightController.text.trim().replaceAll(',', '.'));
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final userRepo = context.read<UserRepository>();
    final cardRepo = context.read<CardRepository>();
    final success = await userRepo.signUp(email, password, name, weight);
    if (!context.mounted) return;

    if (success) {
      // стандартные карточки, если их ещё нет
      if (cardRepo.customCards.isEmpty) {
        await cardRepo.addDefaultCards();
      }
      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    }
    // ошибка через Consumer ниже
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final titleSize = screenW * 0.05;

    return Consumer<UserRepository>(
      builder: (context, userRepo, child) {
        if (userRepo.errorMessage != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(userRepo.errorMessage!),
                backgroundColor: Colors.red.shade700,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(12),
              ),
            );
            userRepo.clearError();
          });
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: nameController,
                  style: TextStyle(fontSize: titleSize),
                  decoration: InputDecoration(
                    labelText: "Имя",
                    labelStyle: TextStyle(fontSize: titleSize * 0.8),
                  ),
                  inputFormatters: [LengthLimitingTextInputFormatter(16)],
                  validator: (v) => (v == null || v.trim().isEmpty) ? "Введите имя" : null,
                ),
                SizedBox(height: screenW * 0.06),

                TextFormField(
                  controller: weightController,
                  style: TextStyle(fontSize: titleSize),
                  decoration: InputDecoration(
                    labelText: "Вес (кг)",
                    labelStyle: TextStyle(fontSize: titleSize * 0.8),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
                  validator: (v) {
                    final n = double.tryParse(v?.replaceAll(',', '.') ?? "");
                    if (n == null || n < 20 || n > 300) {
                      return "Введите корректный вес (20–300 кг)";
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenW * 0.06),

                TextFormField(
                  controller: emailController,
                  style: TextStyle(fontSize: titleSize),
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(fontSize: titleSize * 0.8),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => (v == null || !v.contains("@")) ? "Введите корректный email" : null,
                ),
                SizedBox(height: screenW * 0.06),

                TextFormField(
                  controller: passwordController,
                  style: TextStyle(fontSize: titleSize),
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Пароль",
                    labelStyle: TextStyle(fontSize: titleSize * 0.8),
                  ),
                  validator: (v) => (v == null || v.length < 6) ? "Минимум 6 символов" : null,
                ),
                SizedBox(height: screenW * 0.1),

                SizedBox(
                  height: screenW * 0.08,
                  child: ElevatedButton(
                    onPressed: userRepo.isLoading ? null : () => _submit(context),
                    child: userRepo.isLoading
                    ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                    )
                    : Text(
                      "Зарегистрироваться",
                      style: TextStyle(
                      fontSize: titleSize * 0.8,
                      fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}