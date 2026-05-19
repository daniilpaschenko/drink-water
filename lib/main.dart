import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_links/app_links.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'logic/user_repository.dart';
import 'logic/water_repository.dart';
import 'logic/card_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  late final AppLinks _appLinks;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    _initDeepLinks();
  }

  void _initDeepLinks() {
    _appLinks.getInitialLink().then((uri) {
      if (uri != null) _handleLink(uri.toString());
    });

    _appLinks.uriLinkStream.listen((uri) {
      _handleLink(uri.toString());
    });
  }

  Future<void> _handleLink(String link) async {
    if (!FirebaseAuth.instance.isSignInWithEmailLink(link)) return;

    final userRepo = context.read<UserRepository>();
    final cardRepo = context.read<CardRepository>();

    final success = await userRepo.signInWithLink(link);
    if (!mounted || !success) return;

    if (userRepo.isLoggedIn) {
      // Существующий пользователь — данные уже загружены в signInWithLink
      _navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } else {
      // Новый пользователь — Firebase залогинил, но данных в Firestore нет.
      // Проверяем есть ли сохранённые имя/вес от регистрации
      final registered = await userRepo.completePendingRegistration();
      if (!mounted) return;

      if (registered) {
        // Были сохранены имя/вес — регистрация завершена, на главную
        if (cardRepo.customCards.isEmpty) {
          await cardRepo.addDefaultCards();
        }
        if (!mounted) return;
        _navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
      } else {
        // Пришли через "Войти" но аккаунта нет — такого не должно быть,
        // но на всякий случай кидаем на AuthScreen
        _navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const AuthScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userRepo = context.watch<UserRepository>();

    return MaterialApp(
      navigatorKey: _navigatorKey,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Rubik',
      ),
      title: 'Drink Water',
      home: userRepo.isLoggedIn ? const HomeScreen() : const AuthScreen(),
    );
  }
}