import 'package:flutter/material.dart';
import 'package:main/Property.dart';
import 'package:main/chatModel/User_model.dart';
import 'package:main/pagestenant/fav.dart';
import 'package:main/pagestenant/hometenant.dart';
import 'package:main/pagestenant/message.dart';
import 'package:main/prop.dart';
import 'package:main/search.dart';

class tenant extends StatefulWidget {
  final User_model? user;
  const tenant({super.key, this.user});
  @override
  State<tenant> createState() => _TenantState();
}

class _TenantState extends State<tenant> {
  int _selected = 0;

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
