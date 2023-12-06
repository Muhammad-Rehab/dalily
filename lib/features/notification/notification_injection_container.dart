import 'package:dalily/config/super_injection_container.dart';
import 'package:dalily/features/notification/data/data_resource/local_data.dart';
import 'package:dalily/features/notification/data/data_resource/remote_data.dart';
import 'package:dalily/features/notification/data/repository_imp/notification_repo_imp.dart';
import 'package:dalily/features/notification/domain/repository/notification_repo.dart';
import 'package:dalily/features/notification/domain/use_cases/get_token_use_case.dart';
import 'package:dalily/features/notification/domain/use_cases/initialize_local_notification_use_case.dart';
import 'package:dalily/features/notification/domain/use_cases/send_notification_use_case.dart';
import 'package:dalily/features/notification/domain/use_cases/update_token_use_case.dart';
import 'package:dalily/features/notification/presentation/cubit/notification_cubit.dart';
import 'package:dalily/features/notification/presentation/cubit/notification_state.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

notificationInjectionContainer() {
  serverLocator.registerFactory(
    () => NotificationCubit(
        updateTokenUseCase: serverLocator(),
        sendNotificationUseCase: serverLocator(),
        getTokenUseCase: serverLocator(),
        initializeLocalNotificationUseCase: serverLocator()),
  );

  serverLocator.registerLazySingleton(() => UpdateTokenUseCase(notificationRepository: serverLocator()));
  serverLocator.registerLazySingleton(() => SendNotificationUseCase(notificationRepository: serverLocator()));
  serverLocator.registerLazySingleton(() => GetTokenUseCase(notificationRepository: serverLocator()));
  serverLocator.registerLazySingleton(() => InitializeLocalNotificationUseCase(notificationRepository: serverLocator()));

  serverLocator.registerLazySingleton<NotificationRepository>(
      () => NotificationRepoImp(notificationRemoteDataResource: serverLocator(), notificationLocalDataRes: serverLocator()));
  serverLocator.registerLazySingleton<NotificationRemoteDataResource>(
    () => NotificationRemoteDataResourceImpl(
      firebaseFirestore: serverLocator(),
      firebaseMessaging: serverLocator(),
    ),
  );

  serverLocator.registerLazySingleton<NotificationLocalDataRes>(
    () => NotificationLocalDataResImp(
      flutterLocalNotificationsPlugin: serverLocator(),
    ),
  );
  serverLocator.registerLazySingleton(() => FlutterLocalNotificationsPlugin());
  serverLocator.registerLazySingleton(() => FirebaseMessaging.instance);
}
