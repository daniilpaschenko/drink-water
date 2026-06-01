import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../domain/repositories/i_user_repository.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/locale_provider.dart';
import '../../domain/usecases/sign_in_usecase.dart';

class RegisterForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController weightController;
  final TextEditingController emailController;

  const RegisterForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.weightController,
    required this.emailController,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool _linkSent = false;

  Future<void> _submit(BuildContext context) async {
  if (!widget.formKey.currentState!.validate()) return;

  final name = widget.nameController.text.trim();
  final weight = double.parse(
    widget.weightController.text.trim().replaceAll(',', '.'),
  );
  final email = widget.emailController.text.trim();
  final userRepo = context.read<IUserRepository>();
  final locale = context.read<LocaleProvider>().currentLocale;
  final signInUsecase = getIt<SignInUsecase>();

  await userRepo.savePendingRegistration(name, weight);

  final success = await signInUsecase(email, languageCode: locale.languageCode);
  if (!context.mounted) return;
  if (success) setState(() => _linkSent = true);
}

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final titleSize = screenW * 0.05;
    final loc = AppLocalizations.of(context)!;

    return Consumer<IUserRepository>(
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

        if (_linkSent) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.mark_email_read_outlined,
                  size: screenW * 0.2,
                  color: Colors.blue,
                ),
                SizedBox(height: screenW * 0.06),
                Text(
                  loc.linkSent,
                  style: TextStyle(
                    fontSize: titleSize * 1.1,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenW * 0.03),
                Text(
                  loc.checkEmailRegister(widget.emailController.text.trim()),
                  style: TextStyle(
                    fontSize: titleSize * 0.8,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenW * 0.1),
                TextButton(
                  onPressed: () => setState(() => _linkSent = false),
                  child: Text(
                    loc.sendAgain,
                    style: TextStyle(fontSize: titleSize * 0.8),
                  ),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: widget.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: widget.nameController,
                  style: TextStyle(fontSize: titleSize),
                  decoration: InputDecoration(
                    labelText: loc.name,
                    labelStyle: TextStyle(fontSize: titleSize * 0.8),
                  ),
                  inputFormatters: [LengthLimitingTextInputFormatter(16)],
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? loc.enterName : null,
                ),
                SizedBox(height: screenW * 0.06),
                TextFormField(
                  controller: widget.weightController,
                  style: TextStyle(fontSize: titleSize),
                  decoration: InputDecoration(
                    labelText: "${loc.weight} (${loc.kg})",
                    labelStyle: TextStyle(fontSize: titleSize * 0.8),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  validator: (v) {
                    final n = double.tryParse(v?.replaceAll(',', '.') ?? "");
                    if (n == null || n < 20 || n > 300) {
                      return loc.invalidWeight;
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenW * 0.06),
                TextFormField(
                  controller: widget.emailController,
                  style: TextStyle(fontSize: titleSize),
                  decoration: InputDecoration(
                    labelText: loc.email,
                    labelStyle: TextStyle(fontSize: titleSize * 0.8),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) =>
                      (v == null || !v.contains("@")) ? loc.invalidEmail : null,
                ),
                SizedBox(height: screenW * 0.1),
                SizedBox(
                  height: screenW * 0.08,
                  child: ElevatedButton(
                    onPressed: userRepo.isLoading
                        ? null
                        : () => _submit(context),
                    child: userRepo.isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : Text(
                            loc.register,
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