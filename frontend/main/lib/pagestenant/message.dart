import 'package:flutter/material.dart';
import 'package:main/chatcons.dart';
import 'package:main/pagestenant/chat1.dart';
import 'package:main/chatModel/User_model.dart';

class Message extends StatefulWidget {
  const Message({super.key});

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  @override
  Widget build(BuildContext context) {
    // مستخدم وهمي
    User_model tempTenant = User_model(
      id: "0912345678",
      name: "Tenant Name",
      email: "tenant@gmail.com",
      pass: "123",
      image: "assets/images/tenant.png",
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Chat, tenant',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: Stack(
          children: [
            ListView(
              children: [
                _buildChatItem(context, "Property Owner", () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => caht_1(currentUser: tempTenant),
                    ),
                  );
                }),
              ],
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {},
                child: const Icon(Icons.add, color: Colors.black),
              ),
            ),
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
