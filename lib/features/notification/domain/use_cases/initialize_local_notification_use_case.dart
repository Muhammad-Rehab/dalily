
import 'package:dalily/core/error/failure.dart';
import 'package:dalily/core/usecase/usecase.dart';
import 'package:dalily/features/notification/domain/repository/notification_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

class InitializeLocalNotificationUseCase extends UseCase<void,BuildContext>{
  NotificationRepository notificationRepository ;
  InitializeLocalNotificationUseCase({required this.notificationRepository});

  @override
  Future<Either<Failure, void>> call(BuildContext param) => notificationRepository.initLocalNotification(param);

}