

import 'package:dalily/core/error/failure.dart';
import 'package:dalily/core/util/app_strings.dart';
import 'package:dalily/features/authentication/data/model/service_owner_model.dart';
import 'package:dalily/features/temporary_user/data/data_resource/local_data_resource.dart';
import 'package:dalily/features/temporary_user/data/data_resource/remote_data_resource.dart';
import 'package:dalily/features/temporary_user/data/model/temp_user_model.dart';
import 'package:dalily/features/temporary_user/domain/repository/temp_user_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

class TempUserRepoImp extends TempUserRepository {

  TempUserLocalResource tempUserLocalResource ;
  TempUserRemoteResource tempUserRemoteResource ;

  TempUserRepoImp({required this.tempUserRemoteResource,required this.tempUserLocalResource});


  @override
  Future<Either<Failure, void>> addTempUser(TempUserModel tempUserModel) async{
    try{
       await tempUserRemoteResource.addTempUser(tempUserModel);
      return Right(await tempUserLocalResource.addTempUserId(tempUserModel.id));
    }catch (e){
      debugPrint("temp user repo imp / addTempUser()");
      debugPrint(e.toString());
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, TempUserModel>> getTempUser() async {
    try{
      String ? hold = tempUserLocalResource.getTempUserId();
      if(hold == null){
        return const Left(CashFailure(message: AppStrings.nullCashError));
      }
      return Right(await tempUserRemoteResource.getCurrentTempUser(hold));
    }catch (e){
      debugPrint("temp user repo imp / getTempUser()");
      debugPrint(e.toString());
      return const Left(CashFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addToChatList(ServiceOwnerModel serviceOwnerModel) async{
   try{
     String ? hold = tempUserLocalResource.getTempUserId();
     if(hold == null){
       return const Left(CashFailure(message: AppStrings.nullCashError));
     }
     return Right(await tempUserRemoteResource.addToChatList(hold, serviceOwnerModel));
   }catch(e){
     debugPrint("temp user repo imp / addToChatList()");
     debugPrint(e.toString());
     return const Left(CashFailure());
   }
  }

}