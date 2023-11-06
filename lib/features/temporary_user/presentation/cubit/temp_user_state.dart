import 'package:dalily/features/temporary_user/data/model/temp_user_model.dart';
import 'package:equatable/equatable.dart';

abstract class TempUserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialTempUserState extends TempUserState {}

class IsLoadingTempUserState extends TempUserState {}

class LoadedTempUserState extends TempUserState {
  final TempUserModel tempUserModel;

  LoadedTempUserState({required this.tempUserModel});
}

class IsAddingTempUserState extends TempUserState {}

class IsAddedTempUserState extends TempUserState {}

class IsUpdatingTempUserState extends TempUserState {}

class IsUpdatedTempUserState extends TempUserState {}

class ErrorTempUserState extends TempUserState {
  final String ? message;
  ErrorTempUserState({this.message});
}
