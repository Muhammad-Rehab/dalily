
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dalily/core/util/app_strings.dart';
import 'package:dalily/features/authentication/data/model/service_owner_model.dart';
import 'package:dalily/features/temporary_user/data/model/temp_user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class TempUserRemoteResource {
  Future<TempUserModel> getCurrentTempUser(String id);
  Future<void> addTempUser(TempUserModel tempUserModel);
  Future<void> addToChatList(String id,ServiceOwnerModel serviceOwnerModel);

}

class TempUserRemoteResourceImp extends TempUserRemoteResource {
  FirebaseFirestore firebaseFirestore ;
  FirebaseStorage firebaseStorage ;
  TempUserRemoteResourceImp({required this.firebaseFirestore,required this.firebaseStorage});

  @override
  Future<void> addTempUser(TempUserModel tempUserModel) async {
    if(tempUserModel.image != null){
      await firebaseStorage.ref(AppStrings.tempUserStorageRef).child('/${tempUserModel.id}/0')
          .putFile(File(tempUserModel.image!));
      String imagePath = await firebaseStorage.ref(AppStrings.tempUserStorageRef).child('/${tempUserModel.id}/0')
          .getDownloadURL();
      tempUserModel.image = imagePath ;
    }
    await firebaseFirestore.collection(AppStrings.tempUserCollection).doc(tempUserModel.id)
        .set(tempUserModel.toJson());
  }

  @override
  Future<TempUserModel> getCurrentTempUser(String id) async {
    QuerySnapshot<Map<String, dynamic>> response = await firebaseFirestore.collection(AppStrings.tempUserCollection).limit(1)
        .where('id',isEqualTo: id).get();
      return TempUserModel.fromJson(response.docs.first.data());
    }

  @override
  Future<void> addToChatList(String id, ServiceOwnerModel serviceOwnerModel) async{
    await firebaseFirestore.collection(AppStrings.tempUserCollection).doc(id).update({
      'chat_list': FieldValue.arrayUnion([jsonEncode(serviceOwnerModel)])
    });
  }



}