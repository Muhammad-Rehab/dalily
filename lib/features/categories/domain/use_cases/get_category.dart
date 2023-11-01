

import 'package:dalily/core/error/failure.dart';
import 'package:dalily/core/usecase/usecase.dart';
import 'package:dalily/features/categories/data/model/category_model.dart';
import 'package:dalily/features/categories/domain/repository/category_repo.dart';
import 'package:dartz/dartz.dart';

class GetCategoryUseCase extends UseCase<List<CategoryModel>,NoParam>{
  CategoryRepository categoryRepository;
  GetCategoryUseCase({required this.categoryRepository});

  @override
  Future<Either<Failure, List<CategoryModel>>> call(NoParam param) => categoryRepository.getData();

}