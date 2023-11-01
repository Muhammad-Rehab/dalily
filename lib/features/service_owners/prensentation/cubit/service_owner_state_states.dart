import 'package:dalily/features/service_owners/data/model/servic_woner_state_model.dart';
import 'package:equatable/equatable.dart';

abstract class ServiceOwnerStateStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialServiceOwnerState extends ServiceOwnerStateStates {}

class GettingWaitingListState extends ServiceOwnerStateStates {}

class LoadedWaitingListState extends ServiceOwnerStateStates {
  final List<ServiceOwnerStateModel> serviceOwnersModel;

  LoadedWaitingListState({required this.serviceOwnersModel});
}

class UpdatingServiceState extends ServiceOwnerStateStates {}

class UpdatedServiceState extends ServiceOwnerStateStates {}

class GettingSingleOwnerState extends ServiceOwnerStateStates {}

class LoadedSingleOwnerState extends ServiceOwnerStateStates {
  final ServiceOwnerStateModel serviceOwnerStateModel;

  LoadedSingleOwnerState({required this.serviceOwnerStateModel});
}

class AddingOwnerState extends ServiceOwnerStateStates {}

class AddedOwnerState extends ServiceOwnerStateStates {}

class ServiceOwnerStateError extends ServiceOwnerStateStates {}


