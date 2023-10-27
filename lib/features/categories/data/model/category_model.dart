import 'dart:convert';

import 'package:dalily/features/categories/domain/entity/category.dart';

class CategoryModel extends Category {
  List<CategoryModel> subCategory ;

  CategoryModel({required super.id, required super.arabicName,required super.englishName, required super.image, required this.subCategory, super
      .parentId});

  factory CategoryModel.fromJson(Map<String, dynamic> jsonModel) {

    List<CategoryModel> hold =[] ;
    if((jsonModel['sub_category'] != null )){
      for(var item in jsonDecode(jsonModel['sub_category']) ){
      hold.add(CategoryModel.fromJson(item));
      }
    }
    return CategoryModel(
      id: jsonModel['id'],
      arabicName: jsonModel['arabic_name'],
      englishName: jsonModel['english_name'],
      image: jsonModel['image'],
      parentId: jsonModel['parent_id'],
      subCategory: hold,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'arabic_name': arabicName,
      'english_name':englishName,
      'image': image,
      'parent_id': parentId,
      'sub_category': jsonEncode(subCategory),
    };
  }
}
