// lib/screens/booking_options_screen.dart
import 'package:flutter/material.dart';
import 'package:main/pagestenant/apartmentt.dart';
import 'package:main/pagestenant/review_summary.dart';
import 'package:main/pagestenant/tour_scheduling.dart';

class BookingOptionsScreen extends StatefulWidget {
  final Apartment apartment;

  const BookingOptionsScreen({super.key, required this.apartment});

  @override
  State<BookingOptionsScreen> createState() => _BookingOptionsScreenState();
}

class _BookingOptionsScreenState extends State<BookingOptionsScreen> {
  final List<String> _options = ['Property Tour', 'Real Estate'];
  String? _selectedOption = 'Property Tour';

  void _navigateToNextScreen() async {
    if (_selectedOption == null) return;

    if (_selectedOption == 'Property Tour') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TourSchedulingScreen(apartmentData: widget.apartment),
        ),
      );
    } else if (_selectedOption == 'Real Estate') {
      // Pick Date Range
      final DateTimeRange? picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: Colors.blue,
              colorScheme: const ColorScheme.light(primary: Colors.blue),
              buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child!,
          );
        },
      );

      if (picked != null) {
        // Prepare Object
        final Apartment realEstateBooking = Apartment(
          id: widget.apartment.id,
          ownerId: widget.apartment.ownerId,
          title: widget.apartment.title, 
          governorate: widget.apartment.governorate,
          city: widget.apartment.city,
          price: widget.apartment.price,
          area: widget.apartment.area,
          rooms: widget.apartment.rooms,
          images: widget.apartment.images,
          description: widget.apartment.description,
          // Store selected dates in a way we can retrieve later. 
          // Since Apartment model might not have startDate/endDate fields, we can use selectedTime as a hack or just pass it via constructor wrapper if we could.
          // Or strictly for this flow, we will modify the Apartment class via copyWith or dynamic field if simpler.
          // Better: Pass these dates to ReviewSummaryScreen as separate arguments. 
          // However, ReviewSummaryScreen expects 'apartmentData'.
          // Let's attach them to 'selectedTime' string manually for now: "YYYY-MM-DD|YYYY-MM-DD"
          selectedTime: "${picked.start.toIso8601String().split('T')[0]}|${picked.end.toIso8601String().split('T')[0]}",
        );
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReviewSummaryScreen(apartmentData: realEstateBooking),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: const Text(
          'Booking',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 10.0, bottom: 8.0),
            child: Text(
              "Booking Options",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ..._options.map((String options) {
            return Column(
              children: [
                RadioListTile<String>(
                  title: Text(options),
                  value: options,
                  groupValue: _selectedOption,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedOption = value;
                    });
                  },
                  activeColor: Colors.blue,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                ),
                if (options == _options.first)
                  const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16),
              ],
            );
          }).toList(),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
        child: ElevatedButton(
          onPressed: _navigateToNextScreen,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 55),
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)), // شكل عصري
          ),
          child: const Text('Continue', style: TextStyle(fontSize: 18, color: Colors.white)),
        ),
      ),
    );
  }
}