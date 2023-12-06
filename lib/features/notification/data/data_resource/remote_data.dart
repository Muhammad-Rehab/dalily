import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dalily/core/util/app_strings.dart';
import 'package:dalily/features/notification/data/model/notification_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

abstract class NotificationRemoteDataResource {

  Future<String> getAppToken();

  Future<void> updateAppToken(String id);

  Future<void> sendNotification({required String appToken, required NotificationModel notificationModel});

}

class NotificationRemoteDataResourceImpl extends NotificationRemoteDataResource {
  FirebaseMessaging firebaseMessaging;
  FirebaseFirestore firebaseFirestore;

  NotificationRemoteDataResourceImpl({required this.firebaseFirestore,required this.firebaseMessaging});

  @override
  Future<String> getAppToken() async {
    String? appToken = await firebaseMessaging.getToken();
    return appToken! ;
  }


  @override
  Future<void> sendNotification({required String appToken, required NotificationModel notificationModel}) async {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        "Content-Type": "application/json",
        "Authorization":
            "key=AAAAQw-KrS4:APA91bHwk0M8WifKBprJOnQg1pEnzgNhxfEB8NfxGJgwMKy2MAAGh5HxqfdxyWAnyQCIjpE1xu6uOjeqSpHF8IiSb5o1IAX4HBBZU7hZ9ZmDaJPCYCAb64baQd_RDPnv2rBVt0ejq231"
      },

      body: jsonEncode({
        "to": appToken,
        "notification": {
          "title": "يرجي الاهتمام",
          "body": notificationModel.content,
          "mutable_content": true,
          "sound": "Tri-tone"
        },
        'priority': 'high',
        "data": notificationModel.toJson(),
      }),
    );
  }

  @override
  Future<void> updateAppToken(String id) async {
    String appToken = await getAppToken();
    if(appToken != AppStrings.nullCashError){
      firebaseFirestore.collection(AppStrings.serviceOwnersCollection).doc(id).update({
        'app_token': appToken,
      });
    }
  }

}
