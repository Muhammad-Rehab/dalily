import 'package:dalily/config/routes.dart';
import 'package:dalily/core/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoryDrawerButton extends StatelessWidget {
  const CategoryDrawerButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(
          context,
          AppRoutes.categoryDetails,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: Text(
          AppLocalizations.of(context)!.add_category,
          style: bodyMedium(context).copyWith(fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.surface
          ),
        ),
      ),
    );
  }
}