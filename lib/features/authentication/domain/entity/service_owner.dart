

import 'package:equatable/equatable.dart';

class ServiceOwner extends Equatable{
  String id ;
  String name ;
  String phoneNumber ;
  String categoryId ;
  String ? serviceName ;
  String ? serviceDescription;
  String ? address ;
  String ? personalImage ;
  List<String> ? workImages ;
  String ? secondPhoneNumber ;
  String ? thirdPhoneNumber ;

  ServiceOwner({required this.id, required this.name,required this.phoneNumber,required this.categoryId,
    this.address,this.personalImage,this.workImages,this.secondPhoneNumber,this.thirdPhoneNumber,
  this.serviceName,this.serviceDescription});

  @override
  List<Object?> get props => [id];



}