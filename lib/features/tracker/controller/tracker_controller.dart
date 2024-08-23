import 'package:get/get.dart';
import 'package:ship_tracker/features/auth/domain/usecases/login_use_case.dart';
import 'package:ship_tracker/features/auth/domain/usecases/register_use_case.dart';

class TrackerController extends GetxController {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;

  TrackerController({
    required this.loginUseCase,
    required this.registerUseCase,
  });

  Future<void> login(String email, String password) async {
    await loginUseCase(email, password);
  }

  Future<void> register(String email, String password) async {
    await registerUseCase(email, password);
  }
}
