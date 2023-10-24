import 'dart:io';

import 'package:dalily/core/helper/dialog.dart';
import 'package:dalily/core/helper/image_helper.dart';
import 'package:dalily/core/util/styles.dart';
import 'package:dalily/features/authentication/data/model/service_owner_model.dart';
import 'package:dalily/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:dalily/features/authentication/presentation/cubit/authentications_state.dart';
import 'package:dalily/features/authentication/presentation/screans/main_auth.dart';
import 'package:dalily/features/authentication/presentation/widgets/auth_header_widget.dart';
import 'package:dalily/features/authentication/presentation/widgets/signup_text_field.dart';
import 'package:dalily/features/language/presentation/cubit/language_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  XFile? _personalImage;
  List<String> _workImages = [];
  Map<String, dynamic> userData = {
    'id': '',
    'name': '',
    "phone_number": "",
    "address": "",
    "occupation": '',
    'work_images': [],
    'personal_image': '',
    'second_phone_number': '',
    'third_phone_number': '',
  };

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
      userData['personal_image'] = _personalImage?.path;
      userData['work_images'] = _workImages;
      ServiceOwnerModel serviceOwnerModel = ServiceOwnerModel.fromJson(userData);
      BlocProvider.of<AuthenticationCubit>(context).sendOtp(
        serviceOwnerModel.phoneNumber,
        context,
        serviceOwnerModel: serviceOwnerModel,
        fromRegister: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 255,
          backgroundColor: Theme.of(context).colorScheme.background,
          floating: true,
          pinned: true,
          excludeHeaderSemantics: true,
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
                    },
                    onSaved: (value) {
                      userData['phone_number'] = "+2${value!.replaceAll(' ', '')}";
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  //Occupation
                  SignUpTextField(
                    labelText: AppLocalizations.of(context)!.occupation,
                    keyboardType: TextInputType.text,
                    hintText: AppLocalizations.of(context)!.occupation_hint,
                    validator: (value) {
                      if (value == null || value.isEmpty || value.replaceAll(' ', '').length < 3) {
                        return AppLocalizations.of(context)!.occupation_validate_message;
                      }
                    },
                    onSaved: (value) {
                      userData['occupation'] = value!;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  // address
                  SignUpTextField(
                    labelText: AppLocalizations.of(context)!.address,
                    keyboardType: TextInputType.text,
                    maxLines: 2,
                    hintText: AppLocalizations.of(context)!.address_if_exist,
                    onSaved: (value) {
                      userData['address'] = value!;
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
                    height: 10,
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
                      },
                      onSaved: (value) {
                        userData['second_phone_number'] = "+2$value";
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
                      },
                      onSaved: (value) {
                        userData['third_phone_number'] = "+2$value";
                      },
                    ),
                  if (extraPhoneNumbers)
                    const SizedBox(
                      height: 30,
                    ),
                  // sign up button
                  BlocBuilder<AuthenticationCubit, AuthenticationState>(builder: (context, state) {
                    if (state is IsSendingOtpState) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Container(
                      width: double.infinity,
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 50),
                      child: ClipRRect(
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
                  const SizedBox(
                    height: 10,
                  ),
                  //log in button
                  TextButton(
                    onPressed: () {
                      BlocProvider.of<AuthenticationCubit>(context).initAuthCubit(InitialAuthenticationState());
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => MainAuthScreen()));
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
    );
  }
}
