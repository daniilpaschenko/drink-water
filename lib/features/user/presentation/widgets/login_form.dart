import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/repositories/i_user_repository.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/locale_provider.dart';
import '../../domain/usecases/sign_in_usecase.dart';

class LoginForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _linkSent = false;
  bool _isProcessing = false;

  Future<void> _submit() async {
    if (!mounted) return;
    if (!widget.formKey.currentState!.validate()) return;
    setState(() => _isProcessing = true);
    final email = widget.emailController.text.trim();
    final locale = context.read<LocaleProvider>().currentLocale;
    final signInUsecase = getIt<SignInUsecase>();
    final success = await signInUsecase(
      email,
      languageCode: locale.languageCode,
    );
    if (!mounted) return;
    setState(() => _isProcessing = false);
    if (success) {
      setState(() => _linkSent = true);
    }
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
                  loc.checkEmail(widget.emailController.text.trim()),
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
                SizedBox(height: screenW * 0.1),
                Text(
                  loc.enterEmailHint,
                  style: TextStyle(
                    fontSize: titleSize * 0.8,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenW * 0.1),
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
                SizedBox(height: screenW * 0.12),
                SizedBox(
                  height: screenW * 0.08,
                  child: ElevatedButton(
                    onPressed: _isProcessing ? null : () => _submit(),
                    child: _isProcessing
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : Text(
                            loc.sendLink,
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
