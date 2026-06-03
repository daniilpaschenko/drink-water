import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'register_screen.dart';
import 'login_screen.dart';
import '../../../water/presentation/screens/home_screen.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../user/domain/repositories/i_user_repository.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final userRepo = context.watch<IUserRepository>();

    // пока идёт обработка deeplink — показывать загрузку
    if (userRepo.isProcessingLink) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
                  Text(loc.welcome, style: TextStyle(fontSize: titleSize * 1.25)),
                  SizedBox(height: screenW * 0.1),
                  SizedBox(
                    width: screenW * 0.8,
                    height: screenW * 0.08,
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                      child: Text(loc.register, style: TextStyle(fontSize: titleSize, color: const Color.fromARGB(255, 15, 11, 218))),
                    ),
                  ),
                  SizedBox(height: screenW * 0.03),
                  SizedBox(
                    width: screenW * 0.8,
                    height: screenW * 0.08,
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                      child: Text(loc.login, style: TextStyle(fontSize: titleSize, color: const Color.fromARGB(255, 15, 11, 218))),
                    ),
                  ),
                  SizedBox(height: screenW * 0.03),
                  SizedBox(
                    width: screenW * 0.8,
                    height: screenW * 0.08,
                    child: ElevatedButton(
                      onPressed: userRepo.isLoading
                          ? null
                          : () async {
                              final repo = context.read<IUserRepository>();
                              await repo.signInAnonymously(loc);
                              if (!context.mounted) return;
                              if (repo.isLoggedIn) {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                                  (route) => false,
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade100,
                      ),
                      child: userRepo.isLoading
                          ? SizedBox(
                              width: titleSize,
                              height: titleSize,
                              child: const CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              loc.anonymousLogin,
                              style: TextStyle(fontSize: titleSize, color: Colors.grey.shade700),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}