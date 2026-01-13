import 'package:flutter/material.dart';
import 'package:main/Property.dart';
import 'package:main/database.dart';
import 'package:main/information.dart';
import 'package:main/pagestenant/apartment.dart';
import 'package:main/pagestenant/apartmentt.dart';
import 'package:main/pagestenant/fav.dart';
import 'package:main/pagestenant/favD.dart';
import 'package:main/pagestenant/message.dart';
import 'package:main/pagestenant/mybooking.dart';
import 'package:main/pagestenant/note.dart';
import 'package:main/pagestenant/setting.dart';
import 'package:main/prop.dart';
import 'package:main/search.dart';
import 'package:main/apiser.dart';

class hometenant extends StatefulWidget {
  const hometenant({super.key});

  @override
  State<hometenant> createState() => _hometenantState();
}

class _hometenantState extends State<hometenant> {
  String selectedCategory = "Recommended";

  void applyAdvancedFilter() {
    setState(() {
      filteredHouses = allHouses.where((house) {
        double housePrice = double.parse(house['price']);
        bool matchesCity =
            selectedCity == null || house['location'].contains(selectedCity!);
        bool matchesPrice =
            housePrice >= _currentPriceRange.start &&
            housePrice <= _currentPriceRange.end;
        return matchesCity && matchesPrice;
      }).toList();
    });
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.white,
          title: const Text("Choose language", textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Text("🇺🇸", style: TextStyle(fontSize: 20)),
                title: const Text("English"),
                onTap: () => Navigator.pop(context),
              ),
              const Divider(),
              ListTile(
                leading: const Text("🇸🇦", style: TextStyle(fontSize: 20)),
                title: const Text("العربية"),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  RangeValues _currentPriceRange = const RangeValues(100, 1000);
  String? selectedCity;
  List<String> syrianCities = ["Syria", "Jordon", "UAE", "Sweden", "Scotland"];

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Filter Properties",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    "City",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: selectedCity,
                    hint: const Text("Select City"),
                    items: syrianCities
                        .map(
                          (city) =>
                              DropdownMenuItem(value: city, child: Text(city)),
                        )
                        .toList(),
                    onChanged: (val) => setModalState(() => selectedCity = val),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    "Price Range: \$${_currentPriceRange.start.round()} - \$${_currentPriceRange.end.round()}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  RangeSlider(
                    activeColor: Colors.blueAccent,
                    values: _currentPriceRange,
                    min: 0,
                    max: 2000,
                    divisions: 20,
                    labels: RangeLabels(
                      _currentPriceRange.start.round().toString(),
                      _currentPriceRange.end.round().toString(),
                    ),
                    onChanged: (values) =>
                        setModalState(() => _currentPriceRange = values),
                  ),

                  const SizedBox(height: 30),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              selectedCity = null;
                              _currentPriceRange = const RangeValues(100, 1000);
                              filterData(selectedCategory);
                            });
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Reset",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryBlue,
                          ),
                          onPressed: () {
                            applyAdvancedFilter();
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Apply Filter",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  final Color primaryBlue = const Color(0xFF1E88E5);

  ListTile _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: primaryBlue),
      title: Text(title),
      onTap: onTap,
    );
  }

  List<dynamic> allHouses = [];
  List filteredHouses = [];
  bool isLoading = true;

  // User Profile State
  String? firstName;
  String? lastName;
  String? phone;
  String? profileImage;

  @override
  void initState() {
    super.initState();
    fetchApartments();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      final response = await ApiService.getProfile();
      if (response['success'] == true && response['user'] != null) {
        setState(() {
          firstName = response['user']['first_name'];
          lastName = response['user']['last_name'];
          phone = response['user']['phone'];
          final imgPath = response['user']['profile_image'];
          if (imgPath != null && imgPath.isNotEmpty) {
            profileImage = "${ApiService.storageBaseUrl}$imgPath";
          }
        });
      }
    } catch (e) {
      print("Error fetching profile: $e");
    }
  }

  // Near You Properties
  List<Property> nearYouProperties = [];

  Future<void> fetchApartments() async {
    try {
      final apartments = await ApiService.getApartments();
      setState(() {
        allHouses = apartments.map((apt) {
          String imageUrl = "images/build1.png"; // default
          if (apt['images'] != null && (apt['images'] as List).isNotEmpty) {
             imageUrl = "${ApiService.storageBaseUrl}${apt['images'][0]['path']}";
          }

          return {
            "name": apt['title'] ?? "Apartment",
            "category": "Recommended", // Default category
            "price": apt['price'].toString(),
            "location": "${apt['governorate']}/${apt['city']}",
            "image": imageUrl,
            "area": double.tryParse(apt['area'].toString()) ?? 0.0,
            "rooms": int.tryParse(apt['rooms'].toString()) ?? 0,
            "isSaved": false,
            "description": apt['description']
          };
        }).toList();

        // Populate Near You properties (Converted to Property object)
        nearYouProperties = apartments.map((apt) {
           String imageUrl = "images/build1.png";
          if (apt['images'] != null && (apt['images'] as List).isNotEmpty) {
             imageUrl = "${ApiService.storageBaseUrl}${apt['images'][0]['path']}";
          }
          return Property(
            title: apt['title'] ?? "Apartment",
            price: "\$${apt['price']}", // Format price
            location: "${apt['governorate']}/${apt['city']}",
            imageUrl: imageUrl,
            isSaved: false,
          );
        }).toList();

        filterData("Recommended");
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching apartments: $e");
      setState(() {
        isLoading = false;
        // Fallback to empty or show error
      });
    }
  }

  void filterData(String category) {
    setState(() {
      selectedCategory = category;
      // Since we don't have categories in backend yet, we just show all or implement client-side category logic
      // For now, allow all "Recommended" to show everything, or just ignore category filtering for API data
      if (allHouses.isEmpty) return;

      filteredHouses = allHouses; 
      
      // Update favorites
      for (var house in filteredHouses) {
        house['isSaved'] = favoriteHouses.any(
          (fav) => fav['name'] == house['name'],
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Text("Welcome ${firstName ?? 'Tenant'}"),
      ),

      drawer: Drawer(
        backgroundColor: Colors.grey[300],
        child: DrawerHeader(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(),
          child: ListView(
            children: [
              Row(
                children: [
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(70),
                      child: profileImage != null
                          ? Image.network(
                              profileImage!,
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                "images/screen2(2).png",
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.asset(
                              "images/screen2(2).png",
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text(
                        firstName != null ? "$firstName $lastName" : "Guest",
                        style: TextStyle(fontSize: 15),
                      ),
                      subtitle: Text(
                        phone ?? "No phone number",
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ),
                  ),
                ],
              ),
              _drawerItem(Icons.person_outline, 'Profile', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Setteing();
                    },
                  ),
                );
              }),
              _drawerItem(Icons.calendar_month_outlined, 'My Bookings', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyBookingsPage(),
                  ),
                );
              }),
              _drawerItem(Icons.notifications_outlined, 'Notifications', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationsPage(),
                  ),
                );
              }),
              _drawerItem(Icons.language_outlined, 'Language', () {
                _showLanguageDialog(context);
              }),
              _drawerItem(Icons.call, "Contact us", () {}),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: const Color.fromARGB(255, 220, 15, 40),
                ),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 220, 15, 40),
                  ),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        title: const Text("Logout"),
                        content: const Text(
                          "Are you sure you want to log out?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              "exit",
                              style: TextStyle(color: Colors.blueAccent),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              try {
                                await ApiService.logout();
                              } catch (e) {
                                print("Logout API error: $e");
                              }

                              Navigator.of(context).pop();

                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MyLoginPage(),
                                ),
                                (route) => false,
                              );
                            },
                            child: const Text(
                              "Sure",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 125,
              padding: const EdgeInsets.only(top: 35, left: 30, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Let's find your",
                        style: TextStyle(fontSize: 17, color: Colors.grey[500]),
                      ),
                      Text(
                        "Favorite Home",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: profileImage != null
                        ? NetworkImage(profileImage!)
                        : AssetImage("images/hitler.png") as ImageProvider,
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onTap: () {
                        showSearch(context: context, delegate: custom());
                      },
                      decoration: InputDecoration(
                        hintText: "Search by Address, City",
                        prefixIcon: Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _showFilterBottomSheet(); // استدعاء الدالة هنا
                    },
                    icon: const Icon(
                      Icons.filter_list_outlined,
                      color: Color.fromARGB(255, 5, 110, 197),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              height: 45,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: [
                  categoryButton("Recommended"),
                  categoryButton("Top Rates"),
                  categoryButton("Best Offers"),
                ],
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              height: 340,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 15),
                itemCount: filteredHouses.length,
                itemBuilder: (context, index) {
                  var house = filteredHouses[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ApartmentDetailScreen(
                            apartment: Apartment(
                              id: DateTime.now().toString(),
                              ownerId: "owner_default",
                              title: house['name'],
                              governorate: house['location'].split('/').first,
                              city: house['location'].contains('/')
                                  ? house['location'].split('/').last
                                  : house['location'],
                              price: double.parse(house['price']),
                              area: house['area']?.toDouble() ?? 0.0,
                              rooms: house['rooms'] ?? 0,
                              images: [house['image']],
                              description:
                                  "This is a premium property located in ${house['location']}. Features ${house['rooms']} rooms with a total area of ${house['area']} sqm.",
                              available: true,
                              approved: true,
                              ratings: [],
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 280,
                      margin: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Image.asset(
                              house['image'],
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      house['name'],
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "\$${house['price']}/month",
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                          size: 16,
                                          color: Colors.red,
                                        ),
                                        Text(
                                          house['location'],
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      house['isSaved'] = !house['isSaved'];
                                      if (house['isSaved']) {
                                        if (!favoriteHouses.any(
                                          (element) =>
                                              element['name'] == house['name'],
                                        )) {
                                          favoriteHouses.add(house);
                                        }
                                      } else {
                                        favoriteHouses.removeWhere(
                                          (element) =>
                                              element['name'] == house['name'],
                                        );
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: house['isSaved']
                                          ? Colors.red
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      house['isSaved']
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: house['isSaved']
                                          ? Colors.white
                                          : Colors.red,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Text(
                "Near You",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 25),
            Container(
              height: 420,
              child: nearYouProperties.isEmpty
                ? const Center(child: Text("No properties near you"))
                : PageView.builder(
                itemBuilder: (context, index) {
                  return PropertyCard(property: nearYouProperties[index]);
                },
                scrollDirection: Axis.vertical,
                itemCount: nearYouProperties.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget categoryButton(String text) {
    bool isSelected = selectedCategory == text;
    return GestureDetector(
      onTap: () => filterData(text),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFE3F2FD) : Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected
                  ? Color.fromARGB(255, 5, 110, 197)
                  : Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
