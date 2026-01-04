import 'package:flutter/material.dart';
import 'package:main/apiser.dart';

class favorite extends StatefulWidget {
  const favorite({super.key});

  @override
  State<favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<favorite> {
  List<dynamic> favoriteHouses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    try {
      final data = await ApiService.getFavorites();
      setState(() {
        favoriteHouses = data;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching favorites: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> removeFavorite(String id) async {
    try {
      await ApiService.removeFavorite(id);
      setState(() {
        favoriteHouses.removeWhere((house) => house['id'].toString() == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Removed from favorites")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to remove: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "My Favorites",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 5, 110, 197),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : favoriteHouses.isEmpty
              ? const Center(
                  child: Text(
                    "Your favorites list is empty!",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: favoriteHouses.length,
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (context, index) {
                    var item = favoriteHouses[index];
                    // The backend typically returns the detailed apartment object inside the favorite record, 
                    // or flattening it. Assuming `apartment` relation is included or data is flat.
                    // Based on typical Laravel resources, it might be nested `apartment`. 
                    // If backend implementation of Favorites uses ApartmentResource, check response structure.
                    // Assuming for now it returns list of favorite records which contain apartment info
                    var house = item['apartment'] ?? item; 

                    String imageUrl = "images/build1.png";
                    if (house['images'] != null && (house['images'] as List).isNotEmpty) {
                       imageUrl = "${ApiService.storageBaseUrl}${house['images'][0]['path']}";
                    }

                    return Card(
                      color: Colors.grey[200],
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: imageUrl.startsWith("http") 
                              ? Image.network(imageUrl, width: 80, height: 80, fit: BoxFit.cover)
                              : Image.asset(imageUrl, width: 80, height: 80, fit: BoxFit.cover),
                        ),
                        title: Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: Text(
                            house["title"] ?? "Unknown",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 15,
                                  color: Colors.red,
                                ),
                                Expanded(
                                  child: Text(
                                    "${house["governorate"] ?? ''}/${house["city"] ?? ''}",
                                    style: const TextStyle(fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 7),
                              child: Text(
                                "\$${house["price"] ?? 0}/month",
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_forever, color: Colors.red),
                          onPressed: () {
                             // Assuming item['apartment_id'] is the ID to remove based on `removeFavorite` implementation
                             // Or if delete endpoint takes Favorites ID vs Apartment ID. 
                             // Usually removing from favorites list implies removing the favorite record or toggling apartment.
                             // ApiService.removeFavorite(apartmentId) expects apartmentId.
                             removeFavorite(house['id'].toString());
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
