import '../repositories/i_user_repository.dart';

class RegisterUsecase {
  final IUserRepository repository;
  RegisterUsecase(this.repository);

  Future<void> call(String name, double weight, {double? customGoal}) {
    if (name.isEmpty) throw Exception('Name cannot be empty');
    if (weight <= 0) throw Exception('Weight must be greater than zero');
    return repository.register(name, weight, customGoal: customGoal);
  }
}