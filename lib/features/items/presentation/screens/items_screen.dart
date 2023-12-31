import 'dart:io';

import 'package:dalily/core/helper/dialog.dart';
import 'package:dalily/core/helper/image_helper.dart';
import 'package:dalily/core/helper/list_sorting.dart';
import 'package:dalily/core/screens/images_view.dart';
import 'package:dalily/core/screens/shimmer.dart';
import 'package:dalily/core/util/styles.dart';
import 'package:dalily/features/authentication/data/model/service_owner_model.dart';
import 'package:dalily/features/categories/presentation/cubit/category_cubit.dart';
import 'package:dalily/features/items/presentation/cubit/item_cubit.dart';
import 'package:dalily/features/items/presentation/cubit/item_states.dart';
import 'package:dalily/features/items/presentation/screens/item_detail_screen.dart';
import 'package:dalily/features/language/presentation/cubit/language_cubit.dart';
import 'package:dalily/features/rating/presentation/widget/rating_bar.dart';
import 'package:dalily/features/theme/presentation/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemsScreen extends StatelessWidget {
  ItemsScreen({Key? key}) : super(key: key);

  late final String catId;
  Map<String, dynamic> catLocalImages = {};

  String? getCatLocalImage(String catId) {
    if (catLocalImages.containsKey('${catId}img')) {
      return catLocalImages['${catId}img'];
    } else {
      return null;
    }
  }

  getItemModel(BuildContext context) {
    BlocProvider.of<ItemCubit>(context).getItem(catId, context);
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      catId = ModalRoute.of(context)!.settings.arguments as String;
      getItemModel(context);
    }
    catLocalImages = BlocProvider.of<CategoryCubit>(context).catLocalImages;
    return Scaffold(
      body: BlocConsumer<ItemCubit, ItemState>(
        listener: (context, state) {
          if (state is ItemErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: bodySmall(context).copyWith(fontWeight: FontWeight.bold),
                ),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ItemIsLoadingState) {
            return const AppShimmer();
          } else if (state is ItemLoadedState) {
            List<ServiceOwnerModel> items = state.itemModel.itemServiceOwners;
            items = ListSortingHelper.sortServiceOwners(items);
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
              ),
              body: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 75,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(50),
                            bottomLeft: Radius.circular(50),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          width: 150,
                          height: 150,
                          margin: const EdgeInsets.only(top: 0),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.secondary.withOpacity(.3),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                PageTransition(
                                  type: PageTransitionType.size,
                                  alignment: Alignment.center,
                                  child: ImagesView(images: [state.itemModel.catImage]),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(75),
                              child: Builder(builder: (context) {
                                String? imagePath = getCatLocalImage(catId);
                                return imagePath != null
                                    ? Image.file(
                                        File(imagePath),
                                        fit: BoxFit.fill,
                                      )
                                    : FadeInImage(
                                        placeholder: const AssetImage(ImageHelper.placeholderImage),
                                        image: NetworkImage(
                                          state.itemModel.catImage,
                                        ),
                                        fit: BoxFit.fill,
                                      );
                              }),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ItemDetailsScreen(
                                      itemModel: state.itemModel,
                                      serviceOwnerModel: items[index],
                                    ),
                                  ),
                                );
                              },
                              leading: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: items[index].personalImage == null
                                      ? Image.asset(
                                          ImageHelper.avatarImage,
                                          fit: BoxFit.fill,
                                        )
                                      : Image.network(
                                          items[index].personalImage!,
                                          fit: BoxFit.fill,
                                        ),
                                ),
                              ),
                              title: Text(
                                items[index].serviceName != null && items[index].serviceName!.isNotEmpty
                                    ? items[index].serviceName!
                                    : items[index].name.length < 25
                                        ? items[index].name
                                        : BlocProvider.of<LanguageCubit>(context).isArabic
                                            ? "${items[index].name.substring(0, 22)}..."
                                            : "...${items[index].name.substring(0, 22)}",
                                style: titleSmall(context),
                              ),
                              subtitle: Text(
                                items[index].phoneNumber,
                                style: bodySmall(context).copyWith(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold),
                              ),
                              trailing: SizedBox(
                                width: 100,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                              backgroundColor: Theme.of(context).colorScheme.background,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                              content: AppRatingBar(
                                                itemModel: state.itemModel,
                                                serviceOwnerModel: items[index],
                                              ),
                                            ));
                                       /* showCustomDialog(
                                          context: context,
                                          title: AppLocalizations.of(context)!.attention_please,
                                          description: AppLocalizations.of(context)!.chat_coming_soon,
                                          onOK: () {},
                                          okText: AppLocalizations.of(context)!.ok,
                                        );*/
                                      },
                                      child: Icon(
                                        Icons.stars,
                                        color: Theme.of(context).colorScheme.secondary,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        await launchUrl(
                                          Uri.parse('tel:${items[index].phoneNumber}'),
                                          mode: LaunchMode.externalNonBrowserApplication,
                                        );
                                      },
                                      child: Icon(
                                        Icons.call,
                                        color: Theme.of(context).colorScheme.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else if (state is ItemErrorState) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color:
                        BlocProvider.of<ThemeCubit>(context).isDark ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 150,
                      width: 150,
                      child: Image.asset(
                        ImageHelper.badConnection,
                        fit: BoxFit.fill,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        state.message,
                        style: titleSmall(context),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
