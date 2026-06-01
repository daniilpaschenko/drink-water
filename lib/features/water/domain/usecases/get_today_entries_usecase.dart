import '../entities/water_entry.dart';
import '../repositories/i_water_repository.dart';

class GetTodayEntriesUsecase {
  final IWaterRepository repository;
  GetTodayEntriesUsecase(this.repository);

  List<WaterEntry> call() => repository.todayEntries;
}