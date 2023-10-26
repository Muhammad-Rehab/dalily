

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dalily/config/super_injection_container.dart';
import 'package:dalily/features/categories/data/data_resources/remote_data_resource.dart';
import 'package:dalily/features/categories/data/repositroy/category_repository_imp.dart';
import 'package:dalily/features/categories/domain/repository/category_repo.dart';
import 'package:dalily/features/categories/domain/use_cases/add_category.dart';
import 'package:dalily/features/categories/domain/use_cases/get_category.dart';
import 'package:dalily/features/categories/domain/use_cases/update_category.dart';
import 'package:dalily/features/categories/presentation/cubit/category_cubit.dart';
import 'package:firebase_storage/firebase_storage.dart';

categoryInjectionContainer(){
  serverLocator.registerFactory(() => CategoryCubit(
      getCategoryUseCase: serverLocator(),
      addCategoryUseCase: serverLocator(),
      updateCategoryUseCase: serverLocator(),
  ),
  );

  serverLocator.registerLazySingleton(() => GetCategoryUseCase(categoryRepository: serverLocator()));
  serverLocator.registerLazySingleton(() => AddCategoryUseCase(categoryRepository: serverLocator()));
  serverLocator.registerLazySingleton(() => UpdateCategoryUseCase(categoryRepository: serverLocator()));

  serverLocator.registerLazySingleton<CategoryRepository>(() =>
      CategoryRepositoryImp(categoryRemoteDataResource: serverLocator()));
  serverLocator.registerLazySingleton<CategoryRemoteDataResource>(() =>
      CategoryRemoteDataResourceImp(firebaseFirestore: serverLocator(),firebaseStorage: serverLocator()));

  serverLocator.registerLazySingleton(() => FirebaseStorage.instance);
}