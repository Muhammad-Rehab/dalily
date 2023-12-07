


import 'package:dalily/core/error/failure.dart';
import 'package:dalily/core/usecase/usecase.dart';
import 'package:dalily/features/authentication/data/model/service_owner_model.dart';
import 'package:dalily/features/service_owners/data/model/servic_woner_state_model.dart';
import 'package:dalily/features/service_owners/domain/repository/service_owner_state_repository.dart';
import 'package:dartz/dartz.dart';

class AddServiceOwnerStateUseCase extends UseCase<ServiceOwnerModel,ServiceOwnerStateModel>{
  ServiceOwnerStateRepository serviceOwnerStateRepository ;
  AddServiceOwnerStateUseCase({required this.serviceOwnerStateRepository});

  @override
  Future<Either<ServerFailure, ServiceOwnerModel>> call(ServiceOwnerStateModel param) =>
      serviceOwnerStateRepository.addServiceOwnerState(serviceOwnerStateModel: param);

}