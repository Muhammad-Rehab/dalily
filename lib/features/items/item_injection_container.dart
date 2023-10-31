import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dalily/config/super_injection_container.dart';
import 'package:dalily/features/items/data/data_resources/local_data_resource.dart';
import 'package:dalily/features/items/data/data_resources/remote_data_resource.dart';
import 'package:dalily/features/items/data/repository/item_repository_imp.dart';
import 'package:dalily/features/items/domain/repository/item_repository.dart';
import 'package:dalily/features/items/domain/use_cases/add_item_use_case.dart';
import 'package:dalily/features/items/domain/use_cases/get_item_use_case.dart';
import 'package:dalily/features/items/presentation/cubit/item_cubit.dart';

getItemInjectionContainer() {
  serverLocator.registerFactory(() => ItemCubit(addItemUseCase: serverLocator(), getItemUseCase: serverLocator()));

  serverLocator.registerLazySingleton(() => AddItemUseCase(itemRepository: serverLocator()));
  serverLocator.registerLazySingleton(() => GetItemUseCase(itemRepository: serverLocator()));

  serverLocator.registerLazySingleton<ItemRepository>(
    () => ItemRepoImp(
      itemLocalDataResource: serverLocator(),
      itemRemoteDataResource: serverLocator(),
      connectivity: serverLocator(),
    ),
  );

  serverLocator.registerLazySingleton<ItemLocalDataResource>(() => ItemLocalDataResourceImp(sharedPreferences: serverLocator()));
  serverLocator.registerLazySingleton<ItemRemoteDataResource>(() => ItemRemoteDataResourceImp(firebaseFirestore: serverLocator()));
  serverLocator.registerLazySingleton(() => Connectivity());

}
