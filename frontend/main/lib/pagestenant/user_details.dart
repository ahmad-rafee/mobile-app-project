// lib/screens/user_details_screen.dart

import 'package:flutter/material.dart';
import 'package:main/pagestenant/apartmentt.dart';
import 'package:main/pagestenant/booking_successful.dart';
// ⚠️ تأكدي أن اسم الملف هنا يطابق الملف الذي ستنشئينه في الخطوة التالية
 

class UserDetailsScreen extends StatefulWidget {
  final Apartment tourBooking;
  const UserDetailsScreen({Key? key, required this.tourBooking}) : super(key: key);

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  String? sDay, sMonth, sYear, sCountry;
  String sGender = "Male"; 
  final phoneCtrl = TextEditingController();

  // الأشهر كاملة
  final List<String> allMonths = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
  
  // السنوات تبدأ من 2000
  final List<String> allYears = List.generate(26, (i) => (2000 + i).toString());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Book Tour", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), 
        backgroundColor: Colors.white, elevation: 0, centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context))
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label("Name"), _field("Enter your name"),
            _label("Email"), _field("example@gmail.com"),
            _label("Age"),
            Row(children: [
              Expanded(child: _drop("Day", List.generate(31, (i)=>"${i+1}"), sDay, (v)=>setState(()=>sDay=v))),
              const SizedBox(width: 8),
              Expanded(child: _drop("Month", allMonths, sMonth, (v)=>setState(()=>sMonth=v))),
              const SizedBox(width: 8),
              Expanded(child: _drop("Year", allYears, sYear, (v)=>setState(()=>sYear=v))),
            ]),
            _label("Gender"),
            Row(children: ["Male", "Female", "Others"].map((g) => Expanded(child: Row(children: [Radio<String>(activeColor: Colors.blue, value: g, groupValue: sGender, onChanged: (v)=>setState(()=>sGender=v!)), Text(g, style: const TextStyle(fontSize: 12))]))).toList()),
            _label("Mobile Number"),
            TextField(
              controller: phoneCtrl, keyboardType: TextInputType.phone, 
              decoration: InputDecoration(
                prefixIcon: const Padding(padding: EdgeInsets.all(15), child: Text("+963 ", style: TextStyle(fontWeight: FontWeight.bold))), 
                filled: true, fillColor: Colors.grey[100], 
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none)
              )
            ),
            _label("Country"),
            _drop("Select Country", ["Syria", "UAE", "Saudi Arabia", "Lebanon"], sCountry, (v)=>setState(()=>sCountry=v)),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), 
              onPressed: () {
                // الانتقال إلى شاشة النجاح
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BookingSuccessScreen()),
                );
              }, 
              child: const Text("Continue", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String t) => Padding(padding: const EdgeInsets.only(top: 20, bottom: 8), child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold)));
  Widget _field(String h) => TextField(decoration: InputDecoration(hintText: h, filled: true, fillColor: Colors.grey[100], border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none)));
  Widget _drop(String h, List<String> i, String? v, ValueChanged<String?> on) => Container(padding: const EdgeInsets.symmetric(horizontal: 10), decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)), child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: v, hint: Text(h), isExpanded: true, items: i.map((e)=>DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: on)));
}