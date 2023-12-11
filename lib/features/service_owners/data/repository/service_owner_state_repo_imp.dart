
import 'package:dalily/core/error/failure.dart';
import 'package:dalily/core/util/app_strings.dart';
import 'package:dalily/features/authentication/data/model/service_owner_model.dart';
import 'package:dalily/features/service_owners/data/data_resource/remote_data_source.dart';
import 'package:dalily/features/service_owners/data/model/servic_woner_state_model.dart';
import 'package:dalily/features/service_owners/domain/repository/service_owner_state_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

class ServiceOwnerStateRepoImp extends ServiceOwnerStateRepository {
  ServiceOwnerStateRemoteSource serviceOwnerStateRemoteSource ;
  ServiceOwnerStateRepoImp({required this.serviceOwnerStateRemoteSource});


  @override
  Future<Either<ServerFailure, ServiceOwnerModel>> addServiceOwnerState({required ServiceOwnerStateModel serviceOwnerStateModel}) async{
    try{
      return Right(await serviceOwnerStateRemoteSource.addServiceOwner(serviceOwnerStateModel: serviceOwnerStateModel));
    }catch(e){
      debugPrint('service owner state repo imp / addServiceOwnerState()');
      debugPrint(e.toString());
      return const Left(ServerFailure());

    }
  }

  @override
  Future<Either<ServerFailure, List<ServiceOwnerStateModel>>> getServersWaitingList() async{
    try{
      return Right(await serviceOwnerStateRemoteSource.getServersWaitingList());
    }catch(e){
      debugPrint('service owner state repo imp / getServersWaitingList()');
      debugPrint(e.toString());
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<ServerFailure, ServiceOwnerStateModel>> getSingleServiceOwner({required String id}) async{
    try{
      final ServiceOwnerStateModel? response = await serviceOwnerStateRemoteSource.getSingleServiceOwner(id: id);
      return response != null ? Right(response) : const Left(ServerFailure(message: AppStrings.nullCashError));
    }catch(e){
    debugPrint('service owner state repo imp / getSingleServiceOwner()');
    debugPrint(e.toString());
    return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<ServerFailure, void>> updateServiceOwnerState({required String id, required String states,
    String? description})async {
    try{
      return Right(await serviceOwnerStateRemoteSource.updateServiceOwnerState(id: id,state: states,description: description));
    }catch(e){
    debugPrint('service owner state repo imp / updateServiceOwnerState()');
    debugPrint(e.toString());
    return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<ServerFailure, ServiceOwnerModel>> getCurrentUserData({required String id}) async {
     try{
       final ServiceOwnerModel ?response = await serviceOwnerStateRemoteSource.getCurrentUserData(id: id);

       return response!= null ? Right(response): const Left(ServerFailure(message: AppStrings.nullCashError));
     }catch (e){
       debugPrint('service owner state repo imp / getCurrentUserData()');
       debugPrint(e.toString());
       return const Left(ServerFailure());
     }
  }

  @override
  Future<Either<ServerFailure, void>> deleteServiceOwner({required String serviceOwnerId,
    required String parentCatId})async {
    try{
      return Right(await serviceOwnerStateRemoteSource.deleteServiceOwnerData(serviceOwnerId,parentCatId));
    }catch(e){
    debugPrint('service owner state repo imp / deleteServiceOwner()');
    debugPrint(e.toString());
    return const Left(ServerFailure());
    }
  }

}