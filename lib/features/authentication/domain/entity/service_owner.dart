

import 'package:dalily/features/rating/data/model/rate_model.dart';
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
  RateModel rateModel ;

  ServiceOwner({required this.id, required this.name,required this.phoneNumber,required this.categoryIds,
    this.address,this.personalImage,this.workImages,this.secondPhoneNumber,this.thirdPhoneNumber,
  this.serviceName,this.serviceDescription, this.comment,required this.rateModel});

  @override
  List<Object?> get props => [id];



}