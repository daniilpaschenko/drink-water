import 'package:flutter/material.dart';
import 'register_screen.dart';
// import 'home_screen.dart'; // вернуть когда добавлю кнопку "войти"
// import '../logic/auth_logic.dart';
import 'login_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, screenConstraints) {
          double screenW = screenConstraints.maxWidth;
          double titleSize = screenW * 0.04;
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: screenConstraints.maxHeight, minWidth: double.infinity),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/images/drinkWaterLogo.png", width: screenW * 0.5, height: screenW * 0.5, fit: BoxFit.contain),
                  Text("Добро пожаловать!", style: TextStyle(fontSize: titleSize*1.25)),
                  SizedBox(height: screenW * 0.1),
                  SizedBox(
                    width: screenW * 0.8,
                    height: screenW * 0.08,
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                      child: Text("Зарегистрироваться", style:
                      TextStyle(
                        fontSize: titleSize,
                        color: const Color.fromARGB(255, 15, 11, 218)
                      )
                      ),
                    ),
                  ),
                  SizedBox(height: screenW * 0.03),
                  SizedBox(
                    width: screenW * 0.8,
                    height: screenW * 0.08,
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                      child: Text("Войти", style: TextStyle(fontSize: titleSize, color: const Color.fromARGB(255, 15, 11, 218))),
                    ),
                  ),
                ],
              ),
            )
          );
        }
      )
    );
  }
}