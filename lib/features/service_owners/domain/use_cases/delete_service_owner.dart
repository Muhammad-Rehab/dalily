import 'package:dalily/core/error/failure.dart';
import 'package:dalily/core/usecase/usecase.dart';
import 'package:dalily/features/service_owners/domain/repository/service_owner_state_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteServiceOwnerUseCase extends UseCase<void, List> {
  ServiceOwnerStateRepository serviceOwnerStateRepository;

  DeleteServiceOwnerUseCase({required this.serviceOwnerStateRepository});

  @override
  Future<Either<Failure, void>> call(List param) => serviceOwnerStateRepository.deleteServiceOwner(
        serviceOwnerId: param[0],
        parentCatId: param[1],
      );
}
