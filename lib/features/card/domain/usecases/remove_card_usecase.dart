import '../repositories/i_card_repository.dart';

class RemoveCardUsecase {
  final ICardRepository repository;
  RemoveCardUsecase(this.repository);

  Future<bool> call(int index) {
    if (index < 0) throw Exception('Invalid index');
    return repository.removeCard(index);
  }
}