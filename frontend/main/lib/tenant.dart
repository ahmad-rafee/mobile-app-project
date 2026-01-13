import 'dart:async';
import 'package:flutter/material.dart';
import 'package:main/Property.dart';
import 'package:main/chatModel/User_model.dart';
import 'package:main/pagestenant/fav.dart';
import 'package:main/pagestenant/hometenant.dart';
import 'package:main/pagestenant/message.dart';
import 'package:main/prop.dart';
import 'package:main/search.dart';
import 'package:main/apiser.dart';

class tenant extends StatefulWidget {
  final User_model? user;
  const tenant({super.key, this.user});
  @override
  State<tenant> createState() => _TenantState();
}

class _TenantState extends State<tenant> with WidgetsBindingObserver {
  int _selected = 0;
  Timer? _notificationTimer;
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startNotificationPolling();
    _fetchUnreadCount();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _notificationTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App came back to foreground - restart polling and fetch immediately
      _startNotificationPolling();
      _fetchUnreadCount();
    } else if (state == AppLifecycleState.paused) {
      // App went to background - stop polling to save battery
      _notificationTimer?.cancel();
    }
  }

  void _startNotificationPolling() {
    _notificationTimer?.cancel();
    _notificationTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _fetchUnreadCount();
    });
  }

  Future<void> _fetchUnreadCount() async {
    try {
      final notifications = await ApiService.getNotifications();
      final unread = notifications.where((n) => 
        n['is_read'] == false || n['is_read'] == 0
      ).length;
      if (mounted) {
        setState(() => _unreadCount = unread);
      }
    } catch (e) {
      print("Error fetching notifications: $e");
    }
  }

  void _navigBBar(int i) {
    setState(() {
      _selected = i;
    });
  }

  List<Widget> pages = [
    hometenant(),
    Message(),
    favorite(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[_selected],
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Color.fromARGB(255, 5, 110, 197),
        backgroundColor: Colors.grey[300],
        unselectedFontSize: 10,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selected,
        onTap: _navigBBar,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),

          BottomNavigationBarItem(icon: Icon(Icons.message), label: "Message"),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: "Favorite",
          ),
        ],
      ),
    );
  }
}
