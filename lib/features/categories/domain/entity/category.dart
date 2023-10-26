

import 'package:dalily/features/categories/data/model/category_model.dart';
import 'package:equatable/equatable.dart';

class Category extends Equatable {
  String id ;
  String arabicName ;
  String englishName;
  String image ;
  // List<Category> subCategory;
  String ? parentId ;

  Category({required this.id,required this.arabicName,required this.englishName,required this.image, this.parentId});

  @override
  List<Object?> get props => [id];
}