import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dalily/config/routes.dart';
import 'package:dalily/core/helper/dialog.dart';
import 'package:dalily/core/helper/image_helper.dart';
import 'package:dalily/core/util/app_strings.dart';
import 'package:dalily/core/util/styles.dart';
import 'package:dalily/features/authentication/data/model/service_owner_model.dart';
import 'package:dalily/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:dalily/features/authentication/presentation/cubit/authentications_state.dart';
import 'package:dalily/features/authentication/presentation/screans/main_auth.dart';
import 'package:dalily/features/authentication/presentation/widgets/auth_header_widget.dart';
import 'package:dalily/features/authentication/presentation/widgets/signup_text_field.dart';
import 'package:dalily/features/categories/data/model/category_model.dart';
import 'package:dalily/features/categories/presentation/cubit/category_cubit.dart';
import 'package:dalily/features/items/data/model/ItemModel.dart';
import 'package:dalily/features/items/presentation/cubit/item_cubit.dart';
import 'package:dalily/features/language/presentation/cubit/language_cubit.dart';
import 'package:dalily/features/service_owners/data/model/servic_woner_state_model.dart';
import 'package:dalily/features/service_owners/prensentation/cubit/service_owner_state_cubit.dart';
import 'package:dalily/features/service_owners/prensentation/cubit/service_owner_state_states.dart';
import 'package:dalily/features/theme/presentation/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends StatefulWidget {
  bool isAdmin;

  SignUpScreen({Key? key, this.isAdmin = false}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  XFile? _personalImage;
  List<String> _workImages = [];
  List<String> categoryIds = [];
  Map<String, dynamic> userData = {
    'id': '',
    'name': '',
    "phone_number": "",
    "category_ids": [],
    'work_images': [],
  };
  List<CategoryModel> categoryModels = [];
  double dropDownHeight = 70;
  bool isLoading = false ;
  bool extraPhoneNumbers = false;

  pickImage(ImageSource src) async {
    final ImagePicker imagePicker = ImagePicker();
    _personalImage = await imagePicker.pickImage(source: src);
    setState(() {});
  }

  Future<void> pickMultipleImage() async {
    final ImagePicker imagePicker = ImagePicker();
    _workImages = await imagePicker.pickMultiImage().then((value) {
      if (value.length > 3) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: SafeArea(
              child: Text(
                AppLocalizations.of(context)!.work_image_max_length,
                style: bodyVerSmall(context).copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.secondary,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.symmetric(horizontal: 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        );
        value = value.sublist(0, 3);
      }
      return value.map((e) => e.path).toList();
    });
    setState(() {});
  }

  sendOtp() {
    if (!_formKey.currentState!.validate()) {
      return;
    } else {
      _formKey.currentState!.save();
      FocusScope.of(context).unfocus();
      userData['personal_image'] = _personalImage?.path;
      userData['work_images'] = _workImages;
      userData['category_ids'] = categoryIds;
      ServiceOwnerModel serviceOwnerModel = ServiceOwnerModel.fromJson(userData);
      if (widget.isAdmin) {
        setState(() {
          isLoading = true ;
        });
        serviceOwnerModel.id = UniqueKey().toString();
        Map<String, dynamic> data = {
          'id': serviceOwnerModel.id,
          'state': AppStrings.acceptedState,
          'app_token': 'app_token',
          'service_owner_model': jsonEncode(serviceOwnerModel.toJson()),
        };
        BlocProvider.of<ServiceOwnerStateCubit>(context)
            .addServiceOwnerModel(ServiceOwnerStateModel.fromJson(data));

      } else {
        BlocProvider.of<AuthenticationCubit>(context).sendOtp(
          serviceOwnerModel.phoneNumber,
          context,
          serviceOwnerModel: serviceOwnerModel,
          fromRegister: true,
        );
      }
    }
  }

  getDropDownLength(CategoryModel categoryModel) {
    if (categoryModel.subCategory.isNotEmpty) {
      dropDownHeight = (categoryModels.length + 1) * 70;
    } else {
      dropDownHeight = (categoryModels.length) * 70;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 255,
            backgroundColor: Theme.of(context).colorScheme.background,
            floating: true,
            pinned: true,
            excludeHeaderSemantics: true,
            // automaticallyImplyLeading: false,
            leading: widget.isAdmin ? IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: BlocProvider.of<ThemeCubit>(context).isDark
                    ? Theme.of(context).colorScheme.surface
                    : Theme.of(context).colorScheme.primary,
              ),
            ) : null,
            actions: [
              if(!widget.isAdmin)
                IconButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.categoryScreen, (route) => false);
                  },
                  icon: Icon(
                    Icons.home_filled,
                    color: BlocProvider.of<ThemeCubit>(context).isDark
                        ? Theme.of(context).colorScheme.surface
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: BlocProvider.of<LanguageCubit>(context).isArabic
                  ? Text(
                      AppLocalizations.of(context)!.signup,
                      style: titleSmall(context),
                    )
                  : null,
              background: FittedBox(
                child: Container(
                    padding: const EdgeInsets.only(top: 80, bottom: 30),
                    child: AuthHeaderWidget(
                      pageTitle: AppLocalizations.of(context)!.signup,
                      isTitleExist: !BlocProvider.of<LanguageCubit>(context).isArabic,
                    )),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate.fixed([
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //image
                    Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: (_personalImage != null)
                            ? CircleAvatar(
                                backgroundImage: FileImage(File(_personalImage!.path)),
                                child: InkWell(
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
                                    color: _personalImage != null ? Colors.grey.withOpacity(.1) : Colors.grey.withOpacity(.8),
                                    width: 100,
                                    height: 100,
                                    child: const Icon(
                                      Icons.add_a_photo_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            : Stack(
                                children: [
                                  Image.asset(
                                    ImageHelper.avatarImage,
                                    fit: BoxFit.fill,
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
                                      color: _personalImage != null ? Colors.grey.withOpacity(.1) : Colors.grey.withOpacity(.8),
                                      width: 100,
                                      height: 100,
                                      child: const Icon(
                                        Icons.add_a_photo_outlined,
                                        color: Colors.white,
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

                    //full name
                    SignUpTextField(
                      labelText: AppLocalizations.of(context)!.full_name,
                      keyboardType: TextInputType.name,
                      hintText: AppLocalizations.of(context)!.full_name_hint,
                      validator: (value) {
                        if (value == null || value.isEmpty || value.replaceAll(' ', '').length < 9) {
                          return AppLocalizations.of(context)!.full_name_error;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        userData["name"] = value!;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    //phone number
                    SignUpTextField(
                      labelText: AppLocalizations.of(context)!.phone_number,
                      keyboardType: TextInputType.phone,
                      isPhoneNumber: true,
                      hintText: AppLocalizations.of(context)!.phone_number_hint,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.empty_phone_number;
                        } else if (value.replaceAll(' ', '').length != 11) {
                          return AppLocalizations.of(context)!.wrong_phone_number_length;
                        } else if (!value.startsWith('010') && !value.startsWith('011') && !value.startsWith('012') && !value.startsWith('015')) {
                          return AppLocalizations.of(context)!.wrong_phone_number_format;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        userData['phone_number'] = "+2${value!.replaceAll(' ', '')}";
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    // address
                    SignUpTextField(
                      labelText: AppLocalizations.of(context)!.address,
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      hintText: AppLocalizations.of(context)!.address_if_exist,
                      onSaved: (value) {
                        userData['address'] = (value != null && value.replaceAll(' ', '').isEmpty) ? null : value;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    // select category
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 50,
                      ),
                      padding: const EdgeInsets.all(10),
                      height: 50,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.select_category,
                            style: bodyMedium(context).copyWith(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 50,
                      ),
                      padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context)!.add_comment,
                              style: bodyVerSmall(context).copyWith(fontWeight: FontWeight.bold, color: Colors.red),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 50),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: List.generate(categoryModels.length + 1, (index) {
                          if (categoryModels.isEmpty) {
                            return Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary.withOpacity(.3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: DropdownButtonFormField<CategoryModel>(
                                borderRadius: BorderRadius.circular(20),
                                dropdownColor: Theme.of(context).colorScheme.background,
                                iconSize: 20,
                                icon: Icon(
                                  Icons.arrow_drop_down_circle_outlined,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                                items: BlocProvider.of<CategoryCubit>(context)
                                    .appCategories
                                    .map(
                                      (item) => DropdownMenuItem<CategoryModel>(
                                        value: item,
                                        child: Text(
                                          BlocProvider.of<LanguageCubit>(context).isArabic ? item.arabicName : item.englishName,
                                          style: titleSmall(context),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                validator: (val) {
                                  if (val == null && userData['comment'].isEmpty) {
                                    return AppLocalizations.of(context)!.occupation_validate_message;
                                  }
                                  return null;
                                },
                                onSaved: (val) {
                                  if (val != null && !categoryIds.contains(val.id)) {
                                    categoryIds.add(val.id);
                                  }
                                },
                                onChanged: (val) {
                                  categoryModels.add(val!);
                                  getDropDownLength(val);
                                  setState(() {});
                                },
                              ),
                            );
                          } else {
                            if (index == 0) {
                              return Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.secondary.withOpacity(.3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: DropdownButtonFormField<CategoryModel>(
                                  borderRadius: BorderRadius.circular(20),
                                  iconSize: 20,
                                  dropdownColor: Theme.of(context).colorScheme.background,
                                  icon: Icon(
                                    Icons.arrow_drop_down_circle_outlined,
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                                  value: categoryModels[index],
                                  items: BlocProvider.of<CategoryCubit>(context)
                                      .appCategories
                                      .map(
                                        (item) => DropdownMenuItem<CategoryModel>(
                                          value: item,
                                          child: Text(
                                            BlocProvider.of<LanguageCubit>(context).isArabic ? item.arabicName : item.englishName,
                                            style: titleSmall(context),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  validator: (val) {
                                    if (val == null && userData['comment'].isEmpty) {
                                      return AppLocalizations.of(context)!.occupation_validate_message;
                                    }
                                    return null;
                                  },
                                  onSaved: (val) {
                                    if (val != null && !categoryIds.contains(val.id)) {
                                      categoryIds.add(val.id);
                                    }
                                  },
                                  onChanged: (val) {
                                    if (!categoryModels.contains(val)) {
                                      categoryModels.clear();
                                      categoryModels.add(val!);
                                      if (val.subCategory.isNotEmpty) {
                                        dropDownHeight += 70;
                                      }
                                      setState(() {});
                                    }
                                  },
                                ),
                              );
                            } else if (categoryModels[index - 1].subCategory.isNotEmpty) {
                              return Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.secondary.withOpacity(.3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: DropdownButtonFormField<CategoryModel>(
                                  dropdownColor: Theme.of(context).colorScheme.background,
                                  borderRadius: BorderRadius.circular(20),
                                  iconSize: 20,
                                  icon: Icon(
                                    Icons.arrow_drop_down_circle_outlined,
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                                  items: categoryModels[index - 1]
                                      .subCategory
                                      .map(
                                        (item) => DropdownMenuItem<CategoryModel>(
                                          value: item,
                                          child: Text(
                                            BlocProvider.of<LanguageCubit>(context).isArabic ? item.arabicName : item.englishName,
                                            style: titleSmall(context),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  validator: (val) {
                                    if (val == null && userData['comment'].isEmpty) {
                                      return AppLocalizations.of(context)!.occupation_validate_message;
                                    }
                                    return null;
                                  },
                                  onSaved: (val) {
                                    if (val != null && !categoryIds.contains(val.id)) {
                                      categoryIds.add(val.id);
                                    }
                                  },
                                  onChanged: (val) {
                                    if (!categoryModels.contains(val)) {
                                      categoryModels.removeRange(index, categoryModels.length);
                                      categoryModels.add(val!);
                                      getDropDownLength(val);
                                      setState(() {});
                                    }
                                  },
                                ),
                              );
                            } else {
                              return Container();
                            }
                          }
                        }),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    //service name
                    SignUpTextField(
                      labelText: AppLocalizations.of(context)!.service_name,
                      keyboardType: TextInputType.text,
                      hintText: AppLocalizations.of(context)!.service_name_hint,
                      onSaved: (value) {
                        userData["service_name"] = (value != null && value.replaceAll(' ', '').isEmpty) ? null : value;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    // description
                    SignUpTextField(
                      labelText: AppLocalizations.of(context)!.description,
                      keyboardType: TextInputType.text,
                      maxLines: 3,
                      hintText: AppLocalizations.of(context)!.description_hint,
                      onSaved: (value) {
                        userData['description'] = (value != null && value.replaceAll(' ', '').isEmpty) ? null : value;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    // work image button
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 50),
                      child: TextButton(
                        onPressed: () {
                          pickMultipleImage();
                        },
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary, shape: BoxShape.circle),
                              child: Icon(
                                Icons.add,
                                color: Theme.of(context).colorScheme.background,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                AppLocalizations.of(context)!.pick_work_images,
                                style: bodyVerSmall(context).copyWith(fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    // work images
                    if (_workImages.isNotEmpty)
                      Container(
                        height: 120,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 50),
                        child: ListView.builder(
                          itemCount: _workImages.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                File(_workImages[index]),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (_workImages.isNotEmpty)
                      const SizedBox(
                        height: 30,
                      ),

                    // phone numbers button
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 50),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            extraPhoneNumbers = !extraPhoneNumbers;
                          });
                        },
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary, shape: BoxShape.circle),
                              child: Icon(
                                extraPhoneNumbers ? Icons.arrow_drop_up_sharp : Icons.phone,
                                color: Theme.of(context).colorScheme.background,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                AppLocalizations.of(context)!.add_other_phone_numbers,
                                style: bodyVerSmall(context).copyWith(fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    if (extraPhoneNumbers)
                      SignUpTextField(
                        labelText: AppLocalizations.of(context)!.second_phone_number,
                        keyboardType: TextInputType.phone,
                        isPhoneNumber: true,
                        hintText: AppLocalizations.of(context)!.phone_number_hint,
                        validator: (value) {
                          if (value != null && value.replaceAll(' ', '').isNotEmpty && value.length != 11) {
                            return AppLocalizations.of(context)!.wrong_phone_number_length;
                          } else if (value != null &&
                              value.replaceAll(' ', '').isNotEmpty &&
                              !value.startsWith('010') &&
                              !value.startsWith('011') &&
                              !value.startsWith('012') &&
                              !value.startsWith('015')) {
                            return AppLocalizations.of(context)!.wrong_phone_number_format;
                          }
                          return null;
                        },
                        onSaved: (value) {
                          if(value != null && value.isNotEmpty){
                            userData['second_phone_number'] = "+2$value";
                          }
                        },
                      ),
                    if (extraPhoneNumbers)
                      const SizedBox(
                        height: 10,
                      ),
                    if (extraPhoneNumbers)
                      SignUpTextField(
                        labelText: AppLocalizations.of(context)!.third_phone_number,
                        keyboardType: TextInputType.phone,
                        isPhoneNumber: true,
                        hintText: AppLocalizations.of(context)!.phone_number_hint,
                        validator: (value) {
                          if (value != null && value.replaceAll(' ', '').isNotEmpty && value.length != 11) {
                            return AppLocalizations.of(context)!.wrong_phone_number_length;
                          } else if (value != null &&
                              value.replaceAll(' ', '').isNotEmpty &&
                              !value.startsWith('010') &&
                              !value.startsWith('011') &&
                              !value.startsWith('012') &&
                              !value.startsWith('015')) {
                            return AppLocalizations.of(context)!.wrong_phone_number_format;
                          }
                          return null;
                        },
                        onSaved: (value) {
                          if(value != null && value.isNotEmpty){
                            userData['third_phone_number'] = "+2$value";
                          }
                        },
                      ),
                    if (extraPhoneNumbers)
                      const SizedBox(
                        height: 30,
                      ),

                    // comment
                    SignUpTextField(
                      labelText: AppLocalizations.of(context)!.comment,
                      keyboardType: TextInputType.text,
                      onChanged: (val) {
                        userData['comment'] = val;
                        return null;
                      },
                      maxLines: 1,
                      validator: (val) {
                        if ((val == null || val.isEmpty) && categoryModels.isEmpty) {
                          return AppLocalizations.of(context)!.comment_error;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    // sign up button
                    BlocListener<ServiceOwnerStateCubit,ServiceOwnerStateStates>(
                      listener: (previousState,currentState){
                        if(currentState is AddedOwnerState && widget.isAdmin){
                          Map<String,dynamic> itemData = {
                            'cat_id': categoryModels.last.id,
                            'cat_arabic_name': categoryModels.last.arabicName,
                            'cat_english_name': categoryModels.last.englishName,
                            'item_service_owners': jsonEncode([currentState.serviceOwnerModel.toJson()]),
                            'cat_image': categoryModels.last.image
                          };
                          BlocProvider.of<ItemCubit>(context).addItem(ItemModel.fromJson(itemData), context);
                          setState(() {
                            isLoading = false ;
                          });
                          showCustomDialog(
                              context: context,
                              dialogType: DialogType.success,
                              description: AppLocalizations.of(context)!.user_data_added,
                              okText: AppLocalizations.of(context)!.ok,
                              onOK: () {});
                        }
                      },
                      child: BlocBuilder<AuthenticationCubit, AuthenticationState>(builder: (context, state) {
                          if (state is IsSendingOtpState) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Container(
                            width: double.infinity,
                            height: 50,
                            margin: const EdgeInsets.symmetric(horizontal: 50),
                            child: isLoading ? const Center(child: CircularProgressIndicator())
                                :ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: ElevatedButton(
                                onPressed: () {
                                  sendOtp();
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.signup,
                                  style: titleSmall(context).copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                          );
                        }),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    //log in button
                    if(!widget.isAdmin)
                      TextButton(
                      onPressed: () {
                        BlocProvider.of<AuthenticationCubit>(context).initAuthCubit(InitialAuthenticationState());
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => MainAuthScreen()),(_)=> false);
                      },
                      child: Text(
                        AppLocalizations.of(context)!.login,
                        style: bodyMedium(context).copyWith(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
