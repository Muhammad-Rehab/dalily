
import 'package:dalily/core/error/failure.dart';
import 'package:dalily/core/usecase/usecase.dart';
import 'package:dalily/features/categories/data/model/category_model.dart';
import 'package:dalily/features/categories/domain/repository/category_repo.dart';
import 'package:dartz/dartz.dart';

class UpdateCategoryUseCase extends UseCase<void,List>{
  CategoryRepository categoryRepository ;
  UpdateCategoryUseCase({required this.categoryRepository});

  @override
  Future<Either<ServerFailure, void>> call(List param) => categoryRepository.update(param[0],param[1],param[2]);
}