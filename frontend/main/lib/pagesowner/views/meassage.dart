import 'package:flutter/material.dart';
import 'package:main/apiser.dart';
import 'package:main/pagesowner/views/chat2.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  List<dynamic> conversations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchConversations();
  }

  Future<void> _fetchConversations() async {
    try {
      final data = await ApiService.getConversations();
      setState(() {
        conversations = data;
        isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Messages', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.black,
        child: isLoading 
            ? const Center(child: CircularProgressIndicator())
            : conversations.isEmpty
                ? const Center(child: Text("No conversations yet", style: TextStyle(color: Colors.white)))
                : ListView.builder(
                    itemCount: conversations.length,
                    itemBuilder: (context, index) {
                      final conv = conversations[index];
                      // Assuming API response structure:
                      // { "id": 1, "other_user": { "first_name": "...", ... }, "last_message": { "content": "..." } }
                      
                      final otherUser = conv['other_user'] ?? {};
                      final lastMessage = conv['last_message'];
                      
                      final String name = "${otherUser['first_name'] ?? 'Unknown'} ${otherUser['last_name'] ?? ''}".trim();
                      final String messageText = lastMessage != null ? (lastMessage['content'] ?? '') : "No messages";
                      final String conversationId = conv['id'].toString();

                      return _buildChatItem(context, name, messageText, () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Chat2(
                              conversationId: conversationId,
                              otherUserName: name,
                            ),
                          ),
                        ).then((_) => _fetchConversations()); // Refresh on return
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
          ),
          const Divider(color: Colors.grey, thickness: 0.5, indent: 70),
        ],
      ),
    );
  }
}
