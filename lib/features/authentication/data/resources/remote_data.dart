import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dalily/core/util/app_strings.dart';
import 'package:dalily/features/authentication/data/model/service_owner_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

abstract class AuthRemoteData {
  Future<Stream<String>> sendOtp(String phoneNumber);

  Future<String> logIn(String otp);

  Future<void> register(ServiceOwnerModel serviceOwnerModel);
}

class AuthRemoteDataImpl extends AuthRemoteData {
  // FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  // FirebaseFirestore firebaseFirestore= FirebaseFirestore.instance;
  String? verificationId;

  @override
  Future<Stream<String>> sendOtp(String phoneNumber) async {
    StreamController<String> controller = StreamController<String>();

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        debugPrint("Verification completed");
      },
      verificationFailed: (FirebaseAuthException e) {
        debugPrint('Verification failed');
        debugPrint(e.code);
        controller.sink.add(e.code);
        controller.close();
      },
      codeSent: (String verificationID, int? resendToken) {
        verificationId = verificationID;
        debugPrint('Code is sent');
        debugPrint('VerificationId : $verificationId');
        controller.sink.add(AppStrings.trueString);
        controller.close();
      },
      codeAutoRetrievalTimeout: (String verificationID) {
        debugPrint('Time out');
        debugPrint('VerificationId : $verificationID');
      },
      timeout: const Duration(minutes: 1),
    );
    return controller.stream;
  }

  @override
  Future<String> logIn(String otp) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId ?? "",
      smsCode: otp,
    );
    UserCredential response = await FirebaseAuth.instance.signInWithCredential(credential);

    debugPrint("Provided id :  ${response.credential?.providerId}");
    debugPrint("Token :  ${response.credential?.token}");
    debugPrint("Access token :  ${response.credential?.accessToken}");
    debugPrint("${await response.user?.getIdToken()}");
    debugPrint("${response.user?.refreshToken}");
    return response.user!.uid;
  }

  @override
  Future<void> register(ServiceOwnerModel serviceOwnerModel) async {
    FirebaseStorage storage = FirebaseStorage.instance;
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
    await FirebaseFirestore.instance.collection(AppStrings.serviceOwnerCollection).doc(serviceOwnerModel.id).set(serviceOwnerModel.toJson());
  }
}
