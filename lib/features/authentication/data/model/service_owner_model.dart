import 'package:dalily/features/authentication/domain/entity/service_owner.dart';

class ServiceOwnerModel extends ServiceOwner {
  ServiceOwnerModel({required super.id, required super.name, required super.phoneNumber, required super.occupation,
  super.personalImage,super.workImages,super.address,super.secondPhoneNumber,super.thirdPhoneNumber
});

  factory ServiceOwnerModel.fromJson(Map<String, dynamic> json) {
    return ServiceOwnerModel(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phone_number'],
      occupation: json['occupation'],
      address: json['address'],
      personalImage: json['personal_image'],
      workImages: json['work_images'],
      secondPhoneNumber: json['second_phone_number'],
      thirdPhoneNumber: json['third_phone_number'],
    );
  }

  Map<String,dynamic> toJson(){
    return {
      'id': id,
      'name': name,
      'phone_number':phoneNumber,
      'occupation':occupation,
      'address': address,
      'personal_image': personalImage,
      'work_images': workImages,
      'second_phone_number':secondPhoneNumber,
      'third_phone_number':thirdPhoneNumber
    };
  }
}
