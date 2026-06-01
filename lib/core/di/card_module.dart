import 'package:injectable/injectable.dart';
import '../../features/card/domain/repositories/i_card_repository.dart';
import '../../features/card/domain/usecases/add_card_usecase.dart';
import '../../features/card/domain/usecases/remove_card_usecase.dart';
import '../../features/card/domain/usecases/add_default_cards_usecase.dart';

@module
abstract class CardModule {
  @lazySingleton
  AddCardUsecase addCardUsecase(ICardRepository repo) => AddCardUsecase(repo);

  @lazySingleton
  RemoveCardUsecase removeCardUsecase(ICardRepository repo) => RemoveCardUsecase(repo);

  @lazySingleton
  AddDefaultCardsUsecase addDefaultCardsUsecase(ICardRepository repo) => AddDefaultCardsUsecase(repo);
}