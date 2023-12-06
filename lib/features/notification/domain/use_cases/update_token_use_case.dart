
import 'package:dalily/core/error/failure.dart';
import 'package:dalily/core/usecase/usecase.dart';
import 'package:dalily/features/notification/domain/repository/notification_repo.dart';
import 'package:dartz/dartz.dart';

class UpdateTokenUseCase extends UseCase<void,String>{
  NotificationRepository notificationRepository;
  UpdateTokenUseCase({required this.notificationRepository});

  @override
  Future<Either<Failure, void>> call(String param) => notificationRepository.updateAppToken(param);
}