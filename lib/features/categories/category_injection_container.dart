import 'package:dalily/config/super_injection_container.dart';
import 'package:dalily/features/categories/data/data_resources/local_data_resource.dart';
import 'package:dalily/features/categories/data/data_resources/remote_data_resource.dart';
import 'package:dalily/features/categories/data/repositroy/category_repository_imp.dart';
import 'package:dalily/features/categories/domain/repository/category_repo.dart';
import 'package:dalily/features/categories/domain/use_cases/add_category.dart';
import 'package:dalily/features/categories/domain/use_cases/get_category.dart';
import 'package:dalily/features/categories/domain/use_cases/get_single_local_cat.dart';
import 'package:dalily/features/categories/domain/use_cases/storeCatImages.dart';
import 'package:dalily/features/categories/domain/use_cases/update_category.dart';
import 'package:dalily/features/categories/presentation/cubit/category_cubit.dart';
import 'package:firebase_storage/firebase_storage.dart';

categoryInjectionContainer() {
  serverLocator.registerFactory(
    () => CategoryCubit(
      getCategoryUseCase: serverLocator(),
      addCategoryUseCase: serverLocator(),
      updateCategoryUseCase: serverLocator(),
      getSingleLocalCategoryUseCase: serverLocator(),
      storeCatImagesUseCase: serverLocator(),
    ),
  );

  serverLocator.registerLazySingleton(() => GetCategoryUseCase(categoryRepository: serverLocator()));
  serverLocator.registerLazySingleton(() => GetSingleLocalCategoryUseCase(categoryRepository: serverLocator()));
  serverLocator.registerLazySingleton(() => AddCategoryUseCase(categoryRepository: serverLocator()));
  serverLocator.registerLazySingleton(() => UpdateCategoryUseCase(categoryRepository: serverLocator()));
  serverLocator.registerLazySingleton(() => StoreCatImagesUseCase(categoryRepository: serverLocator()));

  serverLocator.registerLazySingleton<CategoryRepository>(() =>
      CategoryRepositoryImp(categoryRemoteDataResource: serverLocator(), categoryLocalDataResource: serverLocator(), connectivity: serverLocator()));

  serverLocator.registerLazySingleton<CategoryLocalDataResource>(
    () => CategoryLocalDataResourceImp(
      sharedPreferences: serverLocator(),
    ),
  );
  serverLocator.registerLazySingleton<CategoryRemoteDataResource>(
      () => CategoryRemoteDataResourceImp(firebaseFirestore: serverLocator(), firebaseStorage: serverLocator()));

  serverLocator.registerLazySingleton(() => FirebaseStorage.instance);
}
