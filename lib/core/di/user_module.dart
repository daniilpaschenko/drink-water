import 'package:injectable/injectable.dart';
import '../../features/user/domain/repositories/i_user_repository.dart';
import '../../features/user/domain/usecases/sign_in_usecase.dart';
import '../../features/user/domain/usecases/sign_in_with_link_usecase.dart';
import '../../features/user/domain/usecases/sign_out_usecase.dart';
import '../../features/user/domain/usecases/register_usecase.dart';
import '../../features/user/domain/usecases/set_custom_goal_usecase.dart';
import '../../features/user/domain/usecases/complete_pending_registration_usecase.dart';

@module
abstract class UserModule {
  @lazySingleton
  SignInUsecase signInUsecase(IUserRepository repo) => SignInUsecase(repo);

  @lazySingleton
  SignInWithLinkUsecase signInWithLinkUsecase(IUserRepository repo) => SignInWithLinkUsecase(repo);

  @lazySingleton
  SignOutUsecase signOutUsecase(IUserRepository repo) => SignOutUsecase(repo);

  @lazySingleton
  RegisterUsecase registerUsecase(IUserRepository repo) => RegisterUsecase(repo);

  @lazySingleton
  SetCustomGoalUsecase setCustomGoalUsecase(IUserRepository repo) => SetCustomGoalUsecase(repo);

  @lazySingleton
  CompletePendingRegistrationUsecase completePendingRegistrationUsecase(IUserRepository repo) => CompletePendingRegistrationUsecase(repo);
}