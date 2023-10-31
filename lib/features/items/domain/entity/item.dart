
import 'package:dalily/features/authentication/data/model/service_owner_model.dart';
import 'package:dalily/features/categories/data/model/category_model.dart';

class Item {

  String catId ;
  String catArabicName ;
  String catEnglishName ;
  String catImage ;
  List<ServiceOwnerModel> itemServiceOwners;

  Item({required this.catId,required this.catArabicName,required this.catImage,required this.catEnglishName,required this.itemServiceOwners});
}