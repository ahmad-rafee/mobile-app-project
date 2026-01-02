import 'package:main/pagesowner/models/property.dart';

class PropertiesController {
  List<Property> getProperties() {
    return [
      Property(
        id: '1',
        title: 'Apartment A',
        location: 'Damascus',
        price: 50,
        isAvailable: true,
      ),
      Property(
        id: '2',
        title: 'Apartment B',
        location: 'Aleppo',
        price: 70,
        isAvailable: false,
      ),
    ];
  }
}
