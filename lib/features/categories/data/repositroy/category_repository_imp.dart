

import 'package:dalily/core/error/failure.dart';
import 'package:dalily/features/categories/data/data_resources/remote_data_resource.dart';
import 'package:dalily/features/categories/data/model/category_model.dart';
import 'package:dalily/features/categories/domain/repository/category_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

class CategoryRepositoryImp extends CategoryRepository{

  CategoryRemoteDataResource categoryRemoteDataResource ;

  CategoryRepositoryImp({required this.categoryRemoteDataResource});

  @override
  Future<Either<ServerFailure, List<CategoryModel>>> getData() async{
    try{
      List<CategoryModel> response = await categoryRemoteDataResource.getCategory();
      return Right(response);
    }catch(e){
      debugPrint('category repo imp / getData() ');
      debugPrint(e.toString());
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<ServerFailure, void>> addCategory(CategoryModel categoryModel)async {
    try{
      return Right(await categoryRemoteDataResource.addCategory(categoryModel));
    }catch (e){
      debugPrint('category repo imp / addCategory()');
      debugPrint(e.toString());
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<ServerFailure, void>> update(CategoryModel categoryModel,bool updateImage) async{
   try{
     return Right(await categoryRemoteDataResource.update(categoryModel,updateImage));
   }catch (e){
     debugPrint('category rop iml / update()');
     debugPrint(e.toString());
     return Left(ServerFailure());
   }

  }

}