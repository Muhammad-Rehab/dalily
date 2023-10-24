

import 'package:dalily/core/error/firebase_auth_exception.dart';
import 'package:dalily/core/usecase/usecase.dart';
import 'package:dalily/features/authentication/data/model/service_owner_model.dart';
import 'package:dalily/features/authentication/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';

class RegisterUseCase extends UseCase<void,ServiceOwnerModel> {
  AuthRepository authRepository ;
  RegisterUseCase({required this.authRepository});

  @override
  Future<Either<AppFirebaseAuthException, void>> call(ServiceOwnerModel param) => authRepository.register(param);

}