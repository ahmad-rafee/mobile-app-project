import 'package:flutter/material.dart';
import 'package:main/pagestenant/apartmentt.dart';
import 'package:main/pagestenant/user_details.dart';

class TourSchedulingScreen extends StatefulWidget {
  final Apartment apartmentData;
  const TourSchedulingScreen({Key? key, required this.apartmentData}) : super(key: key);

  @override
  State<TourSchedulingScreen> createState() => _TourSchedulingScreenState();
}

class _TourSchedulingScreenState extends State<TourSchedulingScreen> {
  String selectedDay = '4 Oct';
  String selectedTime = '7:00 PM';
  bool isFavorite = false; // التحكم في لون القلب

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(widget.apartmentData.images.first, height: 350, width: double.infinity, fit: BoxFit.cover),
                Positioned(
                  top: 50, left: 20,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
                  ),
                ),
                Positioned( // أيقونة القلب التفاعلية
                  top: 50, right: 20,
                  child: GestureDetector(
                    onTap: () => setState(() => isFavorite = !isFavorite),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? Colors.red : Colors.black),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.apartmentData.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  const Text("Day", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  _buildDaysRow(),
                  const SizedBox(height: 20),
                  const Text("Time", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  _buildTimeRow(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
          onPressed: () {
            final Apartment updated = widget.apartmentData.copyWith(selectedTime: "$selectedDay, $selectedTime");
            Navigator.push(context, MaterialPageRoute(builder: (context) => UserDetailsScreen(tourBooking: updated)));
          },
          child: const Text("Submit", style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
      ),
    );
  }

  Widget _buildDaysRow() {
    List<String> days = ["4 Oct", "5 Oct", "6 Oct", "7 Oct"];
    return SizedBox(height: 70, child: ListView(scrollDirection: Axis.horizontal, children: days.map((d) => _card(d, true)).toList()));
  }

  Widget _buildTimeRow() {
    List<String> times = ["7:00 PM", "7:30 PM", "8:00 PM"];
    return SizedBox(height: 50, child: ListView(scrollDirection: Axis.horizontal, children: times.map((t) => _card(t, false)).toList()));
  }

  Widget _card(String val, bool isDay) {
    bool sel = isDay ? selectedDay == val : selectedTime == val;
    return GestureDetector(
      onTap: () => setState(() => isDay ? selectedDay = val : selectedTime = val),
      child: Container(
        margin: const EdgeInsets.only(right: 10), padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(color: sel ? Colors.blue : Colors.grey[100], borderRadius: BorderRadius.circular(15)),
        alignment: Alignment.center,
        child: Text(val, style: TextStyle(color: sel ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
      ),
    );
  }
}