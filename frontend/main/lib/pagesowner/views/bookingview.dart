import 'package:flutter/material.dart';
import 'package:main/apiser.dart';

class BookingsView extends StatefulWidget {
  const BookingsView({super.key});

  @override
  State<BookingsView> createState() => _BookingsViewState();
}

class _BookingsViewState extends State<BookingsView> {
  late Future<List<dynamic>> _bookingsFuture;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  void _loadBookings() {
    setState(() {
      _bookingsFuture = ApiService.getOwnerBookings();
    });
  }

  Future<void> _approve(int id) async {
    try {
      await ApiService.approveBooking(id);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Booking Approved")));
      _loadBookings();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> _reject(int id) async {
    try {
      await ApiService.rejectBooking(id);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Booking Rejected")));
      _loadBookings();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Bookings Requests'),
        centerTitle: true,
        backgroundColor: Colors.grey.shade200,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _bookingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No bookings found."));
          }

          final bookings = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return _bookingCard(booking);
            },
          );
        },
      ),
    );
  }

  Widget _bookingCard(dynamic booking) {
    final status = booking['status'] ?? 'pending';
    final tenant = booking['tenant'];
    final apartment = booking['apartment'];
    final tenantName = tenant != null ? "${tenant['first_name']} ${tenant['last_name']}" : "Unknown Tenant";
    final apartmentTitle = apartment != null ? apartment['title'] : "Unknown Property";

    Color statusColor = Colors.grey;
    if (status == 'approved') statusColor = Colors.green;
    if (status == 'rejected' || status == 'canceled') statusColor = Colors.red;
    if (status == 'pending') statusColor = Colors.orange;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    apartmentTitle,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: statusColor),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text("Tenant: $tenantName", style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 4),
            Text("Dates: ${booking['start_date']} - ${booking['end_date']}", style: const TextStyle(fontSize: 14, color: Colors.grey)),
            
            if (status == 'pending') ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => _reject(booking['id']),
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text("Reject"),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => _approve(booking['id']),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text("Approve", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
