
import 'package:dalily/features/items/data/model/ItemModel.dart';
import 'package:equatable/equatable.dart';

abstract class ItemState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ItemInitialState extends ItemState {}

class ItemIsAddingState extends ItemState {}
class ItemAddedState extends ItemState {}

class ItemIsLoadingState extends ItemState {}
class ItemLoadedState extends ItemState {
  final ItemModel itemModel ;
  ItemLoadedState({required this.itemModel});
}


class ItemErrorState extends ItemState {
  final String  message ;
  ItemErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}



