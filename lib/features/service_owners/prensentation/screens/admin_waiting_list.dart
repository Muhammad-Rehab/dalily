import 'dart:convert';

import 'package:dalily/core/emum/notification_type.dart';
import 'package:dalily/core/helper/image_helper.dart';
import 'package:dalily/core/util/app_strings.dart';
import 'package:dalily/core/util/styles.dart';
import 'package:dalily/features/authentication/data/model/service_owner_model.dart';
import 'package:dalily/features/authentication/presentation/widgets/signup_text_field.dart';
import 'package:dalily/features/categories/data/model/category_model.dart';
import 'package:dalily/features/categories/presentation/cubit/category_cubit.dart';
import 'package:dalily/features/items/data/model/ItemModel.dart';
import 'package:dalily/features/items/presentation/cubit/item_cubit.dart';
import 'package:dalily/features/language/presentation/cubit/language_cubit.dart';
import 'package:dalily/features/notification/data/model/notification_model.dart';
import 'package:dalily/features/notification/presentation/cubit/notification_cubit.dart';
import 'package:dalily/features/service_owners/data/model/servic_woner_state_model.dart';
import 'package:dalily/features/service_owners/prensentation/cubit/service_owner_state_cubit.dart';
import 'package:dalily/features/service_owners/prensentation/cubit/service_owner_state_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AdminWaitingList extends StatefulWidget {
  const AdminWaitingList({Key? key}) : super(key: key);

  @override
  State<AdminWaitingList> createState() => _AdminWaitingListState();
}

class _AdminWaitingListState extends State<AdminWaitingList> {
  List<GlobalKey<FormState>> _formKeys = [];
  List<CategoryModel> categoryModels = [];
  List<String> categoryIds = [];
  double dropDownHeight = 70;

  getDropDownLength(CategoryModel categoryModel) {
    if (categoryModel.subCategory.isNotEmpty) {
      dropDownHeight = (categoryModels.length + 1) * 70;
    } else {
      dropDownHeight = (categoryModels.length) * 70;
    }
  }

