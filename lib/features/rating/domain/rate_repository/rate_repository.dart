import 'package:dalily/core/error/failure.dart';
import 'package:dalily/features/items/data/model/ItemModel.dart';
import 'package:dalily/features/rating/data/model/rate_model.dart';
import 'package:dartz/dartz.dart';

abstract class RateRepository {
  Either<ServerFailure, Future<void>> addRate({
    required RateModel rateModel,
    required ItemModel itemModel,
    required String serviceOwnerId,
  });
}
