
import 'package:dalily/core/error/failure.dart';
import 'package:dalily/features/items/data/model/ItemModel.dart';
import 'package:dartz/dartz.dart';

abstract class ItemRepository {
  Future<Either<Failure,void>> addItem(ItemModel itemModel);
  Future<Either<Failure,ItemModel>> getItem(String categoryId);

}