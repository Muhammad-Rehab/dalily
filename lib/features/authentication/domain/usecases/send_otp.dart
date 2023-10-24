

import 'package:dalily/core/error/firebase_auth_exception.dart';
import 'package:dalily/core/usecase/usecase.dart';
import 'package:dalily/features/authentication/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';

class SendOtpUseCase extends UseCase<Stream<String>,String> {

  AuthRepository authRepository ;
  SendOtpUseCase({required this.authRepository});

  @override
  Future<Either<AppFirebaseAuthException, Stream<String>>> call(String param) => authRepository.sendOtp(param);

}