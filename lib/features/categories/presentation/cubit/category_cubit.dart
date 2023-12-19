

import 'package:dalily/core/error/failure.dart';
import 'package:dalily/core/usecase/usecase.dart';
import 'package:dalily/features/categories/data/model/category_model.dart';
import 'package:dalily/features/categories/domain/use_cases/add_category.dart';
import 'package:dalily/features/categories/domain/use_cases/get_category.dart';
import 'package:dalily/features/categories/domain/use_cases/get_single_local_cat.dart';
import 'package:dalily/features/categories/domain/use_cases/storeCatImages.dart';
import 'package:dalily/features/categories/domain/use_cases/update_category.dart';
import 'package:dalily/features/categories/presentation/cubit/category_states.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryCubit extends Cubit<CategoryState>{
  
  GetCategoryUseCase getCategoryUseCase ;
  AddCategoryUseCase addCategoryUseCase ;
  UpdateCategoryUseCase updateCategoryUseCase;
  GetSingleLocalCategoryUseCase getSingleLocalCategoryUseCase;
  StoreCatImagesUseCase storeCatImagesUseCase ;

  List<CategoryModel> appCategories =[];
  Map<String,dynamic> catLocalImages = {};

  CategoryCubit({required this.getCategoryUseCase, required this.addCategoryUseCase,
    required this.getSingleLocalCategoryUseCase,
    required this.updateCategoryUseCase,
   required this.storeCatImagesUseCase,
  }):super(CategoryInitialState());
  
  Future<void> getCategories() async {
    emit(CategoryIsLoading());
    Either<Failure, List<dynamic>> response = await getCategoryUseCase.call(NoParam());
    emit(response.fold(
            (failure) => CategoryErrorState(message: failure.message) ,
            (categories) {
              appCategories = categories[0] ;
              catLocalImages = categories[1];
             return CategoryIsLoaded(categories: categories[0]);
            },
    ),
    );
  }

  Future<void> addCategory(CategoryModel categoryModel,List<CategoryModel> parents) async {
    emit(CategoryIsAdding());
    Either<ServerFailure, void> response = await addCategoryUseCase.call([categoryModel,parents]);
    emit(response.fold(
          (serverFailure) => CategoryErrorState(message: serverFailure.message),
            (r) => CategoryAddedState(),
    ),
    );
  }

  Future<void> update(CategoryModel categoryModel,bool updateImage,List<CategoryModel> parents) async {
    emit(CategoryIsUpdating());
    Either<ServerFailure, void> response = await updateCategoryUseCase.call([categoryModel,updateImage,parents]);
    emit(response.fold((serverFailure) => CategoryErrorState(), (r) => CategoryIsUpdatedStated()));
  }

  CategoryModel ? getSingleCategory({required String id }) {
    final Either<Failure, CategoryModel?> response =  getSingleLocalCategoryUseCase.call([id,appCategories]);
   return response.fold((l) => null, (categoryModel) => categoryModel);
  }

  Future<void> storeCatImages(List<CategoryModel> catList) async {
    emit(StoringCatImages());
    final Either<Failure, Map<String, dynamic>> response = await storeCatImagesUseCase.call(catList);
    emit(response.fold((l) => CategoryErrorState(), (r) {
      catLocalImages.addAll(r);
      return StoredCatImages();
    }));
  }


  
}