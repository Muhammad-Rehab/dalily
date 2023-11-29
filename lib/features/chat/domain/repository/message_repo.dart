

import 'dart:async';

import 'package:dalily/core/error/failure.dart';
import 'package:dalily/features/chat/data/model/message_model.dart';
import 'package:dartz/dartz.dart';

abstract class MessageRepository {
  Future<Either<ServerFailure,void>> sendMessage(MessageModel messageModel);
  Either<ServerFailure,StreamController<MessageModel>> getMessages(String serviceOwnerId,String userId);
}