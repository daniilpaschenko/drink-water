import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/user_repository.dart';
// import '../logic/water_repository.dart';
import '../widgets/appbar.dart';
import '../widgets/home_body.dart';
import '../l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _showSuccess(double liters) {
    ScaffoldMessenger.of(context).clearSnackBars();
    final loc = AppLocalizations.of(context)!;
    final controller = ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(loc.success, textAlign: TextAlign.center),
        duration: const Duration(seconds: 3),

      ),
    );
    Future.delayed(const Duration(seconds: 3), () => controller.close());
  }

  @override
  Widget build(BuildContext context) {
    final userRepo = context.watch<UserRepository>();
    if (userRepo.currentUser == null) return const SizedBox();

    return Scaffold(
      appBar: buildMainAppBar(context: context),
      body: HomeBody(onSuccess: _showSuccess),
    );
  }
}