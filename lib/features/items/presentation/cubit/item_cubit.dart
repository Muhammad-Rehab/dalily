import 'package:dalily/core/error/failure.dart';
import 'package:dalily/core/util/app_strings.dart';
import 'package:dalily/features/items/data/model/ItemModel.dart';
import 'package:dalily/features/items/domain/use_cases/add_item_use_case.dart';
import 'package:dalily/features/items/domain/use_cases/get_item_use_case.dart';
import 'package:dalily/features/items/presentation/cubit/item_states.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ItemCubit extends Cubit<ItemState> {
  GetItemUseCase getItemUseCase;

  AddItemUseCase addItemUseCase;

  ItemCubit({required this.addItemUseCase, required this.getItemUseCase}) : super(ItemInitialState());

  getItem(String categoryId, BuildContext context) async {
    emit(ItemIsLoadingState());
    final Either<Failure, ItemModel> response = await getItemUseCase.call(categoryId);
    emit(response.fold((failure) {
      if (failure.message == AppStrings.nullCashError) {
        return ItemErrorState(message: AppLocalizations.of(context)!.internet_connection_error);
      } else {
        return ItemErrorState(message: AppLocalizations.of(context)!.general_error);
      }
    }, (itemModel) => ItemLoadedState(itemModel: itemModel)));
  }

  addItem(ItemModel itemModel, BuildContext context) async {
    emit(ItemIsAddingState());
    final Either<Failure, void> response = await addItemUseCase.call(itemModel);
    emit(
      response.fold(
        (l) => ItemErrorState(message: AppLocalizations.of(context)!.general_error),
        (r) => ItemAddedState(),
      ),
    );
  }

}
