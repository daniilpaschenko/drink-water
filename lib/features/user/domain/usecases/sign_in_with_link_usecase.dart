import '../repositories/i_user_repository.dart';
import '../../../../core/l10n/app_localizations.dart';

class SignInWithLinkUsecase {
  final IUserRepository repository;
  SignInWithLinkUsecase(this.repository);

  Future<bool> call(String emailLink, AppLocalizations loc) {
    if (emailLink.isEmpty) throw Exception('Link cannot be empty');
    return repository.signInWithLink(emailLink, loc);
  }
}