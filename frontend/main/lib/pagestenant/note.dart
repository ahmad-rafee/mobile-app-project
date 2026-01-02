import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final List<Map<String, String>> _notifications = [];

  @override
  void initState() {
    super.initState();
    _setupInteractions();
  }

  void _setupInteractions() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        setState(() {
          _notifications.insert(0, {
            "title": message.notification!.title ?? "Untitled",
            "body": message.notification!.body ?? "No content",
            "time": "Now",
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: _notifications.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_off_outlined, size: 60, color: Colors.grey),
            SizedBox(height: 10),
            Text("No notifications yet", style: TextStyle(color: Colors.grey)),
          ],
        ),
      )
          : ListView.separated(
        itemCount: _notifications.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color.fromARGB(255, 5, 110, 197),
              child: Icon(Icons.notifications, color: Colors.white, size: 20),
            ),
            title: Text(
              _notifications[index]['title']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(_notifications[index]['body']!),
            trailing: Text(
              _notifications[index]['time']!,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          );
        },
      ),
    );
  }
}
class NotificationsService {
  static Future<void> initialize() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();
    String? token = await messaging.getToken();

    print("#########################################");
    print("DEVICE TOKEN: $token");
    print("#########################################");
  }
}