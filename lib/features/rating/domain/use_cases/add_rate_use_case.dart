

import 'package:dalily/core/error/failure.dart';
import 'package:dalily/core/usecase/usecase.dart';
import 'package:dalily/features/rating/domain/rate_repository/rate_repository.dart';
import 'package:dartz/dartz.dart';

class AddRateUseCase extends UseCase<void,List<dynamic>>{
  RateRepository rateRepository ;
  AddRateUseCase({required this.rateRepository});

  @override
  Future<Either<Failure, void>> call(List param) async{
    return rateRepository.addRate(rateModel: param[0], itemModel: param[1], serviceOwnerId: param[2]);
  }

}
