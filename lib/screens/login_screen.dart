import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/user_repository.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true; // скрывать пароль
  String? _errorMessage; // сообщение об ошибке от Firebase

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _errorMessage = null);
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      try {
        await context.read<UserRepository>().signIn(email, password);
        if (!mounted) return;
        
        // если данных нет локально — отправляем на регистрацию данных
        if (context.read<UserRepository>().currentUser == null) {
          // здесь потом будет загрузка из Firestore
          setState(() => _errorMessage = "Данные не найдены. Зарегистрируйтесь заново");
          return;
        }
        
        Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (_) => const HomeScreen()), (route) => false,
        );
      } catch (e) {
        if (!mounted) return;
        setState(() => _errorMessage = _parseFirebaseError(e.toString()));
      }
    }
  }

  // перевод ошибок на русский
  String _parseFirebaseError(String error) {
    if (error.contains("user-not-found")) return "Пользователь не найден";
    if (error.contains("wrong-password")) return "Неверный пароль";
    if (error.contains("invalid-email")) return "Некорректный email";
    if (error.contains("invalid-credential")) return "Неверный email или пароль";
    return "Ошибка входа. Попробуйте снова";
  }

  @override
  Widget build(BuildContext context) {
    double screenW = MediaQuery.of(context).size.width;
    double titleSize = screenW * 0.04;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenW * 0.15),
        child: AppBar(title: Text("Войти", style: TextStyle(fontSize: titleSize))),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _emailController,
                    style: TextStyle(fontSize: titleSize),
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(fontSize: titleSize * 0.75),
                    ),
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
                      child: Text("Войти", style: TextStyle(fontSize: titleSize * 0.75, color: const Color.fromARGB(255, 15, 11, 218))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}