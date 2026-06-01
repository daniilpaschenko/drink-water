import '../repositories/i_water_repository.dart';

class AddWaterUsecase {
  final IWaterRepository repository;
  AddWaterUsecase(this.repository);

  Future<bool> call(double liters, {String cardTitle = "", String iconName = "droplet"}) {
    if (liters <= 0) throw Exception('Volume must be greater than zero');
    return repository.addWater(liters, cardTitle: cardTitle, iconName: iconName);
  }
}