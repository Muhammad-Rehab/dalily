
import 'package:dalily/features/categories/data/model/category_model.dart';
import 'package:dalily/features/service_owners/prensentation/cubit/service_owner_state_states.dart';
import 'package:equatable/equatable.dart';

abstract class CategoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CategoryInitialState extends CategoryState {}

class CategoryErrorState extends CategoryState {
  String ? message;
  CategoryErrorState({this.message});

  @override
  List<Object?> get props => [message];
}

class CategoryIsLoading extends CategoryState {}
class CategoryIsAdding extends CategoryState {}
class CategoryIsUpdating extends CategoryState {}

class CategoryIsLoaded extends CategoryState {
  List<CategoryModel> categories ;

  CategoryIsLoaded({required this.categories});
}

class CategoryAddedState extends CategoryState {}

class CategoryIsUpdatedStated extends CategoryState {}

class GettingSingleLocalCatState extends CategoryState {}

class LoadedSingleLocalCatState extends CategoryState {
  final CategoryModel ? categoryModel ;
  LoadedSingleLocalCatState({required this.categoryModel});
}

class StoringCatImages extends CategoryState {}
class StoredCatImages extends CategoryState {}