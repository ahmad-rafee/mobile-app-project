import 'package:flutter/material.dart';
import 'package:main/prop.dart';
import 'package:main/Property.dart';
import 'package:main/search.dart';
import 'package:shared_preferences/shared_preferences.dart';

class gridv extends StatefulWidget {
  const gridv({super.key});

  @override
  State<gridv> createState() => _SharedState();
}

class _SharedState extends State<gridv> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test"),
        backgroundColor: Colors.grey,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: custom());
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemCount: properties.length,
        itemBuilder: (context, index) {
          return PropertyCard(property: properties[index]);
        },
      ),
    );
  }
}
