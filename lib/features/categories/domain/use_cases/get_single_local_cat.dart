

import 'package:dalily/core/error/failure.dart';
import 'package:dalily/core/usecase/usecase.dart';
import 'package:dalily/features/categories/data/model/category_model.dart';
import 'package:dalily/features/categories/domain/repository/category_repo.dart';
import 'package:dartz/dartz.dart';

class GetSingleLocalCategoryUseCase{
  CategoryRepository categoryRepository ;
  GetSingleLocalCategoryUseCase({required this.categoryRepository});


  Either<Failure, CategoryModel?> call(List param)  =>  categoryRepository
      .getSingleLocalCategory(id: param[0], categories: param[1]);

}