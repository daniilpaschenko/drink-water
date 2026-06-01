import '../repositories/i_water_repository.dart';

class GetDrankLitersUsecase {
  final IWaterRepository repository;
  GetDrankLitersUsecase(this.repository);

  double call() => repository.drankLiters;
}