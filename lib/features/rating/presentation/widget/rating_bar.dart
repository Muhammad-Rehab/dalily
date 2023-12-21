import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dalily/core/helper/dialog.dart';
import 'package:dalily/core/util/styles.dart';
import 'package:dalily/features/authentication/data/model/service_owner_model.dart';
import 'package:dalily/features/items/data/model/ItemModel.dart';
import 'package:dalily/features/rating/presentation/cubit/rate_cubit.dart';
import 'package:dalily/features/rating/presentation/cubit/rate_state.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppRatingBar extends StatefulWidget {
  ItemModel itemModel;

  ServiceOwnerModel serviceOwnerModel;

  AppRatingBar({Key? key, required this.itemModel, required this.serviceOwnerModel}) : super(key: key);

  @override
  State<AppRatingBar> createState() => _AppRatingBarState();
}

class _AppRatingBarState extends State<AppRatingBar> {
  double ratingValue = 3;

  late String deviceId;

  bool isRatedBefore = false;

  Future<void> getDeviceId() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    deviceId = (await deviceInfoPlugin.androidInfo).id;
    setState(() {
      isRatedBefore = widget.serviceOwnerModel.rateModel.rateList.any((element) => element == deviceId);
    });
  }

  double calculateAverageRating(Map<String, dynamic> numOfRate) {
    int numOfPeople = 0;
    int ratingSum = 0;
    numOfRate.forEach((key, value) {
      ratingSum += (int.parse(key) * value).toInt();
      numOfPeople += int.parse(value.toString());
    });
    return ratingSum / numOfPeople;
  }

  addRate() async {
    widget.serviceOwnerModel.rateModel.numOfRate[ratingValue.toInt().toString()] =
        widget.serviceOwnerModel.rateModel.numOfRate[ratingValue.toInt().toString()] + 1;
    widget.serviceOwnerModel.rateModel.averageRating = calculateAverageRating(widget.serviceOwnerModel.rateModel.numOfRate);
    widget.serviceOwnerModel.rateModel.totalRateNumber += 1;
    widget.serviceOwnerModel.rateModel.rateList.add(deviceId);
    BlocProvider.of<RateCubit>(context)
        .addRate(
      rateModel: widget.serviceOwnerModel.rateModel,
      itemModel: widget.itemModel,
      serviceOwnerId: widget.serviceOwnerModel.id,
    )
        .then((value) {
      getDeviceId();
    });
  }

  @override
  void initState() {
    super.initState();
    getDeviceId();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: isRatedBefore ? 100 : 200,
      width: double.infinity,
      child: isRatedBefore
          ? Center(
              child: Text(
                AppLocalizations.of(context)!.your_rate_is_sent_before,
                style: titleSmall(context),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  AppLocalizations.of(context)!.rate_service_owner,
                  style: titleMedium(context),
                ),
                RatingBar.builder(
                  direction: Axis.horizontal,
                  minRating: 1,
                  maxRating: 5,
                  itemCount: 5,
                  initialRating: 3,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                  itemBuilder: (context, index) => Icon(
                    Icons.star,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  onRatingUpdate: (value) {
                    ratingValue = value;
                    debugPrint(ratingValue.toString());
                  },
                ),
                BlocConsumer<RateCubit, RateState>(
                  listener: (context, state) {
                    if (state is ErrorRateState) {
                      showCustomDialog(
                        context: context,
                        dialogType: DialogType.error,
                        description: AppLocalizations.of(context)!.internet_connection_error,
                        onOK: () {},
                        okText: AppLocalizations.of(context)!.ok,
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is AddingRateState) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ElevatedButton(
                      onPressed: () {
                        addRate();
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: Text(
                          AppLocalizations.of(context)!.send_rating,
                          style: titleSmall(context).copyWith(color: Theme.of(context).colorScheme.surface),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
