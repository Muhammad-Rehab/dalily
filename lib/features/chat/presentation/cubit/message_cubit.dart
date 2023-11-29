import 'dart:async';

import 'package:dalily/core/error/failure.dart';
import 'package:dalily/features/chat/data/model/message_model.dart';
import 'package:dalily/features/chat/domain/usecases/get_messages_use_case.dart';
import 'package:dalily/features/chat/domain/usecases/send_message_use_case.dart';
import 'package:dalily/features/chat/presentation/cubit/message_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageCubit extends Cubit<MessageState> {
  SendMessageUseCase sendMessageUseCase;

  GetMessagesUseCases getMessagesUseCases;
  StreamController<MessageModel> ? chatMessages ;

  MessageCubit({
    required this.getMessagesUseCases,
    required this.sendMessageUseCase,
  }) : super(InitialMessageState());

  Future<void> sendMessage(MessageModel messageModel) async {
    emit(SendingMessageState());
    final response = await sendMessageUseCase.call(messageModel);
    emit(response.fold((l) => ErrorMessageState(), (r) => SentMessageState()));
  }

  getMessages ({required String serviceOwnerId,required String tempUserId}){
    emit(LoadingMessagesState());
    final Either<Failure, StreamController<MessageModel>> response = getMessagesUseCases.call([serviceOwnerId,tempUserId]);
    emit(response.fold((l) => ErrorMessageState(), (messages){
      chatMessages = messages;
      return LoadedMessageState(messages: messages.stream);
    }));
  }

  closeChatStream () async {
    emit(ClosingStreamState());
    if(chatMessages != null){
      await chatMessages!.close();
    }
    emit(ClosedStreamState());
  }
}
