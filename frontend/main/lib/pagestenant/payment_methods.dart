import 'package:flutter/material.dart';
import 'package:main/pagestenant/add_card.dart';
import 'package:main/pagestenant/apartmentt.dart';
import 'package:main/pagestenant/order_successful.dart';
import 'package:main/apiser.dart';

class PaymentMethodsScreen extends StatefulWidget {
  final Apartment apartmentData;
  const PaymentMethodsScreen({super.key, required this.apartmentData});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  String _selectedMethod = 'Cash'; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Methods', style: TextStyle(fontWeight: FontWeight.bold)), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                const Text("Cash", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                _buildOption("Cash", Icons.money, 'Cash'),
                const SizedBox(height: 24),
                const Text("Credit & Debit Card", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                _buildOption("Add New Card", Icons.add_card, 'Card', isAction: true),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () async {
                // Extract dates from selectedTime (hack from BookingOptionsScreen)
                String start = "";
                String end = "";
                if (widget.apartmentData.selectedTime != null && widget.apartmentData.selectedTime!.contains('|')) {
                  final parts = widget.apartmentData.selectedTime!.split('|');
                  start = parts[0];
                  end = parts[1];
                } else {
                  start = DateTime.now().toIso8601String().split('T')[0];
                  end = DateTime.now().add(const Duration(days: 30)).toIso8601String().split('T')[0];
                }

                // Call API
                try {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Processing Payment...")));
                  
                  String loc = "${widget.apartmentData.governorate}, ${widget.apartmentData.city}";

                  await ApiService.createBooking(
                    apartmentId: widget.apartmentData.id,
                    startDate: start,
                    endDate: end,
                    location: loc,
                    paymentMethod: _selectedMethod,
                  );

                   Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderSuccessfulScreen(
                        apartment: widget.apartmentData,
                        paymentMethod: _selectedMethod, 
                      ),
                    ),
                  );
                } catch (e) {
                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Booking Failed: $e")));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              ),
              child: const Text("Confirm Payment", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(String title, IconData icon, String value, {bool isAction = false}) {
    return RadioListTile<String>(
      title: Row(children: [Icon(icon, color: Colors.blue), const SizedBox(width: 12), Text(title)]),
      value: value,
      groupValue: _selectedMethod,
      onChanged: (val) {
        if (isAction) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddCardScreen(apartmentData: widget.apartmentData)));
        } else {
          setState(() => _selectedMethod = val!);
        }
      },
    );
  }
}