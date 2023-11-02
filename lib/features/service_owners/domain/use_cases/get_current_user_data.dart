

import 'package:dalily/core/error/failure.dart';
import 'package:dalily/core/usecase/usecase.dart';
import 'package:dalily/features/authentication/data/model/service_owner_model.dart';
import 'package:dalily/features/service_owners/domain/repository/service_owner_state_repository.dart';
import 'package:dartz/dartz.dart';

class GetCurrentUserDataUseCase extends UseCase<ServiceOwnerModel,String>{
  ServiceOwnerStateRepository serviceOwnerStateRepository ;
  GetCurrentUserDataUseCase({required this.serviceOwnerStateRepository});

  @override
  Future<Either<ServerFailure, ServiceOwnerModel>> call(String param) =>
      serviceOwnerStateRepository.getCurrentUserData(id: param);

}