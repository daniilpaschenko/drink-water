import '../repositories/i_user_repository.dart';

class SignInUsecase {
  final IUserRepository repository;
  SignInUsecase(this.repository);

  Future<bool> call(String email, {String languageCode = 'ru'}) {
    if (email.isEmpty) throw Exception('Email cannot be empty');
    return repository.sendSignInLink(email, languageCode: languageCode);
  }
}