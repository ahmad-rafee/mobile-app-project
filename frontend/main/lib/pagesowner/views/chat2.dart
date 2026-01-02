import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:main/chatcons.dart';
import 'package:main/modelchat.dart';
import 'package:main/chatModel/User_model.dart';
import 'package:intl/intl.dart';

class Chat2 extends StatefulWidget {
  final User_model currentUser;

  const Chat2({super.key, required this.currentUser});

  @override
  State<Chat2> createState() => _Chat2State();
}

class _Chat2State extends State<Chat2> {
  TextEditingController textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String myId = widget.currentUser.id;
    String myName = widget.currentUser.name;
    String otherUserName = myName == "nader" ? "Property Owner" : "nader";
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
              otherUserName,
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
              child: ListView.builder(
                controller: _scrollController,
                itemCount: Chat.length,
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemBuilder: (_, index) {
                  bool isMe = Chat[index].sender_name == myName;

                  return Column(
                    crossAxisAlignment: isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      BubbleSpecialThree(
                        isSender: isMe,
                        text: Chat[index].text.toString(),
                        color: isMe ? Colors.blueAccent : Colors.white,
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
                          DateFormat('hh:mm a').format(Chat[index].time),
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
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor:  Colors.blueAccent,
                    child: IconButton(
                      onPressed: () {
                        if (textController.text.isNotEmpty) {
                          setState(() {
                            Chat.add(
                              model(
                                text: textController.text,
                                sender_name: myName,
                                sender_id: myId,
                                time: DateTime.now(),
                              ),
                            );
                            textController.clear();
                          });
                          Future.delayed(
                            const Duration(milliseconds: 100),
                            () => _scrollToBottom(),
                          );
                        }
                      },
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
