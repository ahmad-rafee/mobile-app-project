import 'package:flutter/material.dart';
import 'package:main/pagesowner/controller/property.dart';

class PropertiesView extends StatelessWidget {
  PropertiesView({super.key});
  final controller = PropertiesController();

  @override
  Widget build(BuildContext context) {
    final properties = controller.getProperties();

    return Scaffold(
      appBar: AppBar(title: const Text('My Properties')),
      body: ListView.builder(
        itemCount: properties.length,
        itemBuilder: (context, index) {
          final p = properties[index];
          return ListTile(
            title: Text(p.title),
            subtitle: Text(p.location),
            trailing: Text('\$${p.price}'),
          );
        },
      ),
    );
  }
}
