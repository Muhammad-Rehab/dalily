import 'package:dalily/core/helper/image_helper.dart';
import 'package:dalily/core/screens/images_view.dart';
import 'package:dalily/core/util/styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:dalily/features/temporary_user/presentation/cubit/temp_user_cubit.dart';
import 'package:dalily/features/temporary_user/presentation/cubit/temp_user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

class TempUserProfileScreen extends StatelessWidget {

  const TempUserProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        elevation: 0,
      ),
      body: BlocBuilder<TempUserCubit,TempUserState>(
        builder: (context,state) {
          if(state is LoadedTempUserState){
            return Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 80),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      )),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
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
                            if (state.tempUserModel.image != null) {
                              Navigator.of(context).push(
                                PageTransition(
                                  type: PageTransitionType.size,
                                  alignment: Alignment.center,
                                  child: ImagesView(images: [state.tempUserModel.image!]),
                                ),
                              );
                            }
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(75),
                            child: state.tempUserModel.image != null
                                ? FadeInImage(
                              placeholder: const AssetImage(
                                ImageHelper.avatarImage,
                              ),
                              image: NetworkImage(
                                state.tempUserModel.image!,
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
                        state.tempUserModel.name,
                        style: titleLarge(context),
                      ),
                      const SizedBox(
                        height: 50,
                      ),


                      // phone numbers
                      Divider(
                        thickness: 2,
                        color: Theme.of(context).colorScheme.secondary,
                        endIndent: 50,
                        indent: 50,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 30, right: 30),
                        child: ListTile(
                          leading:  Icon(Icons.phone,color: Theme.of(context).colorScheme.primary,),
                          title: Text(
                            state.tempUserModel.phoneNumber,
                            style: bodyMedium(context).copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return  Center(
            child: Text(
              AppLocalizations.of(context)!.user_not_exist,
              style: titleSmall(context),
            ),
          );
        }
      ),
    );
  }
}
