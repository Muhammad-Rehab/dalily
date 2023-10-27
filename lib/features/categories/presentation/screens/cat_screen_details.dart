import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dalily/core/helper/dialog.dart';
import 'package:dalily/core/helper/image_helper.dart';
import 'package:dalily/core/util/styles.dart';
import 'package:dalily/features/categories/data/model/category_model.dart';
import 'package:dalily/features/categories/presentation/cubit/category_cubit.dart';
import 'package:dalily/features/categories/presentation/cubit/category_states.dart';
import 'package:dalily/features/language/presentation/cubit/language_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

class CategoryDetailsScreen extends StatefulWidget {
  const CategoryDetailsScreen({Key? key}) : super(key: key);

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreen();
}

class _CategoryDetailsScreen extends State<CategoryDetailsScreen> {

  XFile? _categoryImage;
  String? arabicName;
  String? englishName;
  String? parentId;

  late bool isAdd;
  CategoryModel? categoryModel;

  List<CategoryModel> categoriesID = [];

  pickImage(ImageSource src) async {
    final ImagePicker imagePicker = ImagePicker();
    _categoryImage = await imagePicker.pickImage(source: src);
    setState(() {});
  }

  addCategory(BuildContext context) {
    if(isAdd){
      if (_categoryImage == null || arabicName == null || arabicName!.isEmpty || englishName == null || englishName!.isEmpty) {
        showCustomDialog(
          context: context,
          dialogType: DialogType.error,
          description: 'Fill all fields',
        );
        return;
      }
      Map<String, dynamic> data = {
        'id': UniqueKey().toString(),
        'parent_id': parentId,
        'arabic_name': arabicName,
        'english_name': englishName,
        'image': _categoryImage!.path,
      };
      BlocProvider.of<CategoryCubit>(context).addCategory(CategoryModel.fromJson(data),categoriesID);
    }else{

      Map<String, dynamic> data = {
        'id': categoryModel!.id,
        'parent_id': parentId,
        'arabic_name': arabicName ?? categoryModel!.arabicName,
        'english_name': englishName ?? categoryModel!.englishName,
        'image': (_categoryImage != null) ? _categoryImage!.path : categoryModel!.image,
      };
      BlocProvider.of<CategoryCubit>(context).update(CategoryModel.fromJson(data), (_categoryImage != null) ? true : false);

    }

  }


  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)?.settings.arguments != null) {
      Map<String, dynamic> data = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      isAdd = data['is_add'];
      categoryModel = data['category_model'];
      parentId = categoryModel!.parentId;
    } else {
      isAdd = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (isAdd) ? AppLocalizations.of(context)!.add_category : AppLocalizations.of(context)!.update_category,
          style: titleSmall(context).copyWith(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              // image
              Container(
                alignment: Alignment.center,
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      if (_categoryImage != null && isAdd)
                        SizedBox(
                          width: double.infinity,
                          child: Image.file(
                            File(_categoryImage!.path),
                            fit: BoxFit.fill,
                          ),
                        ),
                      if (_categoryImage == null && isAdd)
                        SizedBox(
                          width: double.infinity,
                          child: Image.asset(
                            ImageHelper.avatarImage,
                            fit: BoxFit.fill,
                          ),
                        ),
                      if (isAdd == false)
                        SizedBox(
                          width: double.infinity,
                          child: _categoryImage == null
                              ? Image.network(
                                  categoryModel!.image,
                                  fit: BoxFit.fill,
                                )
                              : Image.file(
                                  File(_categoryImage!.path),
                                  fit: BoxFit.fill,
                                ),
                        ),
                      InkWell(
                        onTap: () {
                          showCustomDialog(
                            context: context,
                            okText: AppLocalizations.of(context)!.camera,
                            cancelText: AppLocalizations.of(context)!.gallery,
                            description: AppLocalizations.of(context)!.pick_image_from,
                            onOK: () {
                              pickImage(ImageSource.camera);
                            },
                            onCancel: () {
                              pickImage(ImageSource.gallery);
                            },
                          );
                        },
                        child: Container(
                          color: _categoryImage != null ? Colors.grey.withOpacity(.1) : Colors.grey.withOpacity(isAdd ? 0.5 : 0.1),
                          height: 250,
                          width: double.infinity,
                          child: const Icon(
                            Icons.add_a_photo_outlined,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      ),
                      // Icon(Icons.add_a_photo)
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // arabic name field
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Theme.of(context).colorScheme.secondary),
                ),
                child: TextFormField(
                  style: bodyVerSmall(context).copyWith(fontWeight: FontWeight.bold),
                  keyboardType: TextInputType.text,
                  initialValue: isAdd ? null : categoryModel!.arabicName,
                  onChanged: (val) {
                    arabicName = val;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    labelText: AppLocalizations.of(context)!.category_name,
                    labelStyle: bodySmall(context).copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // english name field
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(30), border: Border.all(color: Theme.of(context).colorScheme.secondary)),
                child: TextFormField(
                  style: bodyVerSmall(context).copyWith(fontWeight: FontWeight.bold),
                  keyboardType: TextInputType.text,
                  initialValue: isAdd ? null : categoryModel!.englishName,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    labelText: AppLocalizations.of(context)!.category_name_en,
                    labelStyle: bodySmall(context).copyWith(fontWeight: FontWeight.bold),
                  ),
                  onChanged: (val) {
                    englishName = val;
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // parent id button
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Parent id',
                        style: titleSmall(context),
                      ),
                    ),
                    Column(
                      children: List.generate(categoriesID.length + 1, (index) {
                        if(categoriesID.isEmpty){
                          return DropdownButton<CategoryModel>(
                            alignment: Alignment.center,
                            dropdownColor: Theme.of(context).colorScheme.primary,
                            style: titleSmall(context).copyWith(color: Colors.white),
                            items: BlocProvider.of<CategoryCubit>(context)
                                .appCategories
                                .map((category) => DropdownMenuItem<CategoryModel>(
                              value: category,
                              child: SizedBox(
                                width: 150,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    BlocProvider.of<LanguageCubit>(context).isArabic ? category.arabicName : category.englishName,
                                    style: titleSmall(context),
                                  ),
                                ),
                              ),
                            ))
                                .toList(),
                            onChanged: (val) {
                                parentId = val!.id;
                                categoriesID.add(val);
                                setState(() {});
                            },
                          );
                        }else{
                          if(index == 0){
                            return DropdownButton<CategoryModel>(
                              alignment: Alignment.center,
                              dropdownColor: Theme.of(context).colorScheme.primary,
                              style: titleSmall(context).copyWith(color: Colors.white),
                              value: categoriesID.first,
                              items: BlocProvider.of<CategoryCubit>(context)
                                  .appCategories
                                  .map((category) => DropdownMenuItem<CategoryModel>(
                                value: category,
                                child: SizedBox(
                                  width: 150,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      BlocProvider.of<LanguageCubit>(context).isArabic ? category.arabicName : category.englishName,
                                      style: titleSmall(context),
                                    ),
                                  ),
                                ),
                              ))
                                  .toList(),
                              onChanged: (val) {
                                parentId = val!.id;
                                categoriesID.clear();
                                categoriesID.add(val);
                                setState(() {});
                              },
                            );
                          }else if(categoriesID[index-1].subCategory.isNotEmpty){
                            return DropdownButton<CategoryModel>(
                              alignment: Alignment.center,
                              dropdownColor: Theme.of(context).colorScheme.primary,
                              value: (index >= categoriesID.length)?null:categoriesID[index],
                              style: titleSmall(context).copyWith(color: Colors.white),
                              items: categoriesID[index-1].subCategory
                                  .map((category) => DropdownMenuItem<CategoryModel>(
                                value: category,
                                child: SizedBox(
                                  width: 150,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      BlocProvider.of<LanguageCubit>(context).isArabic ? category.arabicName : category.englishName,
                                      style: titleSmall(context),
                                    ),
                                  ),
                                ),
                              ))
                                  .toList(),
                              onChanged: (val) {
                                parentId = val!.id;
                                if(!categoriesID.contains(val)){
                                  categoriesID.removeRange(index, categoriesID.length);
                                  categoriesID.add(val);
                                }
                                setState(() {});
                              },
                            );
                          }else {
                            return Container();
                          }
                        }
                      }),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              //add category button
              BlocConsumer<CategoryCubit, CategoryState>(
                listener: (context, state) {
                  if (state is CategoryErrorState) {
                    if (state.message != null) {
                      showCustomDialog(context: context, dialogType: DialogType.error, description: state.message);
                    } else {
                      showCustomDialog(context: context, dialogType: DialogType.error, description: 'Error');
                    }
                  }
                  if (state is CategoryAddedState || state is CategoryIsUpdatedStated) {
                    showCustomDialog(context: context, dialogType: DialogType.success, description: 'Done');
                  }
                },
                builder: (context, state) {
                  if (state is CategoryIsUpdating || state is CategoryIsAdding) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return InkWell(
                    onTap: () {
                      addCategory(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      child: Text(
                        (isAdd) ? AppLocalizations.of(context)!.add_category : AppLocalizations.of(context)!.update_category,
                        style: titleSmall(context),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
