import 'package:flutter/material.dart';
import 'package:main/chatcons.dart';
import 'package:main/pagesowner/views/chat2.dart';
import 'package:main/chatModel/User_model.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    User_model tempUser = User_model(
      id: "0999999999",
      name: "Owner Name",
      email: "owner@gmail.com",
      pass: "123",
      image: "assets/images/person.png",
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Chat, owner', style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        color: Colors.black,
        child: ListView(
          children: [
            _buildChatItem(context, "nader", () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Chat2(currentUser: tempUser),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildChatItem(BuildContext context, String name, VoidCallback onTap) {
    var lastMsg = Chat.isNotEmpty ? Chat.last : null;

    bool isMe = lastMsg != null && lastMsg.sender_name == "chat2";

    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          ListTile(
            leading: const CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.black),
            ),
            title: Text(
              name,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            subtitle: Text(
              lastMsg != null
                  ? "${isMe ? 'You: ' : ''}${lastMsg.text}"
                  : "No messages yet",
              style: const TextStyle(color: Colors.grey, fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(
              lastMsg != null
                  ? "${lastMsg.time.hour}:${lastMsg.time.minute.toString().padLeft(2, '0')}"
                  : "",
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          const Divider(color: Colors.grey, thickness: 0.5, indent: 70),
        ],
      ),
    );
  }
}
