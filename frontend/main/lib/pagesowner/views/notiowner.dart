import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class OwnerNotificationsPage extends StatefulWidget {
  const OwnerNotificationsPage({super.key});

  @override
  State<OwnerNotificationsPage> createState() => _OwnerNotificationsPageState();
}

class _OwnerNotificationsPageState extends State<OwnerNotificationsPage> {
  final List<Map<String, String>> _notifications = [
    {
      "title": "طلب معاينة جديد",
      "body": "هناك مستأجر يرغب بمعاينة الشقة رقم 102",
      "time": "منذ ساعتين",
      "type": "request",
    },
    {
      "title": "تم استلام دفعة",
      "body": "قام المستأجر أحمد بتحويل إيجار شهر ديسمبر",
      "time": "اليوم",
      "type": "payment",
    },
  ];

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
            "title": message.notification!.title ?? "New alert",
            "body": message.notification!.body ?? "Notice content",
            "time": "Now",
            "type": "firebase",
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
        title: const Text(
          "Owner logos",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: _notifications.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 15),
                  Text(
                    "No notifications yet",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: _notifications.length,
              separatorBuilder: (context, index) =>
                  const Divider(height: 1, indent: 70),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getIconColor(
                      _notifications[index]['type'],
                    ),
                    child: Icon(
                      _getIconData(_notifications[index]['type']),
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    _notifications[index]['title']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
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

  IconData _getIconData(String? type) {
    if (type == "payment") return Icons.account_balance_wallet;
    if (type == "request") return Icons.home_work;
    return Icons.notifications;
  }

  Color _getIconColor(String? type) {
    if (type == "payment") return Colors.green;
    if (type == "request") return const Color.fromARGB(255, 5, 110, 197);
    return Colors.blueGrey;
  }
}
