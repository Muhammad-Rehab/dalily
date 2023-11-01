import 'dart:convert';

import 'package:dalily/features/authentication/data/model/service_owner_model.dart';
import 'package:dalily/features/service_owners/domain/entity/service_owner_state.dart';

class ServiceOwnerStateModel extends ServiceOwnerState {
  ServiceOwnerStateModel({required super.id, required super.serviceOwnerModel, required super.state, super.description});

  factory ServiceOwnerStateModel.fromJson(Map<String, dynamic> json) {
    return ServiceOwnerStateModel(
      id: json['id'],
      serviceOwnerModel: ServiceOwnerModel.fromJson(jsonDecode(json['service_owner_model'])),
      state: json['state'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'state':state,
      'description': description,
      'service_owner_model': jsonEncode(serviceOwnerModel.toJson()),
    };
  }
}
