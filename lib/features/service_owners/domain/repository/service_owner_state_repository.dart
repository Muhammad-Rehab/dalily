
import 'package:dalily/core/error/failure.dart';
import 'package:dalily/features/authentication/data/model/service_owner_model.dart';
import 'package:dalily/features/service_owners/data/model/servic_woner_state_model.dart';
import 'package:dartz/dartz.dart';

abstract class ServiceOwnerStateRepository {
  Future<Either<ServerFailure,List<ServiceOwnerStateModel>>> getServersWaitingList ();
  Future<Either<ServerFailure,ServiceOwnerStateModel>> getSingleServiceOwner ({required String id});
  Future<Either<ServerFailure,ServiceOwnerModel>> getCurrentUserData ({required String id});
  Future<Either<ServerFailure,void>> updateServiceOwnerState ({required String id,required String states,String ? description});
  Future<Either<ServerFailure,void>> addServiceOwnerState ({required ServiceOwnerStateModel serviceOwnerStateModel});

}