import 'dart:convert';
import 'dart:io';

import 'package:dalily/core/util/app_strings.dart';
import 'package:dalily/features/categories/data/model/category_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CategoryLocalDataResource {
  List<dynamic> getCategory();

  Future<Map<String,dynamic>> addCategoryList(List<CategoryModel> catList);
  Future<Map<String, dynamic>> storeCatImages(List<CategoryModel> catList);
}

class CategoryLocalDataResourceImp extends CategoryLocalDataResource {
  SharedPreferences sharedPreferences;

  CategoryLocalDataResourceImp({required this.sharedPreferences});

  @override
  List<dynamic> getCategory() {
    String? response = sharedPreferences.getString(AppStrings.categoryListSharedKey);
    List<CategoryModel> categories = [];
    if (response != null) {
      for (var item in jsonDecode(response)) {
        categories.add(CategoryModel.fromJson(item));
      }
    }
    String ? data = sharedPreferences.getString(AppStrings.catLocalImagesSharedKey);
    Map<String,dynamic> catImagesData =  data == null ?{}:jsonDecode(data) ;
    return [categories,catImagesData];
  }

  @override
  Future<Map<String,dynamic>> addCategoryList(List<CategoryModel> catList) async {
    Map<String,dynamic> catLocalImages = await storeCatImages(catList);
    String data = jsonEncode(catList);
    await sharedPreferences.setString(AppStrings.categoryListSharedKey, data);
    return catLocalImages ;
  }

  @override
  Future<Map<String, dynamic>> storeCatImages(List<CategoryModel> catList) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    String ? data = sharedPreferences.getString(AppStrings.catLocalImagesSharedKey);
    Map<String,dynamic> catImagesData =  data == null ?{}:jsonDecode(data) ;
    Map<String,dynamic> catImages = {};
    for (var cat in catList) {
      // catImages.addAll(await downloadSubCatImages(cat, catImagesData,catImages, directory));
       try{
         if(!catImagesData.containsKey('${cat.id}img')){
           File file = File("${directory.path}/"
               "${cat.id}.png");
           await FirebaseStorage.instance.ref(AppStrings.categoriesStorageRef)
               .child(cat.id).writeToFile(file);
           catImages.addAll({'${cat.id}img':file.path});
         }
       }catch(e){
         debugPrint('firebase error : ');
         debugPrint(e.toString());
       }
    }
    catImages.addAll(catImagesData);
    await sharedPreferences.setString(AppStrings.catLocalImagesSharedKey, jsonEncode(catImages));
    return catImages;
  }

/*  Future<Map<String,dynamic>> downloadSubCatImages (CategoryModel categoryModel,
      Map<String,dynamic> catImagesData,Map<String,dynamic> catImagesHold,Directory directory ) async {
    if(categoryModel.subCategory.isNotEmpty){
      for(var cat in categoryModel.subCategory){
        catImagesHold.addAll( await downloadSubCatImages(cat, catImagesData,catImagesHold, directory));
      }
    }
    if(!catImagesData.containsKey('${categoryModel.id}img')){
      File file = File("${directory.path}/"
          "${categoryModel.id}.png");
      await FirebaseStorage.instance.ref(AppStrings.categoriesStorageRef)
          .child(categoryModel.id).writeToFile(file);
      catImagesHold.addAll({'${categoryModel.id}img':file.path});
    }
    return catImagesHold ;
  }*/
}
