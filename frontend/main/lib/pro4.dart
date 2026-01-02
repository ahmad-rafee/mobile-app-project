import 'package:flutter/material.dart';
import 'package:main/information.dart';
import 'package:main/pro2.dart';
import 'package:main/pro3.dart';

import 'database.dart';

class pro4 extends StatefulWidget {
  const pro4({super.key});

  @override
  State<pro4> createState() => _ProoState();
}

class _ProoState extends State<pro4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Container(
            width: 900,
            height: 350,
            child: Image.asset('images/screen2(3).png', fit: BoxFit.cover),
          ),
          Container(height: 20),
          ListTile(
            title: Text(
              "The key to your new apartment is in your hands.",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "Log in today to save your favorites and receive instant alerts for apartments that match your criteria",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Container(height: 130),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => pro3()),
                    );
                  },
                  child: Icon(
                    Icons.arrow_circle_left_outlined,
                    size: 45,
                    color: const Color.fromARGB(255, 5, 110, 197),
                  ),
                ),
                MaterialButton(
                  onPressed: () async {
                    await Database().isNotFirst();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => Information()),
                    );
                  },
                  child: Icon(
                    Icons.arrow_circle_right_rounded,
                    size: 45,
                    color: const Color.fromARGB(255, 5, 110, 197),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
