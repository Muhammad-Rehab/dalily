
import 'package:dalily/core/error/firebase_auth_exception.dart';
import 'package:dalily/core/util/app_strings.dart';
import 'package:dalily/features/authentication/data/model/service_owner_model.dart';
import 'package:dalily/features/authentication/data/resources/remote_data.dart';
import 'package:dalily/features/authentication/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthRepoImpl extends AuthRepository {

  AuthRemoteData authRemoteData ;
  AuthRepoImpl({required this.authRemoteData});

  @override
  Future<Either<AppFirebaseAuthException, Stream<String>>> sendOtp(String phoneNumber) async {
   try {
     Stream<String> response = await authRemoteData.sendOtp(phoneNumber);
     return Right(response) ;
   }
 /*  on FirebaseAuthException catch (e){
     debugPrint('auth repo imp/send otp Exception :  ');
     debugPrint(e.toString());
     if(e.code == AppStrings.phoneAlreadyExistError){
       return Left(PhoneAlreadyExist());
     }else if (e.code == AppStrings.invalidPhoneNumberError){
       return Left(InvalidPhoneNumber());
     }else if ( e.code == AppStrings.tooManyRequestError){
       return Left(TooManyRequests());
     }else {
       return Left(OtherAuthException());
     }
   }*/
   catch (e){
     debugPrint('auth repo imp/send otp Exception :  ');
     debugPrint(e.toString());
     return Left(OtherAuthException());
   }
  }

  @override
  Future<Either<AppFirebaseAuthException, String>> logIn(String otp) async{
   try{
     String response = await authRemoteData.logIn(otp);
     return Right(response);
   }on FirebaseAuthException catch (e){
     debugPrint('auth repo imp/login Exception :  ');
     debugPrint(e.toString());
     if(e.code == AppStrings.phoneAlreadyExistError){
       return Left(PhoneAlreadyExist());
     }else if (e.code == AppStrings.invalidPhoneNumberError){
       return Left(InvalidPhoneNumber());
     }else if(e.code == AppStrings.invalidOtpCod){
       return Left(InvalidOtpCode());
     }else if ( e.code == AppStrings.tooManyRequestError){
       return Left(TooManyRequests());
     }else {
       return Left(OtherAuthException());
     }
   }catch (e){
     debugPrint('auth repo imp/login Exception :  ');
     debugPrint(e.toString());
     return Left(OtherAuthException());
   }
  }

  @override
  Future<Either<AppFirebaseAuthException, void>> register(ServiceOwnerModel serviceOwnerModel) async{
    try{
      void response = await authRemoteData.register(serviceOwnerModel);
      return Right(response);
    } catch (e){
      debugPrint('auth repo imp/register Exception :  ');
      debugPrint(e.toString());
      return Left(OtherAuthException());
    }

  }

}