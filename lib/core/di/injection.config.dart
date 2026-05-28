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

import '../../logic/card_repository.dart' as _i411;
import '../../logic/user_repository.dart' as _i369;
import '../../logic/water_repository.dart' as _i377;
import 'firebase_module.dart' as _i616;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  final firebaseModule = _$FirebaseModule();
  gh.lazySingleton<_i59.FirebaseAuth>(() => firebaseModule.firebaseAuth);
  gh.lazySingleton<_i974.FirebaseFirestore>(() => firebaseModule.firestore);
  gh.lazySingleton<_i377.IWaterRepository>(
    () => _i377.WaterRepository(
      gh<_i59.FirebaseAuth>(),
      gh<_i974.FirebaseFirestore>(),
    ),
  );
  gh.lazySingleton<_i411.ICardRepository>(
    () => _i411.CardRepository(
      gh<_i59.FirebaseAuth>(),
      gh<_i974.FirebaseFirestore>(),
    ),
  );
  gh.lazySingleton<_i369.IUserRepository>(
    () => _i369.UserRepository(
      gh<_i59.FirebaseAuth>(),
      gh<_i974.FirebaseFirestore>(),
      gh<_i377.IWaterRepository>(),
      gh<_i411.ICardRepository>(),
    ),
  );
  return getIt;
}

class _$FirebaseModule extends _i616.FirebaseModule {}
