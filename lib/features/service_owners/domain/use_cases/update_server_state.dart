

import 'package:dalily/core/error/failure.dart';
import 'package:dalily/core/usecase/usecase.dart';
import 'package:dalily/features/service_owners/domain/repository/service_owner_state_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateServerStateListUseCase extends UseCase<void,List<String?>>{
  ServiceOwnerStateRepository serviceOwnerStateRepository ;
  UpdateServerStateListUseCase({required this.serviceOwnerStateRepository});

  @override
  Future<Either<ServerFailure, void>> call(List<String?> param) =>
      serviceOwnerStateRepository.updateServiceOwnerState(id: param[0]!, states: param[1]!,description: param[2]);

}