
import 'package:equatable/equatable.dart';

class Message extends Equatable {

  final String messageId ;
  final String serviceOwnerId ;
  final String userId ;
  final bool isImage ;
  final String time ;
  String message ;


  Message({
    required this.messageId,
    required this.serviceOwnerId,
    required this.userId,
    required this.isImage,
    required this.message,
    required this.time
});

  @override
  List<Object?> get props => [messageId];

}