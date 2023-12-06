


import 'package:dalily/core/error/failure.dart';
import 'package:dalily/core/usecase/usecase.dart';
import 'package:dalily/features/notification/domain/repository/notification_repo.dart';
import 'package:dartz/dartz.dart';

class SendNotificationUseCase extends UseCase<void,List> {
  NotificationRepository notificationRepository ;
  SendNotificationUseCase({required this.notificationRepository});

  @override
  Future<Either<Failure, void>> call(List param) => notificationRepository.sendNotification(param[0], param[1],param[2]);

}