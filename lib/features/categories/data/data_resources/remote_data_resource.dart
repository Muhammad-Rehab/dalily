

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dalily/core/util/app_strings.dart';
import 'package:dalily/features/categories/data/model/category_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class CategoryRemoteDataResource {
  Future<List<CategoryModel>> getCategory();
  Future<void> addCategory(CategoryModel categoryModel);
  Future<void> update(CategoryModel categoryModel,bool updateImage);
}

class CategoryRemoteDataResourceImp extends CategoryRemoteDataResource {

  FirebaseFirestore firebaseFirestore ;
  FirebaseStorage firebaseStorage ;
  CategoryRemoteDataResourceImp({required this.firebaseFirestore,required this.firebaseStorage});

  @override
  Future<List<CategoryModel>> getCategory() async{
    QuerySnapshot<Map<String, dynamic>> response = await firebaseFirestore
        .collection(AppStrings.categoriesCollection).get();
    Map<String,CategoryModel> categories = {};
    CategoryModel hold;
    response.docs.forEach((item) {
       hold = CategoryModel.fromJson(item.data());
      if(hold.parentId != null){
        categories[hold.parentId]!.subCategory.add(hold);
      }else{
        categories[hold.id] = hold;
      }
    });
    return categories.values.toList();
  }

  @override
  Future<void> addCategory(CategoryModel categoryModel) async {

      await firebaseStorage.ref(AppStrings.categoriesStorageRef)
          .child(categoryModel.id).putFile(File(categoryModel.image));
      categoryModel.image = await firebaseStorage.ref(AppStrings.categoriesStorageRef)
          .child(categoryModel.id).getDownloadURL();
      await firebaseFirestore.collection(AppStrings.categoriesCollection)
          .doc(categoryModel.id).set(categoryModel.toJson());

  }

  @override
  Future<void> update(CategoryModel categoryModel,bool updateImage) async {

    if(updateImage){
      await firebaseStorage.ref(AppStrings.categoriesStorageRef)
          .child(categoryModel.id).putFile(File(categoryModel.image));
      categoryModel.image = await firebaseStorage.ref(AppStrings.categoriesStorageRef)
          .child(categoryModel.id).getDownloadURL();
    }
    await firebaseFirestore.collection(AppStrings.categoriesCollection)
        .doc(categoryModel.id).update(categoryModel.toJson());

  }

}