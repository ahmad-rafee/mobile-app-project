// lib/screens/agent_rating_screen.dart

import 'package:flutter/material.dart';
import 'package:main/pagestenant/apartmentt.dart';

class AgentRatingScreen extends StatelessWidget {
  final Apartment houseDetails;

  const AgentRatingScreen({Key? key, required this.houseDetails})
    : super(key: key);

  void _navigateHome(BuildContext context) {
    // عند الضغط على Submit، نعود للشاشة الرئيسية
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    // (بناء واجهة 3299.jpg هنا)
    return Scaffold(
      appBar: AppBar(title: const Text('Agent Rating')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('How was your experience?'),
            ElevatedButton(
              onPressed: () => _navigateHome(context),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
