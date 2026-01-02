// lib/screens/request_received_screen.dart

import 'package:flutter/material.dart';
import 'package:main/pagestenant/apartmentt.dart';
import 'package:main/pagestenant/payment_methods.dart';
 // الشاشة التالية للدفع (3300.jpg)

class RequestReceivedScreen extends StatelessWidget {
  final Apartment tourBooking;

  const RequestReceivedScreen({Key? key, required this.tourBooking}) : super(key: key);

  void _navigateToNextScreen(BuildContext context) {
    // ⬅️ نذهب إلى شاشة الدفع (Payment Methods) لدفع رسوم الجولة الثابتة $50
    const double tourFree=10.0;
    final Apartment paymentDetails=Apartment(
id: tourBooking.id,
ownerId: tourBooking.ownerId,
title: "${tourBooking.title}(Tour Free)",
governorate: tourBooking.governorate,
city: tourBooking.city,
price: tourFree,
area: tourBooking.area,
rooms: tourBooking.rooms,
images: tourBooking.images,
description: tourBooking.description,
available: tourBooking.available,
approved: tourBooking.approved,
ratings: tourBooking.ratings,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentMethodsScreen(apartmentData: paymentDetails),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // (بناء واجهة 3298.jpg هنا)
    return Scaffold(
      appBar: AppBar(title: const Text('Tour Request')),
      body: Center(child: Text('تم استلام الطلب: ${tourBooking.selectedTime}')),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(onPressed: () => _navigateToNextScreen(context), child: const Text('Continue (Go to Payment)')),
      ),
    );
  }
}