

import 'package:dalily/core/error/failure.dart';
import 'package:dalily/core/error/firebase_auth_exception.dart';
import 'package:dalily/core/usecase/usecase.dart';
import 'package:dalily/features/authentication/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';

class LoginUseCase extends UseCase<String,String>{
  AuthRepository authRepository ;
  LoginUseCase({required this.authRepository});

  @override
  Future<Either<AppFirebaseAuthException, String>> call(String param) => authRepository.logIn(param);

}