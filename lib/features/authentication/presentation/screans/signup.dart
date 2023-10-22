import 'dart:io';

import 'package:dalily/core/helper/dialog.dart';
import 'package:dalily/core/helper/image_helper.dart';
import 'package:dalily/core/util/styles.dart';
import 'package:dalily/features/authentication/presentation/widgets/signup_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey _formKey = GlobalKey<FormState>();

  XFile? _personalImage;
  List<XFile> _workImages = [];

  String fullName = '';
  String phoneNumber = '';
  String address = '';
  String occupation = '';

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
              child: Text(AppLocalizations.of(context)!.work_image_max_length,
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
     return value;
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 100,bottom: 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.app_name,
                  style: displayLarge(context).merge(GoogleFonts.kufam()).copyWith(fontSize: 60),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  AppLocalizations.of(context)!.welcome,
                  style: titleSmall(context),
                ),
                const SizedBox(
                  height: 50,
                ),
                Text(
                  "-------  ${AppLocalizations.of(context)!.signup}   -------",
                  style: titleSmall(context),
                ),
                const SizedBox(
                  height: 50,
                ),
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
                    if (value == null || value.isEmpty || value.length <= 11) {
                      return AppLocalizations.of(context)!.full_name_error;
                    }
                  },
                  onSaved: (value) {
                    fullName = value!;
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
                    } else if (value.length != 11) {
                      return AppLocalizations.of(context)!.wrong_phone_number_length;
                    } else if (!value.startsWith('010') && !value.startsWith('011') && !value.startsWith('012') && !value.startsWith('015')) {
                      return AppLocalizations.of(context)!.wrong_phone_number_format;
                    }
                  },
                  onSaved: (value) {
                    phoneNumber = "+2$value";
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
                    if (value == null || value.isEmpty || value.length < 3) {
                      return AppLocalizations.of(context)!.occupation_validate_message;
                    }
                  },
                  onSaved: (value) {
                    occupation = value!;
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
                    address = value!;
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
                if(_workImages.isNotEmpty)
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
                        child: Image.file(File(_workImages[index].path),fit: BoxFit.fill,),
                      ),
                    ),
                ),
                  ),
                if(_workImages.isNotEmpty)
                  const SizedBox(
                  height: 30,
                ),
                // sign up button
                Container(
                  width: double.infinity,
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 50),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        AppLocalizations.of(context)!.signup,
                        style: titleSmall(context).copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                //log in button
                TextButton(
                  onPressed: () {},
                  child: Text(
                    AppLocalizations.of(context)!.login,
                    style: bodyMedium(context).copyWith(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
