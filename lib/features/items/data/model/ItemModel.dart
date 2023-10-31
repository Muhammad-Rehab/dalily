import 'dart:convert';

import 'package:dalily/features/authentication/data/model/service_owner_model.dart';
import 'package:dalily/features/items/domain/entity/item.dart';

class ItemModel extends Item {
  ItemModel({required super.catId,required super.catArabicName,required super.catImage, required super.catEnglishName,required super
      .itemServiceOwners});

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    List<ServiceOwnerModel> hold = [];
    for(var item in jsonDecode(json['item_service_owners'])){
     hold.add(ServiceOwnerModel.fromJson(item));
    }
    return ItemModel(
      catId: json['cat_id'],
      catArabicName: json['cat_arabic_name'],
      catEnglishName: json['cat_english_name'],
      itemServiceOwners:hold,
      catImage: json['cat_image'],
    );
  }

  Map<String,dynamic> toJson(){
    return {
      'cat_id': catId,
      'cat_arabic_name': catArabicName,
      'cat_english_name': catEnglishName,
      'item_service_owners': jsonEncode(itemServiceOwners),
      'cat_image': catImage
    };
  }

}
