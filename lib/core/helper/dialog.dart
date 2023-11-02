

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dalily/core/util/styles.dart';
import 'package:flutter/material.dart';

showCustomDialog ({required BuildContext context,String ?title, DialogType dialogType = DialogType.info,
  void Function() ?onCancel,void Function() ? onOK ,String ? body,String ? description,String ? cancelText,String ? okText}) {

  AwesomeDialog(
      context: context,
      dialogType: dialogType,
      padding: const EdgeInsets.all(10),
      dialogBackgroundColor: Theme.of(context).colorScheme.background,
      title: title,
      btnCancelOnPress: onCancel,
      btnOkOnPress: onOK,
      btnCancelText: cancelText ,
      btnOkText: okText ,
      desc: description,
      body: body == null ? null : Text(body),
      autoDismiss: true,
      titleTextStyle: titleMedium(context),
      descTextStyle: bodySmall(context).copyWith(fontWeight: FontWeight.bold),
      buttonsTextStyle: bodyMedium(context).copyWith(color: Colors.white),
    ).show();

}