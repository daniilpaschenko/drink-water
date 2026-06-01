import '../repositories/i_user_repository.dart';

class SignInWithLinkUsecase {
  final IUserRepository repository;
  SignInWithLinkUsecase(this.repository);

  Future<bool> call(String emailLink) {
    if (emailLink.isEmpty) throw Exception('Link cannot be empty');
    return repository.signInWithLink(emailLink);
  }
}