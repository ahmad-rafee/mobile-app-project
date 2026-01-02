import 'package:flutter/material.dart';
import 'package:main/pagestenant/apartmentt.dart';
import 'package:main/pagestenant/booking_options.dart';
class ApartmentDetailScreen extends StatelessWidget {
  final Apartment apartment;
  const ApartmentDetailScreen({required this.apartment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(apartment.title)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(apartment.images.first, height: 280, width: double.infinity, fit: BoxFit.cover),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(apartment.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text("\$${apartment.price} / Month", style: TextStyle(fontSize: 20, color: Colors.teal)),
                  SizedBox(height: 20),
                  Text(apartment.description),
                  SizedBox(height: 40),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal, minimumSize: Size(double.infinity, 55)),
                    onPressed: () {
                      Navigator.push(context,MaterialPageRoute(builder:(context)=>BookingOptionsScreen(apartment: apartment),),);
                    },
                    child: Text("Book Now", style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}