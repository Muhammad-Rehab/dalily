import 'package:dalily/features/categories/domain/entity/category.dart';

class CategoryModel extends Category {
  List<CategoryModel> subCategory ;

  CategoryModel({required super.id, required super.arabicName,required super.englishName, required super.image, required this.subCategory, super
      .parentId});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      arabicName: json['arabic_name'],
      englishName: json['english_name'],
      image: json['image'],
      parentId: json['parent_id'],
      subCategory: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'arabic_name': arabicName,
      'english_name':englishName,
      'image': image,
      'parent_id': parentId,
      'sub_category': subCategory,
    };
  }
}
