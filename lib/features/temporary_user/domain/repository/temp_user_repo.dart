

import 'package:dalily/core/error/failure.dart';
import 'package:dalily/features/authentication/data/model/service_owner_model.dart';
import 'package:dalily/features/temporary_user/data/model/temp_user_model.dart';
import 'package:dartz/dartz.dart';

abstract class TempUserRepository {

  Future<Either<Failure,void>> addTempUser(TempUserModel tempUserModel);
  Future<Either<Failure,void>> addToChatList(ServiceOwnerModel serviceOwnerModel);
  Future<Either<Failure,TempUserModel>> getTempUser();

}