
import 'package:dalily/core/error/failure.dart';
import 'package:dalily/core/usecase/usecase.dart';
import 'package:dalily/features/items/data/model/ItemModel.dart';
import 'package:dalily/features/items/domain/repository/item_repository.dart';
import 'package:dartz/dartz.dart';

class GetItemUseCase extends UseCase<ItemModel,String>{
  ItemRepository itemRepository ;
  GetItemUseCase({required this.itemRepository});

  @override
  Future<Either<Failure, ItemModel>> call(String param) => itemRepository.getItem(param);

}