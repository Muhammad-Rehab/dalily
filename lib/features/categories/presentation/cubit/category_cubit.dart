

import 'package:dalily/core/error/failure.dart';
import 'package:dalily/core/usecase/usecase.dart';
import 'package:dalily/features/categories/data/model/category_model.dart';
import 'package:dalily/features/categories/domain/use_cases/add_category.dart';
import 'package:dalily/features/categories/domain/use_cases/get_category.dart';
import 'package:dalily/features/categories/domain/use_cases/update_category.dart';
import 'package:dalily/features/categories/presentation/cubit/category_states.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryCubit extends Cubit<CategoryState>{
  
  GetCategoryUseCase getCategoryUseCase ;
  AddCategoryUseCase addCategoryUseCase ;
  UpdateCategoryUseCase updateCategoryUseCase;
  List<CategoryModel> appCategories =[];

  CategoryCubit({required this.getCategoryUseCase, required this.addCategoryUseCase,required this.updateCategoryUseCase}):super(CategoryInitialState());
  
  Future<void> getCategories() async {
    emit(CategoryIsLoading());
    Either<ServerFailure, List<CategoryModel>> response = await getCategoryUseCase.call(NoParam());
    emit(response.fold(
            (serverFailure) => CategoryErrorState() ,
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

  update(CategoryModel categoryModel,bool updateImage) async {
    emit(CategoryIsUpdating());
    Either<ServerFailure, void> response = await updateCategoryUseCase.call([categoryModel,updateImage]);
    emit(response.fold((serverFailure) => CategoryErrorState(), (r) => CategoryIsUpdatedStated()));
  }
  
}