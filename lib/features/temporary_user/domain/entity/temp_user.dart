

import 'package:dalily/features/authentication/data/model/service_owner_model.dart';
import 'package:equatable/equatable.dart';

class TempUser extends Equatable {
  final String id ;
  final String name ;
  String ? image ;
  final String phoneNumber ;
  List<ServiceOwnerModel> chatList ;

  TempUser({required this.id,this.image,required this.name,required this.phoneNumber,required this.chatList});

  @override
  List<Object?> get props => [id];
}