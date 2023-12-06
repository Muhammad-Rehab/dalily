

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dalily/core/util/app_strings.dart';
import 'package:flutter/material.dart';

class AdminController {
  static List<String> adminAccounts = [] ;
  static bool isAdmin = false ;

  static Future getAdminNumbers () async {
    final response = await FirebaseFirestore.instance.collection(AppStrings.adminCollection).get();
    for (var element in response.docs) {
      adminAccounts.add(element.data()['phone_number']);
    }
    debugPrint(" admins : $adminAccounts");
  }

  static bool isAdminAccount(String phoneNumber){
    isAdmin = adminAccounts.any((element) => element == phoneNumber);
    return isAdmin ;
  }
}