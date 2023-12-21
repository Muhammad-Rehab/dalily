import 'package:dalily/core/util/styles.dart';
import 'package:dalily/features/rating/data/model/rate_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RatingDetails extends StatelessWidget {
  final RateModel rateModel;

  const RatingDetails({Key? key, required this.rateModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 150,
          height: 30,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              if (index < rateModel.averageRating && index != rateModel.averageRating.floor()) {
                return Icon(
                  Icons.star,
                  size: 30,
                  color: Theme.of(context).colorScheme.secondary,
                );
              } else if (index < rateModel.averageRating && index == rateModel.averageRating.floor()) {
                return Icon(
                  Icons.star_half,
                  size: 30,
                  color: Theme.of(context).colorScheme.secondary,
                );
              } else {
                return Icon(
                  Icons.star,
                  size: 30,
                  color: Theme.of(context).colorScheme.secondary.withOpacity(.3),
                );
              }
            },
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        RichText(
          text: TextSpan(style: titleSmall(context), children: [
            TextSpan(text: AppLocalizations.of(context)!.total),
            TextSpan(
                text: "   ${rateModel.totalRateNumber.toString()}   ",
                style: titleSmall(context).copyWith(color: Theme.of(context).colorScheme.primary)),
            TextSpan(text: AppLocalizations.of(context)!.rating),
          ]),
        ),
      ],
    );
  }
}
