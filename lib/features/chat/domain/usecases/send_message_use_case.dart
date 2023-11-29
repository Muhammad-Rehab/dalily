

import 'package:dalily/core/error/failure.dart';
import 'package:dalily/core/usecase/usecase.dart';
import 'package:dalily/features/chat/data/model/message_model.dart';
import 'package:dalily/features/chat/domain/repository/message_repo.dart';
import 'package:dartz/dartz.dart';

class SendMessageUseCase extends UseCase<void,MessageModel>{
  MessageRepository messageRepository ;
  SendMessageUseCase({required this.messageRepository});

  @override
  Future<Either<Failure, void>> call(MessageModel param) => messageRepository.sendMessage(param);


}