import '../repositories/i_user_repository.dart';

class SetCustomGoalUsecase {
  final IUserRepository repository;
  SetCustomGoalUsecase(this.repository);

  Future<void> call(double? goal) {
    if (goal != null && goal <= 0) throw Exception('Goal must be greater than zero');
    return repository.setCustomGoal(goal);
  }
}