

import 'package:dalily/core/error/failure.dart';
import 'package:dalily/core/usecase/usecase.dart';
import 'package:dalily/features/temporary_user/data/model/temp_user_model.dart';
import 'package:dalily/features/temporary_user/domain/repository/temp_user_repo.dart';
import 'package:dartz/dartz.dart';

class AddTempUserUseCase extends UseCase<void, TempUserModel>{

  TempUserRepository tempUserRepository ;
  AddTempUserUseCase({required this.tempUserRepository});

  @override
  Future<Either<Failure, void>> call(TempUserModel param) => tempUserRepository.addTempUser(param);
}
