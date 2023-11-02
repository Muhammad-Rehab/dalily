

import 'package:dalily/core/error/failure.dart';
import 'package:dalily/core/usecase/usecase.dart';
import 'package:dalily/features/authentication/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';

class LogOutUseCase extends UseCase<void,NoParam>{

  final AuthRepository authRepository ;
  LogOutUseCase({required this.authRepository});

  @override
  Future<Either<Failure, void>> call(NoParam param) => authRepository.logOut();


}