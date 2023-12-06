

import 'package:dalily/config/routes.dart';
import 'package:dalily/core/emum/notification_type.dart';
import 'package:dalily/features/notification/data/model/notification_model.dart';
import 'package:dalily/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

abstract class NotificationLocalDataRes {
  Future<void> sendLocalNotification(NotificationModel notificationModel);
  Future<void> initializeLocalNotification(BuildContext context);
}

class NotificationLocalDataResImp extends NotificationLocalDataRes {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin ;
  NotificationLocalDataResImp({required this.flutterLocalNotificationsPlugin});

  @override
  Future<void> sendLocalNotification(NotificationModel notificationModel) async{
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('local_notification', 'Local Notification',
        importance: Importance.max,
        priority: Priority.high,
        fullScreenIntent: true,
        ticker: 'ticker');
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        0, notificationModel.title , notificationModel.content , notificationDetails,
        payload: notificationModel.type.name,

    );
  }

  @override
  Future<void> initializeLocalNotification(BuildContext context) async {
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    await flutterLocalNotificationsPlugin.initialize( const InitializationSettings(
      android: AndroidInitializationSettings('ic_launcher'),
    ),
        onDidReceiveNotificationResponse: (NotificationResponse notificationResponse){
         debugPrint('I am local notification');
         debugPrint("payload : ${notificationResponse.payload}");
          if(notificationResponse.payload == NotificationType.userDataResponse.name){
            runApp(const MyApp(route: AppRoutes.mainAuthRoute,));
            // Navigator.pushAndRemoveUntil(context,
            //     MaterialPageRoute(builder: (_)=>const SplashScreen(route: AppRoutes.mainAuthRoute,)), (route) => false);
          }else if (notificationResponse.payload == NotificationType.chat.name){
            ///TODO navigate to chat screen
          }else {
            runApp(const MyApp(route: AppRoutes.categoryScreen,));
            // Navigator.pushAndRemoveUntil(context,
            //     MaterialPageRoute(builder: (_)=>const SplashScreen(route: AppRoutes.categoryScreen,)), (route) => false);
          }

        }
    );
  }

}