  acceptUserData({required ServiceOwnerModel serviceOwnerModel, required String userAppToken, required int index}) {
    if (!_formKeys[index].currentState!.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();
    BlocProvider.of<ServiceOwnerStateCubit>(context).updateServiceOwnerState(id: serviceOwnerModel.id, state: AppStrings.acceptedState);
    Map<String, dynamic> itemData = {};
    if (categoryModels.isEmpty) {
      CategoryModel? hold = BlocProvider.of<CategoryCubit>(context).getSingleCategory(id: serviceOwnerModel.categoryIds.last);
      itemData = {
        'cat_id': hold!.id,
        'cat_arabic_name': hold.arabicName,
        'cat_english_name': hold.englishName,
        'item_service_owners': jsonEncode([serviceOwnerModel.toJson()]),
        'cat_image': hold.image
      };
    } else {
      itemData = {
        'cat_id': categoryModels.last.id,
        'cat_arabic_name': categoryModels.last.arabicName,
        'cat_english_name': categoryModels.last.englishName,
        'item_service_owners': jsonEncode([serviceOwnerModel.toJson()]),
        'cat_image': categoryModels.last.image
      };
    }
    BlocProvider.of<ItemCubit>(context).addItem(ItemModel.fromJson(itemData), context).then((value) {
      loadWaitingList();
    });
    sendNotification(userAppToken, true);
  }

  rejectUserData(ServiceOwnerModel serviceOwnerModel, String userAppToken) {
    BlocProvider.of<ServiceOwnerStateCubit>(context)
        .updateServiceOwnerState(
      id: serviceOwnerModel.id,
      state: AppStrings.rejectedState,
      description: serviceOwnerModel.comment,
    )
        .then((value) {
      loadWaitingList();
    });
    sendNotification(userAppToken, false);
  }

  loadWaitingList() {
    BlocProvider.of<ServiceOwnerStateCubit>(context).getOwnersWaitingList();
  }

  sendNotification(String appToken, bool isAcceptedData) {
    Map<String, dynamic> notification = isAcceptedData
        ? {
            'type': NotificationType.userDataResponse.name,
            'title': 'يرجي الاهتمام',
            'content': 'تمت مراجعه بياناتك والموافقه عليها من قبل الادمن وستظهر بياناتك في الخدمات ويمكنك الان تسجيل الدخول',
            'is_user_data_accepted': isAcceptedData,
          }
        : {
            'type': NotificationType.userDataResponse.name,
            'title': 'يرجي الاهتمام',
            'content': 'للاسف تم رفض بياناتك من قبل الادمن يرجي التاكد من صحه بياناتك وإعادة تسجيل حساب مره أخري',
            'is_user_data_accepted': isAcceptedData,
          };
    BlocProvider.of<NotificationCubit>(context).sendNotification(
      appToken: appToken,
      notificationModel: NotificationModel.fromJson(notification),
    );
  }

  @override
  void initState() {
    super.initState();
    loadWaitingList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: BlocConsumer<ServiceOwnerStateCubit, ServiceOwnerStateStates>(
          listener: (context, state) {
            if (state is ServiceOwnerStateError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.general_error,
                      style: bodySmall(context).copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ServiceOwnerStateError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 150,
                      width: 150,
                      child: Image.asset(
                        ImageHelper.badConnection,
                        fit: BoxFit.fill,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      child: Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.general_error,
                          style: titleSmall(context),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is LoadedWaitingListState) {
              if (state.serviceOwnersModel.isEmpty) {
                return Center(
                  child: Text(
                    'There is No users waiting for submission',
                    style: titleSmall(context),
                  ),
                );
              }
              return ListView.builder(
                itemCount: state.serviceOwnersModel.length,
                itemBuilder: (context, index) {
                  ServiceOwnerStateModel serviceOwnerStateModel = state.serviceOwnersModel[index];
                  ServiceOwnerModel serviceOwnerModel = serviceOwnerStateModel.serviceOwnerModel;
                  _formKeys.add(GlobalKey<FormState>());
                  return Form(
                    key: _formKeys[index],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //image
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          width: 220,
                          height: 160,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: (serviceOwnerModel.personalImage != null)
                                ? Image.network(
                                    serviceOwnerModel.personalImage!,
                                    fit: BoxFit.fill,
                                  )
                                : Image.asset(
                                    ImageHelper.avatarImage,
                                    fit: BoxFit.fill,
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
                          initialValue: serviceOwnerModel.name,
                          validator: (value) {
                            if (value == null || value.isEmpty || value.replaceAll(' ', '').length < 9) {
                              return AppLocalizations.of(context)!.full_name_error;
                            }
                            return null;
                          },
                          onSaved: (value) {
                            serviceOwnerModel.name = value!;
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),

                        //phone number
                        SignUpTextField(
                          labelText: AppLocalizations.of(context)!.phone_number,
                          keyboardType: TextInputType.phone,
                          initialValue: serviceOwnerModel.phoneNumber,
                          hintText: AppLocalizations.of(context)!.phone_number_hint,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!.empty_phone_number;
                            } else if (value.replaceAll(' ', '').length != 13) {
                              return AppLocalizations.of(context)!.wrong_phone_number_length;
                            } else if (!value.startsWith('+2010') &&
                                !value.startsWith('+2011') &&
                                !value.startsWith('+2012') &&
                                !value.startsWith('+2015')) {
                              return AppLocalizations.of(context)!.wrong_phone_number_format;
                            }
                            return null;
                          },
                          onSaved: (value) {
                            serviceOwnerModel.phoneNumber = value!.replaceAll(' ', '');
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
                          initialValue: serviceOwnerModel.address,
                          hintText: AppLocalizations.of(context)!.address_if_exist,
                          onSaved: (value) {
                            serviceOwnerModel.address = (value != null && value.replaceAll(' ', '').isEmpty) ? null : value;
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
                                "Parent Categories",
                                style: bodyLarge(context).copyWith(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                        if (serviceOwnerModel.categoryIds.isEmpty)
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
                                        if (val == null) {
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
                                          if (val == null) {
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
                                          if (val == null) {
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
                        if (serviceOwnerModel.categoryIds.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 60),
                            height: serviceOwnerModel.categoryIds.length * 40,
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: serviceOwnerModel.categoryIds.length,
                              itemBuilder: (context, catIndex) => Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  serviceOwnerModel.categoryIds[catIndex],
                                  style: titleSmall(context),
                                ),
                              ),
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
                          initialValue: serviceOwnerModel.serviceName,
                          onSaved: (value) {
                            serviceOwnerModel.serviceName = (value != null && value.replaceAll(' ', '').isEmpty) ? null : value;
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
                          initialValue: serviceOwnerModel.serviceDescription,
                          onSaved: (value) {
                            serviceOwnerModel.serviceDescription = (value != null && value.replaceAll(' ', '').isEmpty) ? null : value;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),

                        // work images
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
                                "Previous work images",
                                style: bodyLarge(context).copyWith(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),

                        // work images
                        if (serviceOwnerModel.workImages != null && serviceOwnerModel.workImages!.isNotEmpty)
                          Container(
                            height: 120,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.symmetric(horizontal: 50),
                            child: ListView.builder(
                              itemCount: serviceOwnerModel.workImages!.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, imageIndex) => Container(
                                width: 100,
                                height: 100,
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    serviceOwnerModel.workImages![imageIndex],
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        if (serviceOwnerModel.workImages != null && serviceOwnerModel.workImages!.isNotEmpty)
                          const SizedBox(
                            height: 30,
                          ),

                        // second phone number
                        SignUpTextField(
                          labelText: AppLocalizations.of(context)!.second_phone_number,
                          keyboardType: TextInputType.phone,
                          initialValue: serviceOwnerModel.secondPhoneNumber,
                          hintText: AppLocalizations.of(context)!.phone_number_hint,
                          validator: (value) {
                            if (value != null && value.replaceAll(' ', '').isNotEmpty && value.length != 13) {
                              return AppLocalizations.of(context)!.wrong_phone_number_length;
                            } else if (value != null &&
                                value.replaceAll(' ', '').isNotEmpty &&
                                !value.startsWith('+2010') &&
                                !value.startsWith('+2011') &&
                                !value.startsWith('+2012') &&
                                !value.startsWith('+2015')) {
                              return AppLocalizations.of(context)!.wrong_phone_number_format;
                            }
                            return null;
                          },
                          onSaved: (value) {
                            serviceOwnerModel.secondPhoneNumber = value;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // third phone number
                        SignUpTextField(
                          labelText: AppLocalizations.of(context)!.third_phone_number,
                          keyboardType: TextInputType.phone,
                          initialValue: serviceOwnerModel.thirdPhoneNumber,
                          hintText: AppLocalizations.of(context)!.phone_number_hint,
                          validator: (value) {
                            if (value != null && value.replaceAll(' ', '').isNotEmpty && value.length != 13) {
                              return AppLocalizations.of(context)!.wrong_phone_number_length;
                            } else if (value != null &&
                                value.replaceAll(' ', '').isNotEmpty &&
                                !value.startsWith('+2010') &&
                                !value.startsWith('+2011') &&
                                !value.startsWith('+2012') &&
                                !value.startsWith('+2015')) {
                              return AppLocalizations.of(context)!.wrong_phone_number_format;
                            }
                            return null;
                          },
                          onSaved: (value) {
                            serviceOwnerModel.thirdPhoneNumber = value;
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),

                        // comment
                        SignUpTextField(
                          labelText: AppLocalizations.of(context)!.comment,
                          keyboardType: TextInputType.text,
                          initialValue: serviceOwnerModel.comment,
                          onChanged: (val) {
                            serviceOwnerModel.comment = val;
                            return null;
                          },
                          maxLines: 1,
                        ),
                        const SizedBox(
                          height: 30,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  acceptUserData(serviceOwnerModel: serviceOwnerModel, userAppToken: serviceOwnerStateModel.appToken, index: index);
                                },
                                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.primary)),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  alignment: Alignment.center,
                                  width: 100,
                                  child: Text(
                                    'Confirm',
                                    style: titleSmall(context).copyWith(color: Colors.white),
                                  ),
                                )),
                            ElevatedButton(
                                onPressed: () {
                                  rejectUserData(serviceOwnerModel, serviceOwnerStateModel.appToken);
                                },
                                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(10),
                                  width: 100,
                                  child: Text(
                                    'Reject',
                                    style: titleSmall(context).copyWith(color: Colors.white),
                                  ),
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(
                          thickness: 5,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
