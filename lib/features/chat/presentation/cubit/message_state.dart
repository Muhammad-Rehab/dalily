

import 'package:dalily/features/chat/data/model/message_model.dart';
import 'package:equatable/equatable.dart';

abstract class MessageState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialMessageState extends MessageState {}
class ErrorMessageState extends MessageState {
  final String ? errorMessage ;
  ErrorMessageState({this.errorMessage});
}

class LoadingMessagesState extends MessageState {}
class LoadedMessageState extends MessageState {
  final Stream<MessageModel> messages ;
  LoadedMessageState({required this.messages});
}

class SendingMessageState extends MessageState {}
class SentMessageState extends MessageState {}

class ClosingStreamState extends MessageState {}
class ClosedStreamState extends MessageState {}
