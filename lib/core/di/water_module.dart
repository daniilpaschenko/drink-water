import 'package:injectable/injectable.dart';
import '../../features/water/domain/repositories/i_water_repository.dart';
import '../../features/water/domain/usecases/add_water_usecase.dart';
import '../../features/water/domain/usecases/remove_water_entry_usecase.dart';
import '../../features/water/domain/usecases/get_today_entries_usecase.dart';
import '../../features/water/domain/usecases/get_drank_liters_usecase.dart';

@module
abstract class WaterModule {
  @lazySingleton
  AddWaterUsecase addWaterUsecase(IWaterRepository repo) => AddWaterUsecase(repo);

  @lazySingleton
  RemoveWaterEntryUsecase removeWaterEntryUsecase(IWaterRepository repo) => RemoveWaterEntryUsecase(repo);

  @lazySingleton
  GetTodayEntriesUsecase getTodayEntriesUsecase(IWaterRepository repo) => GetTodayEntriesUsecase(repo);

  @lazySingleton
  GetDrankLitersUsecase getDrankLitersUsecase(IWaterRepository repo) => GetDrankLitersUsecase(repo);
}