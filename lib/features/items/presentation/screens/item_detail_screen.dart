import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dalily/core/helper/admin_helper.dart';
import 'package:dalily/core/helper/dialog.dart';
import 'package:dalily/core/helper/image_helper.dart';
import 'package:dalily/core/screens/images_view.dart';
import 'package:dalily/core/util/styles.dart';
import 'package:dalily/features/authentication/data/model/service_owner_model.dart';
import 'package:dalily/features/items/data/model/ItemModel.dart';
import 'package:dalily/features/language/presentation/cubit/language_cubit.dart';
import 'package:dalily/features/rating/presentation/widget/rating_bar.dart';
import 'package:dalily/features/rating/presentation/widget/rating_details.dart';
import 'package:dalily/features/service_owners/prensentation/cubit/service_owner_state_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemDetailsScreen extends StatelessWidget {
  final ServiceOwnerModel serviceOwnerModel;
  final ItemModel itemModel;

  ItemDetailsScreen({Key? key, required this.serviceOwnerModel, required this.itemModel}) : super(key: key);

  _makePhoneCall({required String phoneNumber}) async {
    await launchUrl(
      Uri.parse('tel:$phoneNumber'),
      mode: LaunchMode.externalNonBrowserApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        elevation: 0,
        actions: [
          InkWell(
            onTap: (){
              showDialog(context: context, builder: (_)=> AlertDialog(
                backgroundColor: Theme.of(context).colorScheme.background,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                content: RatingDetails(rateModel: serviceOwnerModel.rateModel,),
              ));
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   Padding(
                    padding:  EdgeInsets.only(bottom: BlocProvider.of<LanguageCubit>(context).isArabic ? 8.0 : 0),
                    child:  const Icon(Icons.star,size: 20,),
                  ),
                  const SizedBox(width: 5,),
                  Text(serviceOwnerModel.rateModel.averageRating.toString(),
                    style: bodySmall(context).copyWith(fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (AdminController.isAdmin)
            IconButton(
              onPressed: () {
                showCustomDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    description: 'Do You want to delete this service owner',
                    onOK: () {
                      BlocProvider.of<ServiceOwnerStateCubit>(context).deleteServiceOwner(
                        serviceOwnerId: serviceOwnerModel.id,
                        parentCatId: serviceOwnerModel.categoryIds.last,
                      );
                    },
                    onCancel: () {});
              },
              icon: const Icon(
                Icons.delete,
              ),
            ),

        ],
        title: serviceOwnerModel.serviceName == null
            ? null
            : Text(
                serviceOwnerModel.name,
                style: titleSmall(context).copyWith(color: Theme.of(context).colorScheme.surface),
              ),
      ),
      floatingActionButton: Builder(builder: (context) {
        return FloatingActionButton.extended(
          label: Text(
            AppLocalizations.of(context)!.add_rate,
            style: bodySmall(context).copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          onPressed: () {
            showDialog(
                context: context,
                builder: (_) => AlertDialog(
                      backgroundColor: Theme.of(context).colorScheme.background,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      content: AppRatingBar(
                        itemModel: itemModel,
                        serviceOwnerModel: serviceOwnerModel,
                      ),
                    ));
          },
          // child: Icon(Icons.star),
        );
      }),
      body: SingleChildScrollView(
        physics: (serviceOwnerModel.workImages == null || serviceOwnerModel.workImages!.isEmpty)
            ? const NeverScrollableScrollPhysics()
            : const ScrollPhysics(),
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: serviceOwnerModel.serviceName == null ? 80 : 100),
              height: 850,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  )),
            ),
            Container(
              margin: EdgeInsets.only(top: serviceOwnerModel.serviceName == null ? 10 : 30),
              alignment: Alignment.center,
              child: Column(
                children: [
                  // image
                  Container(
                    padding: const EdgeInsets.all(15),
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      shape: BoxShape.circle,
                    ),
                    child: InkWell(
                      onTap: () {
                        if (serviceOwnerModel.personalImage != null) {
                          Navigator.of(context).push(
                            PageTransition(
                              type: PageTransitionType.size,
                              alignment: Alignment.center,
                              child: ImagesView(images: [serviceOwnerModel.personalImage!]),
                            ),
                          );
                        }
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(75),
                        child: serviceOwnerModel.personalImage != null
                            ? FadeInImage(
                                placeholder: const AssetImage(
                                  ImageHelper.avatarImage,
                                ),
                                image: NetworkImage(
                                  serviceOwnerModel.personalImage!,
                                ),
                                fit: BoxFit.fill,
                              )
                            : Image.asset(
                                ImageHelper.avatarImage,
                                fit: BoxFit.fill,
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // name
                  Text(
                    serviceOwnerModel.serviceName != null && serviceOwnerModel.serviceName!.isNotEmpty
                        ? serviceOwnerModel.serviceName!
                        : serviceOwnerModel.name,
                    style: titleLarge(context),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  //description
                  if (serviceOwnerModel.serviceDescription != null)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        serviceOwnerModel.serviceDescription!,
                        style: bodySmall(context).copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  //address
                  if (serviceOwnerModel.address != null)
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: Text(
                              serviceOwnerModel.address!,
                              style: bodyMedium(context).copyWith(fontWeight: FontWeight.bold),
                            ),
                            leading: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.location_on,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                          Divider(
                            color: Theme.of(context).colorScheme.secondary,
                            indent: 20,
                            endIndent: 20,
                          )
                        ],
                      ),
                    ),

                  // phone numbers
                  Container(
                    margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                    height: ((serviceOwnerModel.secondPhoneNumber == null || serviceOwnerModel.secondPhoneNumber!.isEmpty) &&
                            (serviceOwnerModel.thirdPhoneNumber == null || serviceOwnerModel.thirdPhoneNumber!.isEmpty))
                        ? null
                        : 110,
                    child: ((serviceOwnerModel.secondPhoneNumber == null || serviceOwnerModel.secondPhoneNumber!.isEmpty) &&
                            (serviceOwnerModel.thirdPhoneNumber == null || serviceOwnerModel.thirdPhoneNumber!.isEmpty))
                        ? ListTile(
                            title: Text(
                              serviceOwnerModel.phoneNumber,
                              style: bodySmall(context).copyWith(fontWeight: FontWeight.bold),
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                _makePhoneCall(phoneNumber: serviceOwnerModel.phoneNumber);
                              },
                              icon: Icon(
                                Icons.call,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          )
                        : ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 15),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Theme.of(context).colorScheme.secondary,
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(0, 2),
                                        blurRadius: 5,
                                      ),
                                    ]),
                                child: Column(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        _makePhoneCall(phoneNumber: serviceOwnerModel.phoneNumber);
                                      },
                                      icon: const Icon(
                                        Icons.call,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      serviceOwnerModel.phoneNumber,
                                      style: bodyVerSmall(context).copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              if (serviceOwnerModel.secondPhoneNumber != null && serviceOwnerModel.secondPhoneNumber!.isNotEmpty)
                                Container(
                                  width: 2,
                                  height: 100,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                              if (serviceOwnerModel.secondPhoneNumber != null && serviceOwnerModel.secondPhoneNumber!.isNotEmpty)
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 15),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Theme.of(context).colorScheme.secondary,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.grey,
                                          offset: Offset(0, 2),
                                          blurRadius: 5,
                                        ),
                                      ]),
                                  child: Column(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          _makePhoneCall(phoneNumber: serviceOwnerModel.secondPhoneNumber!);
                                        },
                                        icon: const Icon(
                                          Icons.call,
                                          color: Colors.white,
                                          size: 40,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        serviceOwnerModel.secondPhoneNumber!,
                                        style: bodyVerSmall(context).copyWith(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              if (serviceOwnerModel.thirdPhoneNumber != null && serviceOwnerModel.thirdPhoneNumber!.isNotEmpty)
                                Container(
                                  width: 2,
                                  height: 100,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                              if (serviceOwnerModel.thirdPhoneNumber != null && serviceOwnerModel.thirdPhoneNumber!.isNotEmpty)
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 15),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Theme.of(context).colorScheme.secondary,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.grey,
                                          offset: Offset(0, 2),
                                          blurRadius: 5,
                                        ),
                                      ]),
                                  child: Column(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          _makePhoneCall(phoneNumber: serviceOwnerModel.thirdPhoneNumber!);
                                        },
                                        icon: const Icon(
                                          Icons.call,
                                          color: Colors.white,
                                          size: 40,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        serviceOwnerModel.thirdPhoneNumber!,
                                        style: bodyVerSmall(context).copyWith(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                  ),

                  // work images
                  if (serviceOwnerModel.workImages != null && serviceOwnerModel.workImages!.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                      height: 410,
                      alignment: BlocProvider.of<LanguageCubit>(context).isArabic ? Alignment.bottomRight : Alignment.bottomLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.previous_work,
                            style: titleMedium(context).copyWith(color: Theme.of(context).colorScheme.primary),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: GridView.builder(
                              scrollDirection: Axis.vertical,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, mainAxisExtent: 180, mainAxisSpacing: 10, crossAxisSpacing: 10),
                              itemCount: (serviceOwnerModel.workImages == null) ? 0 : serviceOwnerModel.workImages!.length,
                              itemBuilder: (context, index) => InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    PageTransition(
                                      type: PageTransitionType.size,
                                      alignment: Alignment.center,
                                      child: ImagesView(images: serviceOwnerModel.workImages!),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      serviceOwnerModel.workImages![index],
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
