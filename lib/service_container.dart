import 'package:camera/camera.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repositories_impl.dart';
import 'features/auth/domain/repositories/auth_repositories.dart';
import 'features/auth/domain/usecases/login_use_case.dart';
import 'features/auth/domain/usecases/logout_use_case.dart';
import 'features/auth/domain/usecases/register_use_case.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/tracker/data/datasources/ship_local_data_source.dart';
import 'features/tracker/data/datasources/ship_remote_data_source.dart';
import 'features/tracker/data/repositories/ship_repositories_impl.dart';
import 'features/tracker/domain/repositories/ship_repositories.dart';
import 'features/tracker/domain/usecases/create_report_use_case.dart';
import 'features/tracker/domain/usecases/get_all_spreadsheet_files_use_case.dart';
import 'features/tracker/domain/usecases/get_ships_use_case.dart';
import 'features/tracker/domain/usecases/insert_ship_use_case.dart';
import 'features/tracker/presentation/cubit/ship_cubit.dart';

final getIt = GetIt.instance;

void setup({required CameraDescription camera}) {
  getIt.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  // Auth
  getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(supabase: getIt.get()));
  getIt.registerLazySingleton<AuthRepositories>(
      () => AuthRepositoriesImpl(authRemote: getIt.get()));
  getIt.registerLazySingleton(() => AuthCubit(
        loginUseCase: LoginUseCase(authRepo: getIt.get()),
        registerUseCase: RegisterUseCase(authRepo: getIt.get()),
        logoutUseCase: LogoutUseCase(authRepo: getIt.get()),
      ));

  // Ship
  getIt.registerLazySingleton<ShipRemoteDataSource>(
      () => ShipRemoteDataSourceImpl(supabase: getIt.get()));
  getIt.registerLazySingleton<ShipLocalDataSource>(
      () => ShipLocalDataSourceImpl());
  getIt.registerLazySingleton<ShipRepositories>(() => ShipRepositoriesImpl(
        shipRemote: getIt.get(),
        shipLocal: getIt.get(),
      ));
  getIt.registerLazySingleton(() => ShipCubit(
        getShipsUseCase: GetShipsUseCase(shipRepo: getIt.get()),
        insertShipUseCase: InsertShipUseCase(shipRepo: getIt.get()),
        createReportUseCase: CreateReportUseCase(shipRepo: getIt.get()),
        getAllSpreadsheetFilesUseCase:
            GetAllSpreadsheetFilesUseCase(shipRepo: getIt.get()),
        camera: camera,
      ));
}
