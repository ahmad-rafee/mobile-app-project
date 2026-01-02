import 'package:flutter/material.dart';
import 'package:main/pagestenant/apartment.dart';
import 'package:main/pagestenant/favD.dart';
import 'package:main/pagestenant/apartmentt.dart'; // تأكد من صحة المسار
import 'Property.dart';

class PropertyCard extends StatefulWidget {
  final Property property;

  const PropertyCard({super.key, required this.property});

  @override
  State<PropertyCard> createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> {
  int _currentRating = 0;

  @override
  Widget build(BuildContext context) {
    // تحديث حالة الحفظ بناءً على القائمة العامة
    widget.property.isSaved = favoriteHouses.any(
          (h) => h['name'] == widget.property.title,
    );

    return GestureDetector(
      onTap: () {
        // تحويل بيانات كائن Property إلى كائن Apartment ليتناسب مع صفحة التفاصيل
        Apartment apartmentData = Apartment(
          id: DateTime.now().toString(), // معرف فريد مؤقت
          ownerId: "owner_default",
          title: widget.property.title,
          governorate: widget.property.location.split('/').first,
          city: widget.property.location.contains('/')
              ? widget.property.location.split('/').last
              : widget.property.location,
          // تنظيف نص السعر وتحويله إلى double (إزالة $ و /month)
          price: double.tryParse(widget.property.price
              .replaceAll('\$', '')
              .split('/')
              .first
              .trim()) ?? 0.0,
          area: 120.0,  // قيمة افتراضية (يمكنك إضافتها لـ Property لاحقاً)
          rooms: 3,     // قيمة افتراضية
          images: [widget.property.imageUrl],
          description: "This property is one of our best listings in ${widget.property.location}. It offers a great view and modern facilities.",
          available: true,
          approved: true,
          ratings: [],
        );

        // الانتقال لصفحة التفاصيل
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ApartmentDetailScreen(apartment: apartmentData),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة الشقة
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                widget.property.imageUrl,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // العنوان
                        Text(
                          widget.property.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // التقييم بالنجوم
                        Row(
                          children: [
                            Row(
                              children: List.generate(5, (index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _currentRating = index + 1;
                                    });
                                  },
                                  child: Icon(
                                    index < _currentRating
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "($_currentRating.0)",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),
                        // السعر
                        Text(
                          widget.property.price,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // الموقع
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                widget.property.location,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // زر الإضافة للمفضلة (الحفظ)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.property.isSaved = !widget.property.isSaved;
                        if (widget.property.isSaved) {
                          if (!favoriteHouses.any(
                                (h) => h['name'] == widget.property.title,
                          )) {
                            favoriteHouses.add({
                              "name": widget.property.title,
                              "price": widget.property.price,
                              "location": widget.property.location,
                              "image": widget.property.imageUrl,
                              "isSaved": true,
                            });
                          }
                        } else {
                          favoriteHouses.removeWhere(
                                (h) => h['name'] == widget.property.title,
                          );
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: widget.property.isSaved
                            ? Colors.red
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        widget.property.isSaved
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: widget.property.isSaved
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
  }
}