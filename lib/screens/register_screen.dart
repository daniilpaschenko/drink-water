import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/user_repository.dart';
import '../logic/card_repository.dart';
import 'home_screen.dart';
import 'package:flutter/services.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true; // скрывать пароль
  String? _errorMessage; // сообщение об ошибке от Firebase

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _errorMessage = null);
      final name = _nameController.text.trim();
      final weight = double.parse(_weightController.text.trim().replaceAll(',', '.'));
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      final userRepo = context.read<UserRepository>();
      final cardRepo = context.read<CardRepository>();

      try {
        await userRepo.signUp(email, password, name, weight);
        if (cardRepo.customCards.isEmpty) {
          await cardRepo.addDefaultCards();
        }
        if (!mounted) return;
        if (userRepo.currentUser == null) {
          setState(() => _errorMessage = "Ошибка регистрации. Попробуйте снова");
          return;
        }
        Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (_) => const HomeScreen()), (route) => false,
        );
      } catch (e) {
        setState(() => _errorMessage = _parseFirebaseError(e.toString()));
      }
    }
  }

  // перевод ошибок Firebase на русский
  String _parseFirebaseError(String error) {
    if (error.contains("email-already-in-use")) return "Этот email уже используется";
    if (error.contains("weak-password")) return "Пароль слишком слабый — минимум 6 символов";
    if (error.contains("invalid-email")) return "Некорректный email";
    return "Ошибка регистрации. Попробуйте снова";
  }

  @override
  Widget build(BuildContext context) {
    double screenW = MediaQuery.of(context).size.width;
    double titleSize = screenW * 0.04;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenW * 0.15),
        child: AppBar(title: Text("Регистрация", style: TextStyle(fontSize: titleSize))),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  style: TextStyle(fontSize: titleSize),
                  decoration: InputDecoration(labelText: "Имя", labelStyle: TextStyle(fontSize: titleSize * 0.75)),
                  inputFormatters: [LengthLimitingTextInputFormatter(16)],
                  validator: (v) => (v == null || v.trim().isEmpty) ? "Введите имя" : null,
                ),
                SizedBox(height: screenW * 0.05),
                TextFormField(
                  style: TextStyle(fontSize: titleSize),
                  controller: _weightController,
                  decoration: InputDecoration(labelText: "Вес (кг)", labelStyle: TextStyle(fontSize: titleSize * 0.75)),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
                  validator: (v) {
                    final n = double.tryParse(v?.replaceAll(',', '.') ?? "");
                    if (n == null || n < 20 || n > 300) return "Введите корректный вес";
                    return null;
                  },
                ),
                SizedBox(height: screenW * 0.05),
                TextFormField(
                  controller: _emailController,
                  style: TextStyle(fontSize: titleSize),
                  decoration: InputDecoration(labelText: "Email", labelStyle: TextStyle(fontSize: titleSize * 0.75)),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => (v == null || !v.contains("@")) ? "Введите корректный email" : null,
                ),
                SizedBox(height: screenW * 0.05),
                TextFormField(
                  controller: _passwordController,
                  style: TextStyle(fontSize: titleSize),
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: "Пароль",
                    labelStyle: TextStyle(fontSize: titleSize * 0.75),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (v) => (v == null || v.length < 6) ? "Минимум 6 символов" : null,
                ),
                SizedBox(height: screenW * 0.05),
                if (_errorMessage != null)
                  Text(_errorMessage!, style: TextStyle(color: Colors.red, fontSize: titleSize * 0.85)),
                SizedBox(height: screenW * 0.05),
                SizedBox(
                  width: screenW * 0.7,
                  height: screenW * 0.07,
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: Text("Зарегистрироваться", style: TextStyle(fontSize: titleSize * 0.75, color: const Color.fromARGB(255, 15, 11, 218))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}