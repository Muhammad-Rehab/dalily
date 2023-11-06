
import 'package:equatable/equatable.dart';

class Message extends Equatable {

  final String messageId ;
  final String serviceOwnerId ;
  final String userId ;
  final bool isImage ;
  final String message ;
  final String ? userImagePath ;
  final String ? serverImagePath ;

  const Message({
    required this.messageId,
    required this.serviceOwnerId,
    required this.userId,
    required this.isImage,
    required this.message,
    this.serverImagePath,
    this.userImagePath
});

  @override
  List<Object?> get props => [messageId];

}