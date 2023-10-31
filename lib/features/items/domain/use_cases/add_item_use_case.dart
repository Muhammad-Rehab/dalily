
import 'package:dalily/core/error/failure.dart';
import 'package:dalily/core/usecase/usecase.dart';
import 'package:dalily/features/items/data/model/ItemModel.dart';
import 'package:dalily/features/items/domain/repository/item_repository.dart';
import 'package:dartz/dartz.dart';

class AddItemUseCase extends UseCase<void,ItemModel>{
  ItemRepository itemRepository ;
  AddItemUseCase({required this.itemRepository});

  @override
  Future<Either<Failure, void>> call(ItemModel param) => itemRepository.addItem(param);

}