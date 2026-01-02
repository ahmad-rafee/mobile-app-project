import 'package:flutter/material.dart';

class MyBookingsPage extends StatelessWidget {
  const MyBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> bookings = [
      {
        "title": "Luxury Villa",
        "status": "Pending",
        "date": "2024-05-20",
        "price": "500",
      },
      {
        "title": "Red Cottage",
        "status": "Accepted",
        "date": "2024-06-01",
        "price": "220",
      },
    ];

    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("My Bookings"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final item = bookings[index];
          return Card(color: Colors.grey[200],
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: const Icon(Icons.home_work, color: Colors.blue),
              title: Text(
                item['title'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Date: ${item['date']}"),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "\$${item['price']}",
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    item['status'],
                    style: TextStyle(
                      color: item['status'] == "Accepted"
                          ? Colors.green
                          : Colors.orange,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
