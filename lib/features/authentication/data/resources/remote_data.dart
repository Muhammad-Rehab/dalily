import 'dart:async';

import 'package:dalily/core/util/app_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class AuthRemoteData {
  Future<Stream<String>> sendOtp(String phoneNumber);

  Future<String> logIn(String otp);

  Future<void> logOut();

}

class AuthRemoteDataImpl extends AuthRemoteData {

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
    return response.user!.uid;
  }

  @override
  Future<void> logOut() async {
   await FirebaseAuth.instance.signOut();
  }
}
