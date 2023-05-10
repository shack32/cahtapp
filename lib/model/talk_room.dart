import 'package:chat_app/model/model.dart';

class TalkRoom {
  String roomId;
  User talkUser;
  String? lastMessage;

  TalkRoom({
    required this.roomId,
    required this.talkUser,
    this.lastMessage,
  });
}
