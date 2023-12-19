
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dalily/core/error/failure.dart';
import 'package:dalily/core/util/app_strings.dart';
import 'package:dalily/features/items/data/data_resources/local_data_resource.dart';
import 'package:dalily/features/items/data/data_resources/remote_data_resource.dart';
import 'package:dalily/features/items/data/model/ItemModel.dart';
import 'package:dalily/features/items/domain/repository/item_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

class ItemRepoImp extends ItemRepository {
  ItemRemoteDataResource itemRemoteDataResource ;
  ItemLocalDataResource itemLocalDataResource ;
  Connectivity connectivity ;

  ItemRepoImp({required this.itemLocalDataResource,required this.itemRemoteDataResource,required this.connectivity});

  @override
  Future<Either<Failure, void>> addItem(ItemModel itemModel) async{
   try{
     ItemModel hold = await itemRemoteDataResource.addItemModel(itemModel);
     return Right(await itemLocalDataResource.addItem(hold));
   }catch (e){
     debugPrint('item repo imp / addItem()');
     debugPrint(e.toString());
     return const Left(ServerFailure());
   }
  }

  @override
  Future<Either<Failure, ItemModel>> getItem(String categoryId) async {
    final ConnectivityResult result = await connectivity.checkConnectivity();
   try{
     if(result != ConnectivityResult.none){
       final itemModel = await itemRemoteDataResource.getItemModel(categoryId);
       itemLocalDataResource.addItem(itemModel);
       return Right(itemModel);
     }else{
       ItemModel ? itemModel = itemLocalDataResource.getItem(categoryId);
       if(itemModel != null){
         return Right(itemModel);
       }else{
         return const Left(CashFailure(message: AppStrings.nullCashError));
       }
     }
   }catch (e){
     debugPrint('item repo imp / getItem()');
     debugPrint(e.toString());
     return const Left(CashFailure());
   }
  }

}