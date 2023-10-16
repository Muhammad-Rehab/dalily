import 'package:dalily/core/helper/image_helper.dart';
import 'package:dalily/core/util/styles.dart';
import 'package:dalily/features/language/presentation/cubit/language_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageRecord extends StatefulWidget {
   const LanguageRecord({Key? key}) : super(key: key);

  @override
  State<LanguageRecord> createState() => _LanguageRecordState();
}

class _LanguageRecordState extends State<LanguageRecord> {
  List<Map<String,dynamic>> items = [];

  String currentValue = '';

  @override
  Widget build(BuildContext context) {
    items = [
      {
        "name": AppLocalizations.of(context)!.arabic_lang,
        "flag": ImageHelper.arabicImage,
      },
      {
        "name": AppLocalizations.of(context)!.english_lang,
        "flag": ImageHelper.englishImage,
      },
    ];
    currentValue = BlocProvider.of<LanguageCubit>(context).isArabic ? AppLocalizations.of(context)!.arabic_lang
        : AppLocalizations.of(context)!.english_lang ;
    return Container(
      padding: const EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(AppLocalizations.of(context)!.change_language,
          style:  bodyMedium(context).copyWith(fontWeight: FontWeight.bold),
          ),
          DropdownButton(
            dropdownColor: Theme.of(context).colorScheme.background,
            iconEnabledColor: Theme.of(context).colorScheme.secondary,
            items: items.map((item) =>  DropdownMenuItem(
              value: item['name'],
              child: Row(
              children: [
                Text(item['name'],style: bodyVerSmall(context),),
                const SizedBox(width: 5,),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: 15,
                  height: 15,
                  child: Image.asset(item['flag'],fit: BoxFit.fill,),
                )
              ],
            ),),).toList(),
              value: currentValue,
              onChanged: (val){
              context.read<LanguageCubit>().toggleLanguage();
              setState(() {
                currentValue = BlocProvider.of<LanguageCubit>(context).isArabic ? AppLocalizations.of(context)!.arabic_lang
                    : AppLocalizations.of(context)!.english_lang ;
              });
              },
          ),
        ],
      ),
    );
  }
}
