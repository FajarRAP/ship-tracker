import 'package:get/get.dart';
import 'package:ship_tracker/features/auth/domain/usecases/login_use_case.dart';

class TrackerController extends GetxController{
  final LoginUseCase loginUseCase;

  TrackerController({required this.loginUseCase});

  void login(String email, String password) async {
    loginUseCase(email, password);
  }
}