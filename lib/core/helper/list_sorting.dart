import 'package:dalily/features/authentication/data/model/service_owner_model.dart';
import 'package:dalily/features/categories/data/model/category_model.dart';

class ListSortingHelper {

  static List<CategoryModel> sortCategories (List<CategoryModel> catList,bool isArabic){
    catList.sort((a, b) {
      if (isArabic) {
        return a.arabicName.compareTo(b.arabicName);
      } else {
        return a.englishName.compareTo(b.englishName);
      }
    });
    return catList ;
  }

  static List<ServiceOwnerModel> sortServiceOwners (List<ServiceOwnerModel> serviceList){
    serviceList.sort((a, b) {
      int ratingRatio = b.rateModel.averageRating.compareTo(a.rateModel.averageRating);
      return ratingRatio == 0 ? a.name.compareTo(b.name) : ratingRatio;
    });
    return serviceList ;
  }

 }
