import 'package:flutter/material.dart';
import 'package:main/pagestenant/apartmentt.dart';
import 'package:main/pagestenant/order_successful.dart';


class AddCardScreen extends StatefulWidget {
  final Apartment apartmentData;
  const AddCardScreen({super.key, required this.apartmentData});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  // معرف للنموذج للتحقق من البيانات
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Card', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // صورة تخيلية للبطاقة لتجميل التصميم
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.blue[900],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(alignment: Alignment.topRight, child: Icon(Icons.credit_card, color: Colors.white, size: 40)),
                      Text("**  ** 6555", style: TextStyle(color: Colors.white, fontSize: 22, letterSpacing: 2)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Card Holder", style: TextStyle(color: Colors.white70, fontSize: 12)),
                              Text("Mouna Name", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Expiry", style: TextStyle(color: Colors.white70, fontSize: 12)),
                              Text("12/26", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              
              // حقول الإدخال
              _buildTextField("Card Holder Name", "Enter name"),
              const SizedBox(height: 20),
              _buildTextField("Card Number", "Enter card number", isNumber: true),
              const SizedBox(height: 20),
              
              Row(
                children: [
                  Expanded(child: _buildTextField("Expiry Date", "MM/YY", isNumber: true)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField("CVV", "123", isNumber: true)),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          onPressed: () {
            // الانتقال لشاشة النجاح مع تمرير نوع الدفع 'Card'
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderSuccessfulScreen(
                  apartment: widget.apartmentData,
                  paymentMethod: 'Card', // تحديد أن الدفع بطاقة ليظهر في الإيصال
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          ),
          child: const Text("Add Card", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}