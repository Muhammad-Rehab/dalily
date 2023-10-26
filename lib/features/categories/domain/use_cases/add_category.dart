
import 'package:dalily/core/error/failure.dart';
import 'package:dalily/core/usecase/usecase.dart';
import 'package:dalily/features/categories/data/model/category_model.dart';
import 'package:dalily/features/categories/domain/repository/category_repo.dart';
import 'package:dartz/dartz.dart';

class AddCategoryUseCase extends UseCase<void,CategoryModel> {

  CategoryRepository categoryRepository ;
  AddCategoryUseCase({required this.categoryRepository});

  @override
  Future<Either<ServerFailure, void>> call(CategoryModel param) => categoryRepository.addCategory(param);


}