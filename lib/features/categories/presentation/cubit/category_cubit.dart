

import 'package:dalily/core/error/failure.dart';
import 'package:dalily/core/usecase/usecase.dart';
import 'package:dalily/features/categories/data/model/category_model.dart';
import 'package:dalily/features/categories/domain/use_cases/add_category.dart';
import 'package:dalily/features/categories/domain/use_cases/get_category.dart';
import 'package:dalily/features/categories/domain/use_cases/get_single_local_cat.dart';
import 'package:dalily/features/categories/domain/use_cases/update_category.dart';
import 'package:dalily/features/categories/presentation/cubit/category_states.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryCubit extends Cubit<CategoryState>{
  
  GetCategoryUseCase getCategoryUseCase ;
  AddCategoryUseCase addCategoryUseCase ;
  UpdateCategoryUseCase updateCategoryUseCase;
  GetSingleLocalCategoryUseCase getSingleLocalCategoryUseCase;
  List<CategoryModel> appCategories =[];

  CategoryCubit({required this.getCategoryUseCase, required this.addCategoryUseCase,
    required this.getSingleLocalCategoryUseCase,
    required this.updateCategoryUseCase}):super(CategoryInitialState());
  
  Future<void> getCategories() async {
    emit(CategoryIsLoading());
    Either<Failure, List<CategoryModel>> response = await getCategoryUseCase.call(NoParam());
    emit(response.fold(
            (failure) => CategoryErrorState(message: failure.message) ,
            (categories) {
              appCategories = categories ;
             return CategoryIsLoaded(categories: categories);
            },
    ),
    );
  }

  addCategory(CategoryModel categoryModel,List<CategoryModel> parents) async {
    emit(CategoryIsAdding());
    Either<ServerFailure, void> response = await addCategoryUseCase.call([categoryModel,parents]);
    emit(response.fold(
          (serverFailure) => CategoryErrorState(message: serverFailure.message),
            (r) => CategoryAddedState(),
    ),
    );
  }

  update(CategoryModel categoryModel,bool updateImage,List<CategoryModel> parents) async {
    emit(CategoryIsUpdating());
    Either<ServerFailure, void> response = await updateCategoryUseCase.call([categoryModel,updateImage,parents]);
    emit(response.fold((serverFailure) => CategoryErrorState(), (r) => CategoryIsUpdatedStated()));
  }

  CategoryModel ? getSingleCategory({required String id }) {
    final Either<Failure, CategoryModel?> response =  getSingleLocalCategoryUseCase.call([id,appCategories]);
   return response.fold((l) => null, (categoryModel) => categoryModel);
  }
  
}