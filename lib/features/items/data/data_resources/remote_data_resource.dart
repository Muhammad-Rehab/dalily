

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dalily/core/util/app_strings.dart';
import 'package:dalily/features/authentication/data/model/service_owner_model.dart';
import 'package:dalily/features/items/data/model/ItemModel.dart';

abstract class ItemRemoteDataResource {

  Future<ItemModel> addItemModel(ItemModel itemModel);
  Future<ItemModel> getItemModel(String categoryId);
}

class ItemRemoteDataResourceImp extends ItemRemoteDataResource{

  FirebaseFirestore firebaseFirestore ;

  ItemRemoteDataResourceImp({required this.firebaseFirestore});

  @override
  Future<ItemModel> addItemModel(ItemModel itemModel) async {
   var ref = firebaseFirestore.collection(AppStrings.itemsCollection) ;
    QuerySnapshot<Map<String, dynamic>> response = await ref.limit(1)
        .where('cat_id',isEqualTo: itemModel.catId,).get();
    if(response.docs.isNotEmpty ){
      List<ServiceOwnerModel> hold = [];
      for(var item in jsonDecode(response.docs.first.data()['item_service_owners'])){
        hold.add(ServiceOwnerModel.fromJson(item));
      }
      itemModel.itemServiceOwners.addAll(hold);
      ref.doc(itemModel.catId).update({
        'item_service_owners': jsonEncode(itemModel.itemServiceOwners),
      });
    }else {
      await ref.doc(itemModel.catId).set(itemModel.toJson());
    }
    return itemModel ;
  }

  @override
  Future<ItemModel> getItemModel(String categoryId) async{
    final response = await firebaseFirestore
        .collection(AppStrings.itemsCollection).limit(1).where('cat_id',isEqualTo: categoryId).get();
    return ItemModel.fromJson(response.docs.first.data());
  }



}