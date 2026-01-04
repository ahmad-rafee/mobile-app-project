import 'package:flutter/material.dart';
import 'package:main/apiser.dart';

class PropertiesPage extends StatefulWidget {
  const PropertiesPage({super.key});

  @override
  State<PropertiesPage> createState() => _PropertiesPageState();
}

class _PropertiesPageState extends State<PropertiesPage> {
  final Color primaryBlue = const Color(0xFF1E88E5);
  late Future<List<dynamic>> _apartmentsFuture;

  @override
  void initState() {
    super.initState();
    _apartmentsFuture = ApiService.getMyApartments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        title: const Text('My Properties'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _apartmentsFuture,
        builder: (context, snapshot) {
           if (snapshot.connectionState == ConnectionState.waiting) {
             return const Center(child: CircularProgressIndicator());
           } else if (snapshot.hasError) {
             return Center(child: Text("Error: ${snapshot.error}"));
           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
             return const Center(child: Text("No properties found. Add one!"));
           }

           final apartments = snapshot.data!;
           return ListView.builder(
             padding: const EdgeInsets.all(16),
             itemCount: apartments.length,
             itemBuilder: (context, index) {
               return _propertyCard(apartments[index]);
             },
           );
        }
      ),
    );
  }

  Widget _propertyCard(dynamic apartment) {
    // Handling images
    String? imageUrl;
    if (apartment['images'] != null && (apartment['images'] as List).isNotEmpty) {
       imageUrl = "${ApiService.storageBaseUrl}${apartment['images'][0]['path']}";
    }

    return Card(color: Colors.grey[200],
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                color: primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                image: imageUrl != null ? DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ) : null,
              ),
              child: imageUrl == null ? Icon(Icons.apartment, color: primaryBlue, size: 32) : null,
            ),
            const SizedBox(width: 16),
             Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    apartment['title'] ?? 'Untitled Property',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${apartment['city'] ?? 'City'} • ${apartment['rooms'] ?? 0} Rooms',
                    style: const TextStyle(color: Colors.black54),
                  ),
                   const SizedBox(height: 4),
                   Text(
                    '\$${apartment['price'] ?? 0}',
                    style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
