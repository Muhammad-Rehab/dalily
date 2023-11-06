
import 'package:dalily/core/error/failure.dart';
import 'package:dalily/core/usecase/usecase.dart';
import 'package:dalily/features/authentication/data/model/service_owner_model.dart';
import 'package:dalily/features/temporary_user/domain/repository/temp_user_repo.dart';
import 'package:dartz/dartz.dart';

class AddToChatListUseCase extends UseCase<void,ServiceOwnerModel>{
  TempUserRepository tempUserRepository ;
  AddToChatListUseCase({required this.tempUserRepository});

  @override
  Future<Either<Failure, void>> call(ServiceOwnerModel param)=> tempUserRepository.addToChatList(param);

}