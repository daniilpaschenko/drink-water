import '../repositories/i_user_repository.dart';

class SignOutUsecase {
  final IUserRepository repository;
  SignOutUsecase(this.repository);

  Future<void> call() => repository.signOut();
}