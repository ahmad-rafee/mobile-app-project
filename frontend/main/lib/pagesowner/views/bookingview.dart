import 'package:flutter/material.dart';
import 'package:main/pagesowner/controller/bookingcont.dart';

class BookingsView extends StatelessWidget {
  BookingsView({super.key});
  final controller = BookingsController();

  @override
  Widget build(BuildContext context) {
    final bookings = controller.getBookings();

    return Scaffold(
      appBar: AppBar(title: const Text('Bookings')),
      body: ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Booking ${bookings[index].id}'),
            subtitle: Text(bookings[index].status),
          );
        },
      ),
    );
  }
}
