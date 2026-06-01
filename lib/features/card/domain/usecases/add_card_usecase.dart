import '../repositories/i_card_repository.dart';

class AddCardUsecase {
  final ICardRepository repository;
  AddCardUsecase(this.repository);

  Future<bool> call(String title, double liters, String iconName) {
    if (title.isEmpty) throw Exception('Title cannot be empty');
    if (liters <= 0) throw Exception('Volume must be greater than zero');
    return repository.addCard(title, liters, iconName);
  }
}