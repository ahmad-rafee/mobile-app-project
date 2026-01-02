import 'package:flutter/material.dart';
import 'package:main/pagestenant/favD.dart'; // استيراد القائمة العامة

class favorite extends StatefulWidget {
  const favorite({super.key});

  @override
  State<favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<favorite> {
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
      body: favoriteHouses.isEmpty
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
                var house = favoriteHouses[index];
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
                      child: Image.asset(
                        house["image"],
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(left: 3),
                      child: Text(
                        house["name"],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 15,
                              color: Colors.red,
                            ),
                            Text(
                              house["location"],
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 7),
                          child: Text(
                            "\$${house["price"]}/month",
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
                        setState(() {
                          house['isSaved'] = false;
                          favoriteHouses.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
