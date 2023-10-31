
import 'dart:convert';

import 'package:dalily/features/items/data/model/ItemModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ItemLocalDataResource {
  Future<void> addItem(ItemModel itemModel);
  Future<ItemModel> ?getItem(String categoryId);
}

class ItemLocalDataResourceImp extends ItemLocalDataResource {

  SharedPreferences sharedPreferences ;
  ItemLocalDataResourceImp({required this.sharedPreferences});

  @override
  Future<void> addItem(ItemModel itemModel) async{
    String data = jsonEncode(itemModel);
    await sharedPreferences.setString(itemModel.catId, data);
  }

  @override
  Future<ItemModel> ? getItem(String categoryId) {
   String ? data =  sharedPreferences.getString(categoryId);
   if(data == null){
     return null ;
   }else{
     return jsonDecode(data);
   }
  }

}
