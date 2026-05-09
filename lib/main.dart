import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'logic/auth_logic.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // инициализация firebase

  final userRepo = UserRepository();
  final waterRepo = WaterRepository();
  final cardRepo = CardRepository();

  await userRepo.load();
  await waterRepo.load();
  await cardRepo.load();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserRepository>.value(value: userRepo),
        ChangeNotifierProvider<WaterRepository>.value(value: waterRepo),
        ChangeNotifierProvider<CardRepository>.value(value: cardRepo),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final userRepo = context.watch<UserRepository>();
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Rubik',
      ),
      title: 'Drink Water',
      home: userRepo.isLoggedIn ? HomeScreen() : AuthScreen(),
    );
  }
}