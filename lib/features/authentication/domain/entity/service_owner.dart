

import 'package:equatable/equatable.dart';

class ServiceOwner extends Equatable{
  String id ;
  String name ;
  String phoneNumber ;
  List<String> categoryIds ;
  String ? serviceName ;
  String ? serviceDescription;
  String ? address ;
  String ? personalImage ;
  List<String> ? workImages ;
  String ? secondPhoneNumber ;
  String ? thirdPhoneNumber ;
  String ? comment ;

  ServiceOwner({required this.id, required this.name,required this.phoneNumber,required this.categoryIds,
    this.address,this.personalImage,this.workImages,this.secondPhoneNumber,this.thirdPhoneNumber,
  this.serviceName,this.serviceDescription, this.comment});

  @override
  List<Object?> get props => [id];



}