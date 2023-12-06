import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dalily/config/routes.dart';
import 'package:dalily/core/helper/dialog.dart';
import 'package:dalily/core/helper/image_helper.dart';
import 'package:dalily/core/util/styles.dart';
import 'package:dalily/features/authentication/presentation/widgets/signup_text_field.dart';
import 'package:dalily/features/items/presentation/cubit/item_cubit.dart';
import 'package:dalily/features/items/presentation/cubit/item_states.dart';
import 'package:dalily/features/temporary_user/data/model/temp_user_model.dart';
import 'package:dalily/features/temporary_user/presentation/cubit/temp_user_cubit.dart';
import 'package:dalily/features/temporary_user/presentation/cubit/temp_user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddTempUserScreen extends StatefulWidget {
  const AddTempUserScreen({Key? key}) : super(key: key);

  @override
  State<AddTempUserScreen> createState() => _AddTempUserScreenState();
}

class _AddTempUserScreenState extends State<AddTempUserScreen> {
  XFile? _personalImage;
  String? name;

  String? phoneNumber;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  pickImage(ImageSource src) async {
    final ImagePicker imagePicker = ImagePicker();
    _personalImage = await imagePicker.pickImage(source: src);
    setState(() {});
  }

  void addTempUser() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();
    _formKey.currentState!.save();
    Map<String, dynamic> userData = {
      'id': UniqueKey().toString(),
      'image': _personalImage?.path,
      'name': name,
      'phone_number': phoneNumber,
    };
    BlocProvider.of<TempUserCubit>(context).addTempUser(TempUserModel.fromJson(userData));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.temp_user_sign_up,
          style: titleSmall(context).copyWith(color: Theme.of(context).colorScheme.surface),
        ),
      ),
      body: BlocConsumer<TempUserCubit , TempUserState>(
        listener: (context, state) {
          if (state is ErrorTempUserState) {
            showCustomDialog(
              context: context,
              dialogType: DialogType.error,
              description: AppLocalizations.of(context)!.internet_connection_error,
              okText: AppLocalizations.of(context)!.ok,
            );
          } else if (state is IsAddedTempUserState) {
            showCustomDialog(
                context: context,
                dialogType: DialogType.success,
                description: AppLocalizations.of(context)!.temp_user_signed_in_success,
                okText: AppLocalizations.of(context)!.ok,
                autoDismiss: false,
                onOK: (){},

                autoDismissCallBack: (type){
                  Navigator.pushNamedAndRemoveUntil(context, AppRoutes.categoryScreen, (route) => false);
                }
                );
          }
        },
        builder: (context, state) => Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Form(
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
                      if (value == null || value.isEmpty || value.replaceAll(' ', '').length < 6) {
                        return AppLocalizations.of(context)!.full_name_error;
                      }
                      return null;
                    },
                    onSaved: (value) {
                      name = value;
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
                      phoneNumber = "+2${value!.replaceAll(' ', '')}";
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),

                  //button
                  if (state is IsAddingTempUserState)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  if (state is! IsAddingTempUserState)
                  InkWell(
                    onTap: () {
                      addTempUser();
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 50),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.temp_user_sign_up,
                        style: titleSmall(context).copyWith(color: Theme.of(context).colorScheme.surface),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
