import 'package:dalily/core/error/failure.dart';
import 'package:dalily/core/usecase/usecase.dart';
import 'package:dalily/features/service_owners/data/model/servic_woner_state_model.dart';
import 'package:dalily/features/service_owners/domain/use_cases/add_service_owner_state.dart';
import 'package:dalily/features/service_owners/domain/use_cases/get_single_service_owner.dart';
import 'package:dalily/features/service_owners/domain/use_cases/get_waiting_list.dart';
import 'package:dalily/features/service_owners/domain/use_cases/update_server_state.dart';
import 'package:dalily/features/service_owners/prensentation/cubit/service_owner_state_states.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServiceOwnerStateCubit extends Cubit<ServiceOwnerStateStates> {
  GetServersWaitingListUseCase getServersWaitingListUseCase;

  UpdateServerStateListUseCase updateServerStateListUseCase;

  AddServiceOwnerStateUseCase addServiceOwnerStateUseCase;

  GetSingleServiceOwnerUseCase getSingleServiceOwnerUseCase;

  ServiceOwnerStateCubit({
    required this.getSingleServiceOwnerUseCase,
    required this.addServiceOwnerStateUseCase,
    required this.updateServerStateListUseCase,
    required this.getServersWaitingListUseCase,
  }) : super(InitialServiceOwnerState());

  getOwnersWaitingList() async {
    emit(GettingWaitingListState());
    final Either<ServerFailure, List<ServiceOwnerStateModel>> response = await getServersWaitingListUseCase.call(NoParam());
    emit(
      response.fold(
        (l) => ServiceOwnerStateError(),
        (r) => LoadedWaitingListState(serviceOwnersModel: r),
      ),
    );
  }

  getSingleOwner(String id) async {
    emit(GettingSingleOwnerState());
    final Either<ServerFailure, ServiceOwnerStateModel> response = await getSingleServiceOwnerUseCase.call(id);
    emit(
      response.fold(
        (l) => ServiceOwnerStateError(),
        (r) => LoadedSingleOwnerState(serviceOwnerStateModel: r),
      ),
    );
  }

  addServiceOwnerModel(ServiceOwnerStateModel serviceOwnerStateModel) async {
    emit(AddingOwnerState());
    final Either<ServerFailure, void> response = await addServiceOwnerStateUseCase.call(serviceOwnerStateModel);
    emit(
      response.fold(
        (l) => ServiceOwnerStateError(),
        (r) => AddedOwnerState(),
      ),
    );
  }

  Future updateServiceOwnerState({required String id,required String state, String? description}) async {
    emit(UpdatingServiceState());
    final Either<ServerFailure, void> response = await updateServerStateListUseCase.call([id, state, description]);
    emit(
      response.fold(
        (l) => ServiceOwnerStateError(),
        (r) => UpdatedServiceState(),
      ),
    );
  }
}
