import 'package:dartz/dartz.dart';

import '../../../../core/failure/failure.dart';
import '../repositories/auth_repositories.dart';

class LogoutUseCase {
  final AuthRepositories authRepo;

  LogoutUseCase({required this.authRepo});

  Future<Either<Failure, String>> call() async => await authRepo.logout();
}
