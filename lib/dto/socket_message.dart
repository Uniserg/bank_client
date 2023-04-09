import 'package:json_annotation/json_annotation.dart';

part 'socket_message.g.dart';

enum Scope {
  NOTIFICATION,
  MESSAGE,
  CHAT_SESSIONS
}

@JsonSerializable(fieldRename: FieldRename.snake)
class SocketMessage {
  final Scope scope;
  final Map<String, dynamic> body;


  SocketMessage({
    required this.scope,
    required this.body
  });

  factory SocketMessage.fromJson(Map<String, dynamic> json) => _$SocketMessageFromJson(json);
}
