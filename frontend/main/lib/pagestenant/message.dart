import 'package:flutter/material.dart';
import 'package:main/apiser.dart';
import 'package:main/pagestenant/chat1.dart';
import 'package:main/database.dart';

class Message extends StatefulWidget {
  const Message({super.key});

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  List<dynamic> conversations = [];
  bool isLoading = true;
  int? currentUserId;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    fetchConversations();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final profile = await ApiService.getProfile();
      if (profile['user'] != null) {
        setState(() {
          currentUserId = profile['user']['id'];
        });
      }
    } catch (e) {
      print("Error loading user: $e");
    }
  }

  Future<void> fetchConversations() async {
    try {
      final data = await ApiService.getConversations();
      setState(() {
        conversations = data;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching conversations: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Messages',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: isLoading 
         ? const Center(child: CircularProgressIndicator())
         : conversations.isEmpty
            ? const Center(child: Text("No messages yet", style: TextStyle(color: Colors.white)))
            : ListView.builder(
                itemCount: conversations.length,
                itemBuilder: (context, index) {
                  final conv = conversations[index];
                  final otherUser = conv['other_user'] ?? {}; 
                  final lastMessage = conv['last_message'];
                  String name = "${otherUser['first_name'] ?? ''} ${otherUser['last_name'] ?? ''}".trim();
                  if (name.isEmpty) name = "User";
                  String lastMsgText = lastMessage != null ? (lastMessage['message'] ?? "No messages") : "No messages";
                  
                  return _buildChatItem(context, name, lastMsgText, () {
                    if (currentUserId != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => caht_1(
                            conversationId: conv['id'],
                            otherUserName: name,
                            currentUserId: currentUserId!,
                          ),
                        ),
                      );
                    }
                  });
                },
              ),
      ),
    );
  }

  Widget _buildChatItem(BuildContext context, String name, String lastMsg, VoidCallback onTap) {
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
              lastMsg,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            // trailing: Text(time), // Add time if available
          ),
          const Divider(color: Colors.grey, thickness: 0.5, indent: 70),
        ],
      ),
    );
  }
}
