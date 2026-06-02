import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_links/app_links.dart';
import 'features/user/presentation/screens/auth_screen.dart';
import 'features/water/presentation/screens/home_screen.dart';
import 'core/di/injection.dart';
import 'features/user/domain/repositories/i_user_repository.dart';
import 'features/water/domain/repositories/i_water_repository.dart';
import 'features/card/domain/repositories/i_card_repository.dart';
import 'core/l10n/locale_provider.dart';
import 'core/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await configureDependencies();

  final userRepo = getIt<IUserRepository>();
  final waterRepo = getIt<IWaterRepository>();
  final cardRepo = getIt<ICardRepository>();

  await userRepo.load();
  await waterRepo.load();
  await cardRepo.load();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<IUserRepository>.value(value: userRepo),
        ChangeNotifierProvider<IWaterRepository>.value(value: waterRepo),
        ChangeNotifierProvider<ICardRepository>.value(value: cardRepo),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
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

  void _handleLink(String link) async {
    if (link.contains('finishSignIn')) {
      final userRepo = getIt<IUserRepository>();

      _navigatorKey.currentState?.push(
        PageRouteBuilder(
          opaque: false,
          barrierColor: Colors.white,
          pageBuilder: (_, _, _) => const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          ),
        ),
      );

      final isSuccess = await userRepo.signInWithLink(link);

      if (isSuccess) {
        _navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
      } else {
        _navigatorKey.currentState?.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return MaterialApp(
          navigatorKey: _navigatorKey,
          locale: localeProvider.currentLocale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          // debugShowCheckedModeBanner: false,
          title: 'Drink Water',
          theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
          home: getIt<IUserRepository>().isLoggedIn
              ? const HomeScreen()
              : const AuthScreen(),
        );
      },
    );
  }
}