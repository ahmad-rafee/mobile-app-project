import 'package:main/chatModel/User_model.dart';

class ChatModel {
  String id;
  List<User_model> users = [];
  List users_id = [];
  List chat = [];

  ChatModel({
    required this.id,
    required this.users,
    required this.chat,
    required this.users_id,
  });

  ChatModel.fromJson(Map<String, dynamic> map)
    : this(
        id: map['id'] ?? '',
        users: (map['users'] as List? ?? [])
            .map((e) => User_model.from_json(e))
            .toList(),
        chat: map['chat'] ?? [],
        users_id: map['users_id'] ?? [],
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'users': users.map((e) => e.to_json()).toList(),
      'chat': chat,
      'users_id': users_id,
    };
  }
}
