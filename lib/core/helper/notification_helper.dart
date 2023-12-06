import 'package:dalily/config/routes.dart';
import 'package:dalily/core/emum/notification_type.dart';
import 'package:dalily/features/notification/data/model/notification_model.dart';
import 'package:dalily/features/notification/presentation/cubit/notification_cubit.dart';
import 'package:dalily/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static requestNotificationPermissions() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  static onForegroundNotification(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      BlocProvider.of<NotificationCubit>(context).sendNotification(
        notificationModel: NotificationModel.fromJson(message.data),
        isLocal: true,
      );
    });
  }

  static handleIfNotificationAction() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen((message) async{
      // _handleMessage(message);
    });

  }

  static void _handleMessage(RemoteMessage message) {
    NotificationModel notificationModel = NotificationModel.fromJson(message.data);
    debugPrint("notification data : ${notificationModel.toJson()}");
    if (notificationModel.type == NotificationType.userDataResponse) {
      runApp( const MyApp(route: AppRoutes.mainAuthRoute,));

    }else if (notificationModel.type == NotificationType.chat){
      /// todo nav to chat screen
    }else {
      runApp( const MyApp(route: AppRoutes.categoryScreen,));

    }
  }
}
