import 'package:flutter/material.dart';
import 'package:main/pro2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pro1 extends StatefulWidget {
  const Pro1({super.key});

  @override
  State<Pro1> createState() => _ProState();
}

class _ProState extends State<Pro1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Container(
            width: 600,
            height: 550,
            child: Image.asset("images/screen1(1).png", fit: BoxFit.cover),
          ),
          Container(height: 15),
          Container(
            margin: EdgeInsets.only(left: 75, bottom: 10),
            child: Row(
              children: [
                Container(
                  height: 60,
                  child: Image.asset('images/screen1(2).png'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Text(
                    "Gharr",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Text(
                    "For",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Text(
                    ".Sale",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 70),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(23),
              ),
              padding: EdgeInsets.symmetric(vertical: 10),
              color: Colors.blue,
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool("firstTime", false);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => pro2()),
                );
              },
              child: Text(
                "Get started",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
