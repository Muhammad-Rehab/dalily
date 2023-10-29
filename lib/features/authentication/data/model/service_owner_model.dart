import 'dart:convert';

import 'package:dalily/features/authentication/domain/entity/service_owner.dart';

class ServiceOwnerModel extends ServiceOwner {
  ServiceOwnerModel({required super.id, required super.name, required super.phoneNumber, required super.categoryIds,
  super.personalImage,super.workImages,super.address,super.secondPhoneNumber,super.thirdPhoneNumber,
  super.serviceDescription,super.serviceName,super.comment,
});

  factory ServiceOwnerModel.fromJson(Map<String, dynamic> json) {
    return ServiceOwnerModel(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phone_number'],
      categoryIds: json['category_ids'] ,
      serviceName: json['service_name'],
      serviceDescription: json['description'],
      address: json['address'],
      personalImage: json['personal_image'],
      workImages: json['work_images'],
      secondPhoneNumber: json['second_phone_number'],
      thirdPhoneNumber: json['third_phone_number'],
      comment: json['comment'],
    );
  }

  Map<String,dynamic> toJson(){
    return {
      'id': id,
      'name': name,
      'phone_number':phoneNumber,
      'category_ids': categoryIds,
      'service_name': serviceName,
      'description': serviceDescription,
      'address': address,
      'personal_image': personalImage,
      'work_images': workImages,
      'second_phone_number':secondPhoneNumber,
      'third_phone_number':thirdPhoneNumber,
      'comment':comment,
    };
  }
}
