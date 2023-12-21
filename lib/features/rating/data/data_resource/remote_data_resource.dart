

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dalily/core/util/app_strings.dart';
import 'package:dalily/features/authentication/data/model/service_owner_model.dart';
import 'package:dalily/features/items/data/model/ItemModel.dart';
import 'package:dalily/features/rating/data/model/rate_model.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

abstract class RateRemoteDataResource {
  Future<void> addRate(RateModel rateModel,ItemModel itemModel,String serviceOwnerId);
}

class RateRemoteDataResourceImp extends RateRemoteDataResource {

  FirebaseFirestore firebaseFirestore ;
  RateRemoteDataResourceImp({required this.firebaseFirestore});

  @override
  Future<void> addRate(RateModel rateModel, ItemModel itemModel, String serviceOwnerId) async{
    for(ServiceOwnerModel item in itemModel.itemServiceOwners){
      if(item.id == serviceOwnerId){
        item.rateModel == rateModel ;
      }
    }
    await firebaseFirestore.collection(AppStrings.itemsCollection)
        .doc(itemModel.catId).update(itemModel.toJson());
  }
}
