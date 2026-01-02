// ملف apartment.dart
class Rating {
  int stars;
  String comment;
  Rating({required this.stars, required this.comment});
}

class Apartment {
  String id;
  String ownerId;
  String title;
  String governorate;
  String city;
  double price;
  double area;
  int rooms;
  List<String> images;
  String description;
  bool available;
  bool approved;
  List<Rating> ratings;
  String? selectedTime; 

  Apartment({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.governorate,
    required this.city,
    required this.price,
    required this.area,
    required this.rooms,
    required this.images,
    required this.description,
    this.available = true,
    this.approved = false,
    this.ratings = const [],
    this.selectedTime,
  });

  // هذه الدالة هي التي ستحل الخطأ الأحمر في صورة الكود التي أرفقتِها
  Apartment copyWith({
    String? selectedTime,
    bool? available,
  }) {
    return Apartment(
      id: this.id,
      ownerId: this.ownerId,
      title: this.title,
      governorate: this.governorate,
      city: this.city,
      price: this.price,
      area: this.area,
      rooms: this.rooms,
      images: this.images,
      description: this.description,
      available: available ?? this.available,
      approved: this.approved,
      ratings: this.ratings,
      selectedTime: selectedTime ?? this.selectedTime,
    );
  }
}
