import 'package:flutter/material.dart';
import 'package:main/pagestenant/apartmentt.dart';
import 'package:main/pagestenant/e_receipt.dart';


class OrderSuccessfulScreen extends StatelessWidget {
  final Apartment apartment;
  final String paymentMethod; // استقبال نوع الدفع

  const OrderSuccessfulScreen({super.key, required this.apartment, required this.paymentMethod});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          const Icon(Icons.check_circle, color: Colors.blue, size: 100),
          const SizedBox(height: 24),
          const Text("Congratulations!", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          const Text("Your Apartment Successfully Booked.", style: TextStyle(color: Colors.grey)),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EReceiptScreen(
                      apartment: apartment,
                      paymentMethod: paymentMethod, // تمرير القيمة للإيصال
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              ),
              child: const Text("View e-Receipt", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}