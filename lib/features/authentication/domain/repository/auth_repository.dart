
import 'package:dalily/core/error/firebase_auth_exception.dart';
import 'package:dalily/features/authentication/data/model/service_owner_model.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {

  Future<Either<AppFirebaseAuthException, Stream<String>>> sendOtp(String phoneNumber);
  Future<Either<AppFirebaseAuthException, String>> logIn(String otp);
  Future<Either<AppFirebaseAuthException, void>> register(ServiceOwnerModel serviceOwnerModel);
}