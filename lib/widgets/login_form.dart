import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/user_repository.dart';
import '../screens/home_screen.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  Future<void> _submit(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final userRepo = context.read<UserRepository>();
    final success = await userRepo.signIn(email, password);
    if (!context.mounted) return;
    if (success) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final titleSize = screenW * 0.05;
    return Consumer<UserRepository>(
      builder: (context, userRepo, child) {
        // показ ошибки через SnackBar
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
                SizedBox(height: screenW * 0.1),
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
                SizedBox(height: screenW * 0.07),
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
                SizedBox(height: screenW * 0.12),
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
                      "Войти",
                      style: TextStyle(
                      fontSize: titleSize * 0.85,
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