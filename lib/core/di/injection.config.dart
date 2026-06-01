// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/card/data/repositories/card_repository.dart' as _i150;
import '../../features/card/domain/repositories/i_card_repository.dart'
    as _i442;
import '../../features/card/domain/usecases/add_card_usecase.dart' as _i1013;
import '../../features/card/domain/usecases/add_default_cards_usecase.dart'
    as _i762;
import '../../features/card/domain/usecases/remove_card_usecase.dart' as _i972;
import '../../features/user/data/repositories/user_repository.dart' as _i398;
import '../../features/user/domain/repositories/i_user_repository.dart'
    as _i671;
import '../../features/user/domain/usecases/complete_pending_registration_usecase.dart'
    as _i823;
import '../../features/user/domain/usecases/register_usecase.dart' as _i159;
import '../../features/user/domain/usecases/set_custom_goal_usecase.dart'
    as _i263;
import '../../features/user/domain/usecases/sign_in_usecase.dart' as _i730;
import '../../features/user/domain/usecases/sign_in_with_link_usecase.dart'
    as _i782;
import '../../features/user/domain/usecases/sign_out_usecase.dart' as _i192;
import '../../features/water/data/repositories/water_repository.dart' as _i213;
import '../../features/water/domain/repositories/i_water_repository.dart'
    as _i740;
import '../../features/water/domain/usecases/add_water_usecase.dart' as _i648;
import '../../features/water/domain/usecases/get_drank_liters_usecase.dart'
    as _i798;
import '../../features/water/domain/usecases/get_today_entries_usecase.dart'
    as _i396;
import '../../features/water/domain/usecases/remove_water_entry_usecase.dart'
    as _i430;
import 'card_module.dart' as _i575;
import 'firebase_module.dart' as _i616;
import 'user_module.dart' as _i64;
import 'water_module.dart' as _i154;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  final firebaseModule = _$FirebaseModule();
  final cardModule = _$CardModule();
  final waterModule = _$WaterModule();
  final userModule = _$UserModule();
  gh.lazySingleton<_i59.FirebaseAuth>(() => firebaseModule.firebaseAuth);
  gh.lazySingleton<_i974.FirebaseFirestore>(() => firebaseModule.firestore);
  gh.lazySingleton<_i740.IWaterRepository>(
    () => _i213.WaterRepository(
      gh<_i59.FirebaseAuth>(),
      gh<_i974.FirebaseFirestore>(),
    ),
  );
  gh.lazySingleton<_i442.ICardRepository>(
    () => _i150.CardRepository(
      gh<_i59.FirebaseAuth>(),
      gh<_i974.FirebaseFirestore>(),
    ),
  );
  gh.lazySingleton<_i671.IUserRepository>(
    () => _i398.UserRepository(
      gh<_i59.FirebaseAuth>(),
      gh<_i974.FirebaseFirestore>(),
      gh<_i740.IWaterRepository>(),
      gh<_i442.ICardRepository>(),
    ),
  );
  gh.lazySingleton<_i1013.AddCardUsecase>(
    () => cardModule.addCardUsecase(gh<_i442.ICardRepository>()),
  );
  gh.lazySingleton<_i972.RemoveCardUsecase>(
    () => cardModule.removeCardUsecase(gh<_i442.ICardRepository>()),
  );
  gh.lazySingleton<_i762.AddDefaultCardsUsecase>(
    () => cardModule.addDefaultCardsUsecase(gh<_i442.ICardRepository>()),
  );
  gh.lazySingleton<_i648.AddWaterUsecase>(
    () => waterModule.addWaterUsecase(gh<_i740.IWaterRepository>()),
  );
  gh.lazySingleton<_i430.RemoveWaterEntryUsecase>(
    () => waterModule.removeWaterEntryUsecase(gh<_i740.IWaterRepository>()),
  );
  gh.lazySingleton<_i396.GetTodayEntriesUsecase>(
    () => waterModule.getTodayEntriesUsecase(gh<_i740.IWaterRepository>()),
  );
  gh.lazySingleton<_i798.GetDrankLitersUsecase>(
    () => waterModule.getDrankLitersUsecase(gh<_i740.IWaterRepository>()),
  );
  gh.lazySingleton<_i730.SignInUsecase>(
    () => userModule.signInUsecase(gh<_i671.IUserRepository>()),
  );
  gh.lazySingleton<_i782.SignInWithLinkUsecase>(
    () => userModule.signInWithLinkUsecase(gh<_i671.IUserRepository>()),
  );
  gh.lazySingleton<_i192.SignOutUsecase>(
    () => userModule.signOutUsecase(gh<_i671.IUserRepository>()),
  );
  gh.lazySingleton<_i159.RegisterUsecase>(
    () => userModule.registerUsecase(gh<_i671.IUserRepository>()),
  );
  gh.lazySingleton<_i263.SetCustomGoalUsecase>(
    () => userModule.setCustomGoalUsecase(gh<_i671.IUserRepository>()),
  );
  gh.lazySingleton<_i823.CompletePendingRegistrationUsecase>(
    () => userModule.completePendingRegistrationUsecase(
      gh<_i671.IUserRepository>(),
    ),
  );
  return getIt;
}

class _$FirebaseModule extends _i616.FirebaseModule {}

class _$CardModule extends _i575.CardModule {}

class _$WaterModule extends _i154.WaterModule {}

class _$UserModule extends _i64.UserModule {}
