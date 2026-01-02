class Booking {
  final String id;
  final String propertyId;
  final DateTime startDate;
  final DateTime endDate;
  final String status;

  Booking({
    required this.id,
    required this.propertyId,
    required this.startDate,
    required this.endDate,
    required this.status,
  });
}
