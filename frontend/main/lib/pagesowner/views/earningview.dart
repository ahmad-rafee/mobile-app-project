import 'package:flutter/material.dart';
import 'package:main/pagesowner/controller/earningcon.dart';

class EarningsView extends StatelessWidget {
  EarningsView({super.key});
  final controller = EarningsController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Earnings')),
      body: Center(
        child: Text(
          '\$${controller.getTotalEarnings()}',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
