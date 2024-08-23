import 'package:get_it/get_it.dart';
import 'package:ship_tracker/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:ship_tracker/features/auth/data/repositories/auth_repositories_impl.dart';
import 'package:ship_tracker/features/auth/domain/repositories/auth_repositories.dart';
import 'package:ship_tracker/features/auth/domain/usecases/login_use_case.dart';
import 'package:ship_tracker/features/auth/domain/usecases/register_use_case.dart';
import 'package:ship_tracker/features/tracker/controller/tracker_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final getIt = GetIt.instance;

void setup(SupabaseClient supabase) {
  getIt.registerLazySingleton<AuthRemoteDatasource>(
      () => AuthRemoteDatasourceImpl(supabase: supabase));
  getIt.registerLazySingleton<AuthRepositories>(
      () => AuthRepositoriesImpl(authRemote: getIt.get()));
  getIt.registerLazySingleton(() => TrackerController(
        loginUseCase: LoginUseCase(authRepo: getIt.get()),
        registerUseCase: RegisterUseCase(authRepo: getIt.get()),
      ));
}
