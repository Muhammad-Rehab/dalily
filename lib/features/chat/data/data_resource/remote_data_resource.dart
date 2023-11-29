

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dalily/core/util/app_strings.dart';
import 'package:dalily/features/chat/data/model/message_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

abstract class MessageRemoteDataResource{

  Future<void> sendMessage(MessageModel messageModel);
  StreamController<MessageModel> getMessages(String serviceOwnerId , String tempUserId);

}

class MessageRemoteDataResourceImp extends MessageRemoteDataResource {
  FirebaseFirestore firebaseFirestore ;
  FirebaseStorage firebaseStorage ;
  
  MessageRemoteDataResourceImp({required this.firebaseStorage,required this.firebaseFirestore});
  
  @override
  StreamController<MessageModel> getMessages(String serviceOwnerId, String tempUserId) {
    StreamController<MessageModel> messages = StreamController<MessageModel>(); 
   Stream<QuerySnapshot<Map<String, dynamic>>> response =  firebaseFirestore.collection(AppStrings.chatsCollection)
       .doc(serviceOwnerId).collection(tempUserId).orderBy('time',descending: true).snapshots();

   response.forEach((element) {
     for (var element in element.docs) {
       messages.sink.add(MessageModel.fromJson(element.data()));
     }
   });
   return messages ;
  }

  @override
  Future<void> sendMessage(MessageModel messageModel) async{
    if(messageModel.isImage){
      String key = UniqueKey().toString();
      await firebaseStorage.ref(AppStrings.chatsStorageRef).child(key).putFile(File(messageModel.message));
      messageModel.message = await firebaseStorage.ref(AppStrings.chatsStorageRef).child(key).getDownloadURL();
    }
    firebaseFirestore.collection(AppStrings.chatsCollection).doc(messageModel.serviceOwnerId)
    .collection(messageModel.userId).doc(messageModel.messageId).set(messageModel.toJson());
    
  }
  
}