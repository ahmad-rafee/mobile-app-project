import 'package:flutter/material.dart';
import 'package:main/Property.dart';
import 'package:main/pagesowner/models/property.dart' hide Property;
import 'package:main/pagestenant/apartment.dart';
import 'package:main/pagestenant/favD.dart';
import 'package:main/pagestenant/apartmentt.dart';

class custom extends SearchDelegate {
  String? selectedCity;
  RangeValues priceRange = const RangeValues(0, 2000);
  final List<String> syrianCities = [
    "Syria",
    "Jordon",
    "UAE",
    "Sweden",
    "Scotland",
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () => query = "", icon: const Icon(Icons.close)),
      IconButton(
        onPressed: () => _showFilterInSearch(context),
        icon: const Icon(Icons.tune, color: Color(0xFF1E88E5)),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) => _buildFilteredList();

  @override
  Widget buildSuggestions(BuildContext context) => _buildFilteredList();

  Widget _buildFilteredList() {
    final List<Property> filtered = properties.where((p) {
      final bool matchesQuery =
          p.title.toLowerCase().contains(query.toLowerCase()) ||
              p.location.toLowerCase().contains(query.toLowerCase());

      final bool matchesCity =
          selectedCity == null ||
              p.location.toLowerCase().contains(selectedCity!.toLowerCase());

      double numericPrice = _extractPrice(p.price);
      final bool matchesPrice =
          numericPrice >= priceRange.start && numericPrice <= priceRange.end;

      return matchesQuery && matchesCity && matchesPrice;
    }).toList();

    if (filtered.isEmpty) {
      return const Center(child: Text("No properties match your search."));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final p = filtered[index];

        p.isSaved = favoriteHouses.any((h) => h['name'] == p.title);

        // --- التعديل هنا: تغليف الكارد بـ GestureDetector ---
        return GestureDetector(
          onTap: () {
            // تحويل الـ Property إلى كائن Apartment لصفحة التفاصيل
            Apartment apartmentData = Apartment(
              id: DateTime.now().toString(),
              ownerId: "search_owner",
              title: p.title,
              governorate: p.location.split('/').first,
              city: p.location.contains('/') ? p.location.split('/').last : p.location,
              price: _extractPrice(p.price),
              area: 130.0, // قيمة افتراضية
              rooms: 3,    // قيمة افتراضية
              images: [p.imageUrl],
              description: "Found via search: ${p.title} in ${p.location}. A great place for tenants.",
              available: true,
              approved: true,
              ratings: [],
            );

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ApartmentDetailScreen(apartment: apartmentData),
              ),
            );
          },
          child: Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(15),
                      ),
                      child: Image.asset(
                        p.imageUrl,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: () {
                          // هذا الجزء خاص بالمفضلة داخل البحث
                          p.isSaved = !p.isSaved;
                          if (p.isSaved) {
                            if (!favoriteHouses.any((h) => h['name'] == p.title)) {
                              favoriteHouses.add({
                                "name": p.title,
                                "price": p.price,
                                "location": p.location,
                                "image": p.imageUrl,
                                "isSaved": true,
                              });
                            }
                          } else {
                            favoriteHouses.removeWhere((h) => h['name'] == p.title);
                          }
                          (context as Element).markNeedsBuild();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: p.isSaved ? Colors.red : Colors.black26,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            p.isSaved ? Icons.favorite : Icons.favorite_border,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ListTile(
                  title: Text(
                    p.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(p.location),
                  trailing: Text(
                    p.price,
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  double _extractPrice(String priceString) {
    String cleanStr = priceString.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanStr.isNotEmpty) {
      return double.tryParse(cleanStr) ?? 0.0;
    }
    return 0.0;
  }

  void _showFilterInSearch(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Filter Results",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: selectedCity,
                    hint: const Text("Select City"),
                    items: syrianCities
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (val) => setModalState(() => selectedCity = val),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Price: \$${priceRange.start.round()} - \$${priceRange.end.round()}",
                  ),
                  RangeSlider(
                    activeColor: Colors.blueAccent,
                    values: priceRange,
                    min: 0,
                    max: 2000,
                    divisions: 20,
                    onChanged: (val) => setModalState(() => priceRange = val),
                  ),
                  MaterialButton(
                    color: Colors.blueAccent,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Apply",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}