

import 'package:dalily/features/chat/data/model/message_model.dart';

abstract class MessageRemoteDataResource{

  Future<void> sendMessage(MessageModel messageModel);


}