import 'package:get/get.dart';
import 'package:ship_tracker/features/auth/domain/usecases/login_use_case.dart';
import 'package:ship_tracker/features/auth/domain/usecases/logout_use_case.dart';
import 'package:ship_tracker/features/auth/domain/usecases/register_use_case.dart';

class TrackerController extends GetxController {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;

  TrackerController({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
  });

  Future<void> login(String email, String password) async =>
    await loginUseCase(email, password);
  

  Future<void> register(String email, String password) async =>
    await registerUseCase(email, password);
  

  Future<void> logout() async => logoutUseCase();

  
}
