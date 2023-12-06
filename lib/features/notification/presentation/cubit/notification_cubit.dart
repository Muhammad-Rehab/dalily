import 'package:dalily/core/usecase/usecase.dart';
import 'package:dalily/features/notification/data/model/notification_model.dart';
import 'package:dalily/features/notification/domain/use_cases/get_token_use_case.dart';
import 'package:dalily/features/notification/domain/use_cases/initialize_local_notification_use_case.dart';
import 'package:dalily/features/notification/domain/use_cases/send_notification_use_case.dart';
import 'package:dalily/features/notification/domain/use_cases/update_token_use_case.dart';
import 'package:dalily/features/notification/presentation/cubit/notification_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationCubit extends Cubit<NotificationState> {
  GetTokenUseCase getTokenUseCase;

  SendNotificationUseCase sendNotificationUseCase;
  InitializeLocalNotificationUseCase initializeLocalNotificationUseCase ;
  UpdateTokenUseCase updateTokenUseCase;

  String ? appToken ;

  NotificationCubit({
    required this.updateTokenUseCase,
    required this.sendNotificationUseCase,
    required this.getTokenUseCase,
    required this.initializeLocalNotificationUseCase,
  }) : super(InitialNotificationState());


  Future<void> initLocalNotification(BuildContext context) async {
    emit(InitialNotificationState());
    final response  = await initializeLocalNotificationUseCase.call(context);
    emit(response.fold((l) => NotificationErrorState(), (r) => InitializedLocalNotificationState()));
  }
  getAppToken() async {
    emit(LoadingTokenState());
    final response = await getTokenUseCase.call(NoParam());
    emit(
      response.fold(
        (failure) => NotificationErrorState(),
        (right) {
          appToken = right ;
          return LoadedTokenState(appToken: right);
        },
      ),
    );
  }

  updateAppToken({required String id}) async {
    emit(UpdatingTokenState());
    final response = await updateTokenUseCase.call(id);
    emit(
      response.fold(
        (l) => NotificationErrorState(),
        (r) => UpdatedTokenState(),
      ),
    );
  }

  sendNotification({String ? appToken, required NotificationModel notificationModel,bool isLocal = false}) async {
    emit(SendingNotificationState());
    final response = await sendNotificationUseCase.call([appToken, notificationModel,isLocal]);
    response.fold(
      (l) => NotificationErrorState(),
      (r) => SentNotificationState(),
    );
  }
}
