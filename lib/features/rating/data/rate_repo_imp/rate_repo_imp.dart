import 'package:dalily/core/error/failure.dart';
import 'package:dalily/features/items/data/model/ItemModel.dart';
import 'package:dalily/features/rating/data/data_resource/remote_data_resource.dart';
import 'package:dalily/features/rating/data/model/rate_model.dart';
import 'package:dalily/features/rating/domain/rate_repository/rate_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

class RateRepoImp extends RateRepository {
  RateRemoteDataResource rateRemoteDataResource;

  RateRepoImp({required this.rateRemoteDataResource});

  @override
  Either<ServerFailure, Future<void>> addRate({
    required RateModel rateModel,
    required ItemModel itemModel,
    required String serviceOwnerId,
  }) {
    try {
      return Right(rateRemoteDataResource.addRate(rateModel, itemModel, serviceOwnerId));
    } catch (e) {
      debugPrint(" rate repo imp / addRate()");
      debugPrint(e.toString());
      return const Left(ServerFailure());
    }
  }
}
