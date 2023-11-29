import 'dart:async';

import 'package:dalily/core/error/failure.dart';
import 'package:dalily/features/chat/data/data_resource/remote_data_resource.dart';
import 'package:dalily/features/chat/data/model/message_model.dart';
import 'package:dalily/features/chat/domain/repository/message_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

class TempUserRepoImp extends MessageRepository {
  MessageRemoteDataResource messageRemoteDataResource;

  TempUserRepoImp({required this.messageRemoteDataResource});

  @override
  Either<ServerFailure, StreamController<MessageModel>> getMessages(String serviceOwnerId, String userId) {
    try {
      StreamController<MessageModel> messages = messageRemoteDataResource.getMessages(serviceOwnerId, userId);
      return Right(messages);
    } catch (e) {
      debugPrint('temp user repo imp / getMessages()');
      debugPrint(e.toString());
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<ServerFailure, void>> sendMessage(MessageModel messageModel) async {
    try {
      return Right(messageRemoteDataResource.sendMessage(messageModel));
    } catch (e) {
      debugPrint('temp user repo imp / sendMessage()');
      debugPrint(e.toString());
      return const Left(ServerFailure());
    }
  }
}
