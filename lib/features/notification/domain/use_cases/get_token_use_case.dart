
import 'package:dalily/core/error/failure.dart';
import 'package:dalily/core/usecase/usecase.dart';
import 'package:dalily/features/notification/domain/repository/notification_repo.dart';
import 'package:dartz/dartz.dart';

class GetTokenUseCase extends UseCase<String,NoParam>{
  NotificationRepository notificationRepository ;
  GetTokenUseCase({required this.notificationRepository});

  @override
  Future<Either<Failure, String>> call(NoParam param) => notificationRepository.getAppToken();


}