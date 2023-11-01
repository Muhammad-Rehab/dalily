

import 'package:dalily/features/authentication/data/model/service_owner_model.dart';
import 'package:equatable/equatable.dart';

class ServiceOwnerState extends Equatable {
  String id ;
  String state ;
  String ?description ;
  ServiceOwnerModel serviceOwnerModel ;
  ServiceOwnerState({required this.id , required this.serviceOwnerModel,required this.state,this.description});

  @override
  List<Object?> get props => [id];

}