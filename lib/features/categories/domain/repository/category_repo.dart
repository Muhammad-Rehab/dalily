

import 'package:dalily/core/error/failure.dart';
import 'package:dalily/features/categories/data/model/category_model.dart';
import 'package:dartz/dartz.dart';

abstract class CategoryRepository {
  Future<Either<Failure,List<CategoryModel>>> getData();
  Either<CashFailure,CategoryModel?> getSingleLocalCategory({required String id,required List<CategoryModel> categories});
  Future<Either<ServerFailure,void>> addCategory({required CategoryModel categoryModel,required List<CategoryModel> parents});
  Future<Either<ServerFailure,void>> update(CategoryModel categoryModel,bool updateImage);
}