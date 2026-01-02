class Payment {
  final String id;
  final String bookingId;
  final double amount;
  final DateTime date;

  Payment({
    required this.id,
    required this.bookingId,
    required this.amount,
    required this.date,
  });
}
