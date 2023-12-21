import 'package:dalily/core/error/failure.dart';
import 'package:dalily/features/items/data/model/ItemModel.dart';
import 'package:dalily/features/rating/data/model/rate_model.dart';
import 'package:dalily/features/rating/domain/use_cases/add_rate_use_case.dart';
import 'package:dalily/features/rating/presentation/cubit/rate_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RateCubit extends Cubit<RateState> {
  AddRateUseCase addRateUseCase;

  RateCubit({required this.addRateUseCase}) : super(RateInitialState());

  Future<void> addRate({
    required RateModel rateModel,
    required ItemModel itemModel,
    required String serviceOwnerId,
  }) async {
    emit(AddingRateState());
    final Either<Failure, void> response = await addRateUseCase.call([rateModel,itemModel,serviceOwnerId]);
    emit(response.fold((l) => ErrorRateState(), (r) => AddedRateState()));
  }
}
