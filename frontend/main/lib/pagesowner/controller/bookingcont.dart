import 'package:main/pagesowner/models/booking.dart';

class BookingsController {
  List<Booking> getBookings() {
    return [
      Booking(
        id: '1',
        propertyId: '1',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 3)),
        status: 'Pending',
      ),
    ];
  }
}
