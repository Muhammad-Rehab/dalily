
import 'package:dalily/core/error/failure.dart';
import 'package:dalily/features/notification/data/model/notification_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

abstract class NotificationRepository {
  Future<Either<Failure,void>> initLocalNotification(BuildContext context);
  Future<Either<Failure,String>> getAppToken();
  Future<Either<ServerFailure,void>> updateAppToken(String id);
  Future<Either<ServerFailure,void>> sendNotification(String ? appToken,NotificationModel notificationModel,bool isLocal);

}