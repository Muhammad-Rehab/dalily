import 'dart:convert';

import 'package:dalily/features/rating/domain/entity/rate.dart';

class RateModel extends Rate {
  RateModel({
    required super.id,
    required super.averageRating,
    required super.numOfRate,
    required super.totalRateNumber,
    required super.rateList,
  });

  factory RateModel.fromJson(Map<String, dynamic> json) {
    return RateModel(
      id: json['id'],
      averageRating: json['average_rate'],
      numOfRate: json['num_of_rate'],
      totalRateNumber: json['total_rate_number'],
      rateList: json['rate_list']==null ? [] : jsonDecode(json['rate_list']),
    );
  }

  Map<String,dynamic> toJson(){
    return {
      'id': id,
      'average_rate': averageRating,
      'num_of_rate': numOfRate,
      'total_rate_number': totalRateNumber,
      'rate_list': jsonEncode(rateList),
    };
  }

}
