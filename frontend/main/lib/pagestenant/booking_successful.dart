// lib/screens/booking_successful_screen.dart

import 'package:flutter/material.dart';

class BookingSuccessScreen extends StatelessWidget {
  // جعلنا المتغير اختيارياً وديناميكياً ليتناسب مع جميع الشاشات
  final dynamic paymentDetails; 

  const BookingSuccessScreen({Key? key, this.paymentDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // أيقونة النجاح الخضراء
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle, size: 100, color: Colors.green),
              ),
              const SizedBox(height: 30),
              const Text(
                "Success!", 
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black)
              ),
              const SizedBox(height: 15),
              const Text(
                "Your booking has been confirmed successfully.", 
                textAlign: TextAlign.center, 
                style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5)
              ),
              const SizedBox(height: 50),
              // زر العودة للرئيسية
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, 
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 0,
                ),
                onPressed: () {
                  // العودة لأول صفحة في التطبيق لتجنب تراكم الصفحات
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text(
                  "Back to Home", 
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}