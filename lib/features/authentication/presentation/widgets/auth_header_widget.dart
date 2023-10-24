import 'package:dalily/core/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthHeaderWidget extends StatelessWidget {
  final String pageTitle ;
  bool isTitleExist ;
   AuthHeaderWidget({Key? key,required this.pageTitle,this.isTitleExist = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
        if(isTitleExist)
          Text(
          "-------  $pageTitle   -------",
          style: titleSmall(context),
        ),
        if(isTitleExist)
          const SizedBox(
          height: 50,
        ),
      ],
    );
  }
}
