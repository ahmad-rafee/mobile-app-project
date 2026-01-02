import 'package:flutter/material.dart';
import 'package:main/pagestenant/apartmentt.dart';
class EReceiptScreen extends StatelessWidget {
  final Apartment apartment;
  final String paymentMethod;

  const EReceiptScreen({
    super.key, 
    required this.apartment, 
    required this.paymentMethod
  });

  // دالة إظهار رسالة النجاح عند التحميل
  void _showDownloadSuccess(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // لا يغلق إلا بالضغط على الزر
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.blue, size: 80),
              const SizedBox(height: 20),
              const Text(
                "Success!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Your receipt has been downloaded successfully.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // العودة لأول شاشة في التطبيق (Home)
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                child: const Text("Back to Home", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('e-Receipt', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Center(child: Icon(Icons.qr_code_2, size: 100)),
            const SizedBox(height: 30),
            
            // بيانات العقار
            _buildInfoRow("Accommodation", apartment.title),
            _buildInfoRow("Location", "${apartment.city}, ${apartment.governorate}"),
            const Divider(height: 32),
            
            _buildInfoRow("Amount", "\$${apartment.price}"),
            _buildInfoRow("Tax", "\$5.00"),
            _buildInfoRow("Total Amount", "\$${apartment.price + 5}", isBold: true),
            const Divider(height: 32),
            
            // هنا يظهر الاختيار الصحيح (Cash أو Card)
            _buildInfoRow("Payment Method", paymentMethod), 
            _buildInfoRow("Status", "Paid", valueColor: Colors.blue),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          onPressed: () => _showDownloadSuccess(context), // استدعاء الرسالة هنا
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          ),
          child: const Text("Download Receipt", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 16)),
          Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.w600, fontSize: 16, color: valueColor ?? Colors.black)),
        ],
      ),
    );
  }
}