

import 'package:dalily/core/error/failure.dart';
import 'package:dalily/core/usecase/usecase.dart';
import 'package:dalily/features/categories/data/model/category_model.dart';
import 'package:dalily/features/categories/domain/repository/category_repo.dart';
import 'package:dartz/dartz.dart';

class StoreCatImagesUseCase extends UseCase<Map<String,dynamic>,List<CategoryModel>>{
  CategoryRepository categoryRepository ;
  StoreCatImagesUseCase({required this.categoryRepository});


  @override
  Future<Either<Failure, Map<String,dynamic>>> call(List<CategoryModel> param)
  =>  categoryRepository.storeCatImages(param);

}