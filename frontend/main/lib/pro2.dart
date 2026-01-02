import 'package:flutter/material.dart';
import 'package:main/pro3.dart';

class pro2 extends StatefulWidget {
  const pro2({super.key});

  @override
  State<pro2> createState() => _PrpState();
}

class _PrpState extends State<pro2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Container(
            width: 900,
            height: 350,
            child: Image.asset('images/screen2(1).png', fit: BoxFit.cover),
          ),
          Container(height: 20),
          ListTile(
            title: Text(
              "Goodbye to the hassle of long searches",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            subtitle: Container(
              child: Text(
                "-Discover your ideal apartment in a few simple steps\n-Our platform offers you a wide range of reliable options to suit your needs",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
          Container(height: 110),
          Container(
            alignment: Alignment.bottomRight,
            child: MaterialButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => pro3()),
                );
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(90),
              ),
              child: Icon(
                Icons.arrow_circle_right_rounded,
                size: 45,
                color: const Color.fromARGB(255, 5, 110, 197),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
