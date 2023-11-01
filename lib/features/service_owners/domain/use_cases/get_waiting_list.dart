

import 'package:dalily/core/error/failure.dart';
import 'package:dalily/core/usecase/usecase.dart';
import 'package:dalily/features/service_owners/data/model/servic_woner_state_model.dart';
import 'package:dalily/features/service_owners/domain/repository/service_owner_state_repository.dart';
import 'package:dartz/dartz.dart';

class GetServersWaitingListUseCase extends UseCase<List<ServiceOwnerStateModel>,NoParam>{
  ServiceOwnerStateRepository serviceOwnerStateRepository ;
  GetServersWaitingListUseCase({required this.serviceOwnerStateRepository});

  @override
  Future<Either<ServerFailure,List<ServiceOwnerStateModel>>> call(NoParam param) =>
      serviceOwnerStateRepository.getServersWaitingList();

}