

import 'package:equatable/equatable.dart';

class ServiceOwner extends Equatable{
  String id ;
  String name ;
  String phoneNumber ;
  String occupation ;
  String ? address ;
  String ? personalImage ;
  List<String> ? workImages ;
  String ? secondPhoneNumber ;
  String ? thirdPhoneNumber ;

  ServiceOwner({required this.id, required this.name,required this.phoneNumber,required this.occupation,
    this.address,this.personalImage,this.workImages,this.secondPhoneNumber,this.thirdPhoneNumber});

  @override
  List<Object?> get props => [id];



}