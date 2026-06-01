import '../../../../core/l10n/app_localizations.dart';
import '../repositories/i_card_repository.dart';

class AddDefaultCardsUsecase {
  final ICardRepository repository;
  AddDefaultCardsUsecase(this.repository);

  Future<bool> call(AppLocalizations loc) => repository.addDefaultCards(loc);
}