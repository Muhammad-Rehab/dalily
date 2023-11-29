

import 'dart:async';

import 'package:dalily/core/error/failure.dart';
import 'package:dalily/features/chat/data/model/message_model.dart';
import 'package:dalily/features/chat/domain/repository/message_repo.dart';
import 'package:dartz/dartz.dart';

class GetMessagesUseCases {
  MessageRepository messageRepository ;
  GetMessagesUseCases({required this.messageRepository});


  Either<Failure, StreamController<MessageModel>> call(List param) => messageRepository.getMessages(param[0], param[1]);


}