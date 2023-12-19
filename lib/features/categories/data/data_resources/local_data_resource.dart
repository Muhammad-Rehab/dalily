
import 'dart:convert';

import 'package:dalily/core/util/app_strings.dart';
import 'package:dalily/features/categories/data/model/category_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CategoryLocalDataResource {
  List<CategoryModel> getCategory();
  Future addCategoryList(List<CategoryModel> catList);
}

class CategoryLocalDataResourceImp extends CategoryLocalDataResource {
  SharedPreferences sharedPreferences ;
  CategoryLocalDataResourceImp({required this.sharedPreferences});

  @override
  List<CategoryModel>  getCategory() {
    String ? response =  sharedPreferences.getString(AppStrings.categoryListSharedKey);
    List<CategoryModel>  categories = [];
    if(response != null){
      for (var item in jsonDecode(response)){
        categories.add(CategoryModel.fromJson(item));
      }
    }
    return categories ;
  }

  @override
  Future addCategoryList(List<CategoryModel> catList) async{
    String data = jsonEncode(catList);
    await sharedPreferences.setString(AppStrings.categoryListSharedKey, data);
  }

}