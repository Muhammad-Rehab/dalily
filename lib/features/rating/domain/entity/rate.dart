

import 'package:equatable/equatable.dart';

class Rate extends Equatable {
  final String id ;
  int totalRateNumber ;
  Map<String,dynamic> numOfRate ;
  double averageRating ;
  List rateList ;

  Rate({
    required this.id,
    required this.averageRating,
    required this.numOfRate,
    required this.totalRateNumber,
    required this.rateList,
});

  @override
  List<Object?> get props => [id];
}