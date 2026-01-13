import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:main/apiser.dart';
import 'package:intl/intl.dart';

class caht_1 extends StatefulWidget {
  final int conversationId;
  final String otherUserName;
  final int currentUserId;

  const caht_1({
    super.key, 
    required this.conversationId,
    required this.otherUserName,
    required this.currentUserId,
  });

  @override
  State<caht_1> createState() => _Caht_1State();
}

class _Caht_1State extends State<caht_1> {
  TextEditingController textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<dynamic> messages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    try {
      final data = await ApiService.getMessages(widget.conversationId.toString());
      setState(() {
        messages = data;
        isLoading = false;
      });
      Future.delayed(const Duration(milliseconds: 100), () => _scrollToBottom());
    } catch (e) {
      print("Error fetching messages: $e");
      setState(() => isLoading = false);
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage(String messageText) async {
    if (messageText.trim().isEmpty) return;
    
    try {
      await ApiService.sendMessage(widget.conversationId.toString(), messageText);
      textController.clear();
      _fetchMessages();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to send: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Text(
                widget.otherUserName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: messages.length,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      itemBuilder: (_, index) {
                        final msg = messages[index];
                        bool isMe = msg['sender_id'] == widget.currentUserId;
                        DateTime? msgTime;
                        try {
                          msgTime = DateTime.parse(msg['created_at']);
                        } catch (_) {}

                        return Column(
                          crossAxisAlignment: isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            BubbleSpecialThree(
                              isSender: isMe,
                              text: msg['message']?.toString() ?? '',
                              color: isMe
                                  ? const Color(0xFF056EC5)
                                  : const Color(0xFFE8E8EE),
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
                                bottom: 5,
                              ),
                              child: Text(
                                msgTime != null ? DateFormat('hh:mm a').format(msgTime) : '',
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
          ),
          _inputSection(),
        ],
      ),
    );
  }

  Widget _inputSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: "Write a message...",
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                _sendMessage(textController.text);
              }
            },
            icon: const Icon(Icons.send, color: Color(0xFF056EC5)),
          ),
        ],
      ),
    );
  }
}
