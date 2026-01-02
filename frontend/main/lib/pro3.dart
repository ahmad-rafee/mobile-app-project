import 'package:flutter/material.dart';
import 'package:main/pro2.dart';
import 'package:main/pro4.dart';

class pro3 extends StatefulWidget {
  const pro3({super.key});

  @override
  State<pro3> createState() => _ProState();
}

class _ProState extends State<pro3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Container(
            width: 900,
            height: 350,
            child: Image.asset('images/screen2(2).png', fit: BoxFit.cover),
          ),
          Container(height: 20),
          ListTile(
            title: Text(
              "Unparalleled accuracy in determining your location",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "Browse apartments by neighborhood, budget, number of rooms, smart search algorithms bring you only what matters to you, saving you time and effort",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Container(height: 110),
          Container(
            decoration: BoxDecoration(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => pro2()),
                    );
                  },
                  child: Icon(
                    Icons.arrow_circle_left_outlined,
                    size: 45,
                    color: const Color.fromARGB(255, 5, 110, 197),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => pro4()),
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
