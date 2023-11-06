import 'package:dalily/core/error/failure.dart';
import 'package:dalily/core/usecase/usecase.dart';
import 'package:dalily/features/authentication/data/model/service_owner_model.dart';
import 'package:dalily/features/temporary_user/data/model/temp_user_model.dart';
import 'package:dalily/features/temporary_user/domain/usecase/add_temp_user_use_case.dart';
import 'package:dalily/features/temporary_user/domain/usecase/add_to_chat_use_case.dart';
import 'package:dalily/features/temporary_user/domain/usecase/get_temp_user_usecase.dart';
import 'package:dalily/features/temporary_user/presentation/cubit/temp_user_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TempUserCubit extends Cubit<TempUserState> {
  AddToChatListUseCase addToChatListUseCase;

  GetTempUserUseCase getTempUserUseCase;

  AddTempUserUseCase addTempUserUseCase;

  TempUserCubit({
    required this.addTempUserUseCase,
    required this.getTempUserUseCase,
    required this.addToChatListUseCase,
  }) : super(InitialTempUserState());

  Future<void> addTempUser(TempUserModel tempUserModel) async {
    emit(IsAddingTempUserState());
    final Either<Failure, void> response = await addTempUserUseCase.call(tempUserModel);
    emit(
      response.fold(
        (l) => ErrorTempUserState(),
        (r) => IsAddedTempUserState(),
      ),
    );
  }

  Future<void> getTempUser() async {
    emit(IsLoadingTempUserState());
    final Either<Failure, TempUserModel> response = await getTempUserUseCase.call(NoParam());
    emit(
      response.fold(
        (failure) {
          if (failure.message != null) {
            return ErrorTempUserState(message: failure.message);
          }
          return ErrorTempUserState();
        },
        (tempUserModel) => LoadedTempUserState(tempUserModel: tempUserModel),
      ),
    );
  }

  Future<void> addToChat(ServiceOwnerModel serviceOwnerModel) async {
    emit(IsAddingTempUserState());
    final Either<Failure, void> response = await addToChatListUseCase.call(serviceOwnerModel);
    emit(
      response.fold(
        (failure) {
          if (failure.message != null) {
            return ErrorTempUserState(message: failure.message);
          }
          return ErrorTempUserState();
        },
        (right) => IsAddedTempUserState(),
      ),
    );
  }
}
