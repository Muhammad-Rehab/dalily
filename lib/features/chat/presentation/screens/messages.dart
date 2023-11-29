import 'package:dalily/features/authentication/data/model/service_owner_model.dart';
import 'package:dalily/features/chat/presentation/cubit/message_cubit.dart';
import 'package:dalily/features/temporary_user/data/model/temp_user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessagesScreen extends StatefulWidget {
  final TempUserModel tempUserModel ;
  final ServiceOwnerModel serviceOwnerModel ;
  const MessagesScreen({Key? key,required this.serviceOwnerModel,required this.tempUserModel}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {

  loadMessages(){
    BlocProvider.of<MessageCubit>(context)
        .getMessages(serviceOwnerId: widget.serviceOwnerModel.id, tempUserId: widget.tempUserModel.id);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
