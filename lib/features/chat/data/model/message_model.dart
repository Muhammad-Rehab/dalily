import 'package:dalily/features/chat/domain/entity/message.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.messageId,
    required super.serviceOwnerId,
    required super.userId,
    required super.isImage,
    required super.message,
    super.userImagePath,
    super.serverImagePath,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      messageId: json['message_id'],
      serviceOwnerId: json['service_owner_id'],
      userId: json['user_id'],
      isImage: json['is_image'],
      message: json['message'],
      userImagePath: json['user_image_path'],
      serverImagePath: json['server_image_path'],
    );
  }

  Map<String,dynamic> toJson(){
    return {
      'message_id': messageId,
      'service_owner_id': serviceOwnerId,
      'user_id': userId,
      'is_image': isImage,
      'message': message,
      'user_image_path': userImagePath,
      'server_image_path': serverImagePath,
    };
  }
}
