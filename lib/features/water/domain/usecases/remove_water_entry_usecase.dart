import '../repositories/i_water_repository.dart';

class RemoveWaterEntryUsecase {
  final IWaterRepository repository;
  RemoveWaterEntryUsecase(this.repository);

  Future<bool> call(int index) {
    if (index < 0) throw Exception('Invalid index');
    return repository.removeEntry(index);
  }
}