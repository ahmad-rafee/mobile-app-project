import 'package:flutter/material.dart';
import 'package:main/pagestenant/apartmentt.dart';
import 'dart:io';

import 'package:main/pagestenant/payment_methods.dart';
class ReviewSummaryScreen extends StatelessWidget {
  final Apartment apartmentData;

  const ReviewSummaryScreen({super.key, required this.apartmentData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Review Summary', 
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // كرت العقار المصلح
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.blue[50], // خلفية زرقاء فاتحة تحت الأيقونة
                      child: Image.file(
                        File(apartmentData.images[0]),
                        fit: BoxFit.cover,
                        // حل مشكلة عدم ظهور الصورة: عرض أيقونة بيت بدلاً منها
                        errorBuilder: (context, error, stackTrace) => 
                          const Icon(Icons.home_work_rounded, color: Colors.blue, size: 50),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(apartmentData.title, 
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text("${apartmentData.city}, ${apartmentData.governorate}", 
                          style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                        const SizedBox(height: 8),
                        Text("\$${apartmentData.price.toStringAsFixed(2)}/month", 
                          style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // تفاصيل الفاتورة
            _buildDetailRow("Amount", "\$${apartmentData.price.toStringAsFixed(2)}"),
            _buildDetailRow("Tax", "\$5.00"),
            _buildDetailRow("Total", "\$${(apartmentData.price + 5).toStringAsFixed(2)}", isTotal: true),
            const SizedBox(height: 24),
            // خيار Cash
            ListTile(
              leading: const Icon(Icons.account_balance_wallet, color: Colors.blue),
              title: const Text("Cash", style: TextStyle(fontWeight: FontWeight.w600)),
              trailing: TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentMethodsScreen(apartmentData: apartmentData))),
                child: const Text("Change"),
              ),
              shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey[200]!), borderRadius: BorderRadius.circular(12)),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentMethodsScreen(apartmentData: apartmentData))),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          ),
          child: const Text("Continue", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: Colors.grey[500])),
          Text(value, style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.w600, fontSize: isTotal ? 18 : 15)),
        ],
      ),
    );
  }
}