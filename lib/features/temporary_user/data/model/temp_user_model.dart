import 'dart:convert';

import 'package:dalily/features/authentication/data/model/service_owner_model.dart';
import 'package:dalily/features/temporary_user/domain/entity/temp_user.dart';

class TempUserModel extends TempUser {
  TempUserModel({
    required super.id,
    required super.image,
    required super.name,
    required super.phoneNumber,
    required super.chatList,
  });

  factory TempUserModel.fromJson(Map<String, dynamic> json) {
    List<ServiceOwnerModel> hold = [];
    if (json['chat_list'] != null) {
      for (var item in jsonDecode(json['chat_list'])) {
        hold.add(ServiceOwnerModel.fromJson(item));
      }
    }
    return TempUserModel(
      id: json['id'],
      image: json['image'],
      name: json['name'],
      phoneNumber: json['phone_number'],
      chatList: hold ,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'name': name,
      'phone_number':phoneNumber,
      'chat_list': jsonEncode(chatList)
    };
  }
}
