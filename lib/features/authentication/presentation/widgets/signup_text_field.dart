import 'package:dalily/core/util/styles.dart';
import 'package:dalily/features/language/presentation/cubit/language_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpTextField extends StatelessWidget {

  SignUpTextField({Key? key,this.keyboardType = TextInputType.name,
    required this.labelText,this.validator,this.onSaved,this.isPhoneNumber = false,this.hintText,
   this.maxLines = 1 , this.onChanged,this.initialValue
  }) : super(key: key);

  String ? initialValue ;
  bool isPhoneNumber ;
  TextInputType keyboardType ;
  String labelText ;
  String ? hintText ;
  int maxLines ;
  String ? Function(String ? value) ? validator ;
  String ? Function(String ? value) ? onChanged;
  void Function(String ? value) ? onSaved ;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50),
      // height: maxLines == 1 ? 50: null,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withOpacity(.2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        textDirection: isPhoneNumber ? TextDirection.ltr : null,
        style: bodyVerSmall(context).copyWith(fontWeight: FontWeight.bold),
        maxLines: maxLines,
        onChanged: onChanged,
        initialValue: initialValue,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
          ),
          suffixText: (isPhoneNumber && BlocProvider.of<LanguageCubit>(context).isArabic) ? ' 2+' : null,
          prefixText: (isPhoneNumber && !BlocProvider.of<LanguageCubit>(context).isArabic) ? '+2 ' : null,
          prefixStyle: bodyVerSmall(context).copyWith(fontWeight: FontWeight.bold),
          suffixStyle: bodyVerSmall(context).copyWith(fontWeight: FontWeight.bold),
          labelText: labelText,
          labelStyle: bodySmall(context).copyWith(fontWeight: FontWeight.bold),
          hintText: hintText,
          hintStyle:  bodyVerSmall(context).copyWith(fontWeight: FontWeight.bold,color: Colors.grey),
        ),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}
