import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dalily/core/util/app_strings.dart';
import 'package:dalily/features/authentication/data/model/service_owner_model.dart';
import 'package:dalily/features/service_owners/data/model/servic_woner_state_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class ServiceOwnerStateRemoteSource {
  Future<List<ServiceOwnerStateModel>> getServersWaitingList();

  Future<void> updateServiceOwnerState({required String id, required String state, String? description});

  Future<ServiceOwnerStateModel> getSingleServiceOwner({required String id});
  
  Future<ServiceOwnerModel> getCurrentUserData({required String id});

  Future<void> addServiceOwner({required ServiceOwnerStateModel serviceOwnerStateModel});
}

class ServiceOwnerStateRemoteSourceImp extends ServiceOwnerStateRemoteSource {
  FirebaseFirestore firebaseFirestore;
  FirebaseStorage storage ;

  ServiceOwnerStateRemoteSourceImp({required this.firebaseFirestore,required this.storage});

  @override
  Future<List<ServiceOwnerStateModel>> getServersWaitingList() async{
    final QuerySnapshot<Map<String, dynamic>> response = await firebaseFirestore.collection(AppStrings.serviceOwnersCollection)
        .where('state',isEqualTo: AppStrings.waitingState).get();
    List<ServiceOwnerStateModel> hold = [];
    response.docs.forEach((element) {
      hold.add(ServiceOwnerStateModel.fromJson(element.data()));
    });

    return hold;
  }

  @override
  Future<ServiceOwnerStateModel> getSingleServiceOwner({required String id}) async {
    final QuerySnapshot<Map<String, dynamic>> response =
        await firebaseFirestore.collection(AppStrings.serviceOwnersCollection).limit(1).where('id', isEqualTo: id).get();
    return ServiceOwnerStateModel.fromJson(response.docs.first.data());
  }

  @override
  Future<void> updateServiceOwnerState({required String id, required String state, String? description}) async {
    await firebaseFirestore.collection(AppStrings.serviceOwnersCollection).doc(id).update({
      'state': state,
      'description': description,
    });
  }

  @override
  Future<void> addServiceOwner({required ServiceOwnerStateModel serviceOwnerStateModel}) async {
    ServiceOwnerModel serviceOwnerModel = serviceOwnerStateModel.serviceOwnerModel ;
    if (serviceOwnerModel.personalImage != null) {
      await storage
          .ref(AppStrings.serviceOwnerStorageRef)
          .child('/${serviceOwnerModel.id}${AppStrings.personalImage}/0')
          .putFile(File(serviceOwnerModel.personalImage!));
      serviceOwnerModel.personalImage =
      await storage.ref(AppStrings.serviceOwnerStorageRef)
          .child('/${serviceOwnerModel.id}${AppStrings.personalImage}/0')
          .getDownloadURL();
    }
    if (serviceOwnerModel.workImages != null && serviceOwnerModel.workImages!.isNotEmpty) {
      for(int i= 0 ; i<serviceOwnerModel.workImages!.length ; i++){
        await storage
            .ref(AppStrings.serviceOwnerStorageRef)
            .child('/${serviceOwnerModel.id}${AppStrings.workImages}/$i')
            .putFile(File(serviceOwnerModel.workImages![i]));
        serviceOwnerModel.workImages![i] =
        await storage.ref(AppStrings.serviceOwnerStorageRef)
            .child('/${serviceOwnerModel.id}${AppStrings.workImages}/$i')
            .getDownloadURL();
      }
    }
    await firebaseFirestore.collection(AppStrings.serviceOwnersCollection)
        .doc(serviceOwnerStateModel.id).set(serviceOwnerStateModel.toJson());
  }

  @override
  Future<ServiceOwnerModel> getCurrentUserData({required String id}) async {
    final QuerySnapshot<Map<String, dynamic>> response = await firebaseFirestore.collection(AppStrings.serviceOwnersCollection).where('cat_id',isEqualTo: id)
        .limit(1).get();
    return ServiceOwnerModel.fromJson(response.docs.first.data()['service_owner_model']);
    
  }
}
