

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dalily/core/util/app_strings.dart';
import 'package:dalily/features/categories/data/model/category_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class CategoryRemoteDataResource {
  Future<List<CategoryModel>> getCategory();
  CategoryModel ? getSingleLocalCategory({required String id, required List<CategoryModel> categories});
  Future<void> addCategory(CategoryModel categoryModel,List<CategoryModel> parents);
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
    List<CategoryModel> categories = [];
    response.docs.forEach((item) {
       categories.add(CategoryModel.fromJson(item.data()));
    });
    return categories;
  }

  @override
  Future<void> addCategory(CategoryModel categoryModel,List<CategoryModel> parents) async {

      await firebaseStorage.ref(AppStrings.categoriesStorageRef)
          .child(categoryModel.id).putFile(File(categoryModel.image));
      categoryModel.image = await firebaseStorage.ref(AppStrings.categoriesStorageRef)
          .child(categoryModel.id).getDownloadURL();

      if(parents.isNotEmpty){
        parents.last.subCategory.add(categoryModel);
        await firebaseFirestore.collection(AppStrings.categoriesCollection)
            .doc(parents.first.id).update(parents.first.toJson());
      }else{
        await firebaseFirestore.collection(AppStrings.categoriesCollection)
            .doc(categoryModel.id).set(categoryModel.toJson());
      }

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

  @override
  CategoryModel ? getSingleLocalCategory({required String id , required List<CategoryModel> categories}) {
    for(CategoryModel item in categories){
      if(item.id == id){
        return item ;
      }else if (item.subCategory.isNotEmpty){
        CategoryModel ? hold =  getSingleLocalCategory(id: id, categories: item.subCategory);
        if(hold != null){
          return hold ;
        }
      }
    }
    return null ;
  }

}