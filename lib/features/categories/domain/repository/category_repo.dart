

import 'package:dalily/core/error/failure.dart';
import 'package:dalily/features/categories/data/model/category_model.dart';
import 'package:dartz/dartz.dart';

abstract class CategoryRepository {
  Future<Either<ServerFailure,List<CategoryModel>>> getData();
  Future<Either<ServerFailure,void>> addCategory(CategoryModel categoryModel);
  Future<Either<ServerFailure,void>> update(CategoryModel categoryModel,bool updateImage);
}