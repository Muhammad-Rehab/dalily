import 'package:dalily/core/error/failure.dart';
import 'package:dalily/features/notification/data/data_resource/local_data.dart';
import 'package:dalily/features/notification/data/data_resource/remote_data.dart';
import 'package:dalily/features/notification/data/model/notification_model.dart';
import 'package:dalily/features/notification/domain/repository/notification_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

class NotificationRepoImp extends NotificationRepository {
  NotificationRemoteDataResource notificationRemoteDataResource;

  NotificationLocalDataRes notificationLocalDataRes;

  NotificationRepoImp({required this.notificationRemoteDataResource, required this.notificationLocalDataRes});

  @override
  Future<Either<Failure, String>> getAppToken() async {
    try {
      return Right(await notificationRemoteDataResource.getAppToken());
    } catch (e) {
      debugPrint('notification repo imp / getAppToken()');
      debugPrint(e.toString());
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<ServerFailure, void>> sendNotification(String ? appToken, NotificationModel notificationModel, bool isLocal) async {
    try {
      if (isLocal) {
        return Right(await notificationLocalDataRes.sendLocalNotification(notificationModel));
      } else {
        return Right(
          await notificationRemoteDataResource.sendNotification(
            appToken: appToken!,
            notificationModel: notificationModel,
          ),
        );
      }
    } catch (e) {
      debugPrint('notification repo imp / sendNotification()');
      debugPrint(e.toString());
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<ServerFailure, void>> updateAppToken(String id) async {
    try {
      return Right(await notificationRemoteDataResource.updateAppToken(id));
    } catch (e) {
      debugPrint('notification repo imp / updateAppToken()');
      debugPrint(e.toString());
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> initLocalNotification(BuildContext context) async{
    try{
      return Right(await notificationLocalDataRes.initializeLocalNotification(context));
    }catch(e){
      debugPrint('notification repo imp / initLocalNotification()');
      debugPrint(e.toString());
      return const Left(CashFailure());
    }
  }
}
