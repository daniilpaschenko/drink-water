import '../repositories/i_user_repository.dart';

class CompletePendingRegistrationUsecase {
  final IUserRepository repository;
  CompletePendingRegistrationUsecase(this.repository);

  Future<bool> call() => repository.completePendingRegistration();
}