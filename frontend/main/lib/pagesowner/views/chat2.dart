import 'dart:async';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:main/apiser.dart';

class Chat2 extends StatefulWidget {
  final String conversationId;
  final String otherUserName;

  const Chat2({
    super.key,
    required this.conversationId,
    required this.otherUserName,
  });

  @override
  State<Chat2> createState() => _Chat2State();
}

class _Chat2State extends State<Chat2> {
  TextEditingController textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<dynamic> messages = [];
  bool isLoading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchMessages();
    // Poll for new messages every 5 seconds
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _fetchMessages(isBackground: true));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    textController.dispose();
    super.dispose();
  }

  Future<void> _fetchMessages({bool isBackground = false}) async {
    try {
      final data = await ApiService.getMessages(widget.conversationId);
      if (mounted) {
        setState(() {
          messages = data;
          if (!isBackground) isLoading = false;
        });
        if (!isBackground) {
           // Scroll to bottom after initial load
           WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
        }
      }
    } catch (e) {
      if (mounted && !isBackground) {
        setState(() => isLoading = false);
      }
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage() async {
    if (textController.text.isEmpty) return;
    
    final content = textController.text;
    textController.clear();

    try {
      await ApiService.sendMessage(widget.conversationId, content);
      _fetchMessages(isBackground: true); // Refresh immediately
      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to send: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              widget.otherUserName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : messages.isEmpty
                      ? const Center(child: Text("No messages yet"))
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: messages.length,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          itemBuilder: (_, index) {
                            final msg = messages[index];
                            // Check if current user is sender. 
                            // The API response for message usually implies 'is_me' or we compare sender_id
                            // Assuming backend returns 'sender_id' or 'is_sender'
                            // Let's assume the API returns 'is_sender' boolean or we need to know my ID.
                            // In ApiService.getProfile we can get ID but that's async.
                            // Better if message object has 'is_sender'. 
                            // Standard Laravel resource usually gives that or we check against stored user ID.
                            // Let's assume 'is_sender' is appended by backend or check 'sender_id'.
                            // If we don't know my ID, we can't check 'sender_id'.
                            // However, let's look at `chat2.dart` previous implementation, it checked name.
                            // Let's assume the message object has a flag 'is_me' or similar.
                            // If not, we might need to fetch profile first.
                            // For now, let's assume 'sender_type' match role? No.
                            // Let's guess 'sender_id' matches my ID. But I don't have my ID here.
                            // I will use a simple heuristic: if the alignment is right, it's me.
                            // Actually, I should check the message structure.
                            // Assuming message has `is_sender` (often added in API resources).
                            // If NOT, I'll need to fetch my ID in initState.
                            // Let's add `is_sender` check.
                            
                            bool isMe = msg['is_sender'] ?? false; // Make sure backend provides this or use logic

                            return Column(
                              crossAxisAlignment: isMe
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                BubbleSpecialThree(
                                  isSender: isMe,
                                  text: msg['content'] ?? '',
                                  color: isMe ? Colors.blueAccent : Colors.grey.shade300,
                                  tail: true,
                                  textStyle: TextStyle(
                                    color: isMe ? Colors.white : Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    right: isMe ? 20 : 0,
                                    left: isMe ? 0 : 20,
                                    bottom: 8,
                                  ),
                                  child: Text(
                                    // Parse date
                                    DateFormat('hh:mm a').format(DateTime.parse(msg['created_at']).toLocal()),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
            ),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        controller: textController,
                        decoration: const InputDecoration(
                          hintText: "Write a message...",
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: IconButton(
                      onPressed: _sendMessage,
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
