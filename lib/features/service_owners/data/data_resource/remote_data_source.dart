import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dalily/core/util/app_strings.dart';
import 'package:dalily/features/authentication/data/model/service_owner_model.dart';
import 'package:dalily/features/service_owners/data/model/servic_woner_state_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class ServiceOwnerStateRemoteSource {
  Future<List<ServiceOwnerStateModel>> getServersWaitingList();

  Future<void> updateServiceOwnerState({required String id, required String state, String? description});

  Future<ServiceOwnerStateModel?> getSingleServiceOwner({required String id});

  Future<ServiceOwnerModel?> getCurrentUserData({required String id});

  Future<ServiceOwnerModel> addServiceOwner({required ServiceOwnerStateModel serviceOwnerStateModel});

  Future<void> deleteServiceOwnerData(String serviceOwnerId, String parentCatId);
}

class ServiceOwnerStateRemoteSourceImp extends ServiceOwnerStateRemoteSource {
  FirebaseFirestore firebaseFirestore;
  FirebaseStorage storage;

  ServiceOwnerStateRemoteSourceImp({required this.firebaseFirestore, required this.storage});

  @override
  Future<List<ServiceOwnerStateModel>> getServersWaitingList() async {
    final QuerySnapshot<Map<String, dynamic>> response =
        await firebaseFirestore.collection(AppStrings.serviceOwnersCollection).where('state', isEqualTo: AppStrings.waitingState).get();
    List<ServiceOwnerStateModel> hold = [];
    response.docs.forEach((element) {
      hold.add(ServiceOwnerStateModel.fromJson(element.data()));
    });

    return hold;
  }

  @override
  Future<ServiceOwnerStateModel?> getSingleServiceOwner({required String id}) async {
    final QuerySnapshot<Map<String, dynamic>> response =
        await firebaseFirestore.collection(AppStrings.serviceOwnersCollection).limit(1).where('id', isEqualTo: id).get();
    return response.docs.isEmpty ? null : ServiceOwnerStateModel.fromJson(response.docs.first.data());
  }

  @override
  Future<void> updateServiceOwnerState({required String id, required String state, String? description}) async {
    await firebaseFirestore.collection(AppStrings.serviceOwnersCollection).doc(id).update({
      'state': state,
      'description': description,
    });
    if (state == AppStrings.rejectedState) {
      User? user = await FirebaseAuth.instance.userChanges().firstWhere((user) => user?.uid == id);
      if (user != null) {
        await user.delete();
      }
    }
  }

  @override
  Future<ServiceOwnerModel> addServiceOwner({required ServiceOwnerStateModel serviceOwnerStateModel}) async {
    ServiceOwnerModel serviceOwnerModel = serviceOwnerStateModel.serviceOwnerModel;
    if (serviceOwnerModel.personalImage != null) {
      await storage
          .ref(AppStrings.serviceOwnerStorageRef)
          .child('/${serviceOwnerModel.id}${AppStrings.personalImage}/0')
          .putFile(File(serviceOwnerModel.personalImage!));
      serviceOwnerModel.personalImage =
          await storage.ref(AppStrings.serviceOwnerStorageRef).child('/${serviceOwnerModel.id}${AppStrings.personalImage}/0').getDownloadURL();
    }
    if (serviceOwnerModel.workImages != null && serviceOwnerModel.workImages!.isNotEmpty) {
      for (int i = 0; i < serviceOwnerModel.workImages!.length; i++) {
        await storage
            .ref(AppStrings.serviceOwnerStorageRef)
            .child('/${serviceOwnerModel.id}${AppStrings.workImages}/$i')
            .putFile(File(serviceOwnerModel.workImages![i]));
        serviceOwnerModel.workImages![i] =
            await storage.ref(AppStrings.serviceOwnerStorageRef).child('/${serviceOwnerModel.id}${AppStrings.workImages}/$i').getDownloadURL();
      }
    }
    await firebaseFirestore.collection(AppStrings.serviceOwnersCollection).doc(serviceOwnerStateModel.id).set(serviceOwnerStateModel.toJson());
    return serviceOwnerModel;
  }

  @override
  Future<ServiceOwnerModel?> getCurrentUserData({required String id}) async {
    final QuerySnapshot<Map<String, dynamic>> response =
        await firebaseFirestore.collection(AppStrings.serviceOwnersCollection).where('cat_id', isEqualTo: id).limit(1).get();
    return response.docs.isEmpty ? null : ServiceOwnerModel.fromJson(response.docs.first.data()['service_owner_model']);
  }

  @override
  Future<void> deleteServiceOwnerData(String serviceOwnerId, String parentCatId) async {
    List<ServiceOwnerModel> itemServiceOwners = [];
    final response = await firebaseFirestore.collection(AppStrings.itemsCollection).limit(1).where('cat_id', isEqualTo: parentCatId).get();
    for (var item in jsonDecode(response.docs.first.data()['item_service_owners'])) {
      itemServiceOwners.add(ServiceOwnerModel.fromJson(item));
    }
    itemServiceOwners.removeWhere((element) => element.id == serviceOwnerId);
    await firebaseFirestore.collection(AppStrings.itemsCollection).doc(parentCatId).update({
      'item_service_owners': jsonEncode(itemServiceOwners),
    });
    await firebaseFirestore.collection(AppStrings.serviceOwnersCollection).doc(serviceOwnerId).delete();
    final personalImageRef = await storage.ref(AppStrings.serviceOwnerStorageRef).child("/$serviceOwnerId${AppStrings.personalImage}").listAll();
    await Future.forEach(personalImageRef.items, (element) => element.delete());
    final ListResult imagesRef = await storage.ref(AppStrings.serviceOwnerStorageRef).child("/$serviceOwnerId${AppStrings.workImages}/").listAll();
    await Future.forEach(imagesRef.items, (element) => element.delete());
  }
}
