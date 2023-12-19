

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dalily/core/error/failure.dart';
import 'package:dalily/core/util/app_strings.dart';
import 'package:dalily/features/categories/data/data_resources/local_data_resource.dart';
import 'package:dalily/features/categories/data/data_resources/remote_data_resource.dart';
import 'package:dalily/features/categories/data/model/category_model.dart';
import 'package:dalily/features/categories/domain/repository/category_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

class CategoryRepositoryImp extends CategoryRepository{

  CategoryRemoteDataResource categoryRemoteDataResource ;
  CategoryLocalDataResource categoryLocalDataResource ;
  Connectivity connectivity ;
  CategoryRepositoryImp({required this.categoryRemoteDataResource,required this.categoryLocalDataResource, required this.connectivity});

  @override
  Future<Either<Failure, List<dynamic>>> getData() async{
    try{
      final ConnectivityResult connectivityResult = await connectivity.checkConnectivity();
      if(connectivityResult != ConnectivityResult.none){
        List<CategoryModel> response = await categoryRemoteDataResource.getCategory();
        Map<String,dynamic> catLocalImages = await categoryLocalDataResource.addCategoryList(response);
        return Right([response,catLocalImages]);
      }else{
        List<dynamic> response = categoryLocalDataResource.getCategory();
        return response.isNotEmpty ? Right(response): const Left(CashFailure(message: AppStrings.nullCashError));
      }

    }catch(e){
      debugPrint('category repo imp / getData() ');
      debugPrint(e.toString());
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<ServerFailure, void>> addCategory({required CategoryModel categoryModel,required List<CategoryModel> parents})async {
    try{
      return Right(await categoryRemoteDataResource.addCategory(categoryModel,parents));
    }catch (e){
      debugPrint('category repo imp / addCategory()');
      debugPrint(e.toString());
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<ServerFailure, void>> update(CategoryModel categoryModel,bool updateImage,List<CategoryModel> parents) async{
   try{
     return Right(await categoryRemoteDataResource.update(categoryModel,updateImage,parents));
   }catch (e){
     debugPrint('category rop iml / update()');
     debugPrint(e.toString());
     return const Left(ServerFailure());
   }

  }

  @override
  Either<CashFailure,CategoryModel?> getSingleLocalCategory({required String id,
    required List<CategoryModel> categories}) {
    try{
      return Right(categoryRemoteDataResource.getSingleLocalCategory(id: id, categories: categories));
    }catch(e){
      debugPrint('cat repo imp / getSingleLocalCategory()');
      debugPrint(e.toString());
      return const Left(CashFailure());
    }
  }

  @override
  Future<Either<CashFailure,Map<String,dynamic>>> storeCatImages(List<CategoryModel> catList) async {
    try{
      return Right(await categoryLocalDataResource.storeCatImages(catList));
    }catch(e){
      debugPrint('cat repo imp / storeCatImages()');
      debugPrint(e.toString());
      return const Left(CashFailure());
    }
  }

}