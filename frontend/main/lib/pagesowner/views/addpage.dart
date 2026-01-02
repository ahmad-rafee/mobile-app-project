import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPropertyPage extends StatefulWidget {
  const AddPropertyPage({super.key});

  @override
  State<AddPropertyPage> createState() => _AddPropertyPageState();
}

class _AddPropertyPageState extends State<AddPropertyPage> {
  final Color primaryBlue = const Color(0xFF1E88E5);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController roomsController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController featureController = TextEditingController();

  XFile? pickedImage;
  final ImagePicker picker = ImagePicker();

  final List<String> selectedFeatures = [];
  final List<String> availableFeatures = [
    'Pool',
    'WiFi',
    'Parking',
    'Air Conditioning',
    'Gym',
    'Pet Friendly',
  ];

  Future<void> _pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        pickedImage = image;
      });
    }
  }

  void _addFeature(String feature) {
    if (feature.isNotEmpty && !selectedFeatures.contains(feature)) {
      setState(() {
        selectedFeatures.add(feature);
      });
      featureController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text('Add Property'),
        centerTitle: true,
        backgroundColor: Colors.grey.shade200,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade300),
                  image: pickedImage != null
                      ? DecorationImage(
                          image: FileImage(File(pickedImage!.path)),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: pickedImage == null
                    ? const Center(
                        child: Icon(
                          Icons.add_a_photo,
                          size: 40,
                          color: Colors.grey,
                        ),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 20),

            _inputField('Property Name', controller: nameController),
            _inputField('Location', controller: locationController),
            _inputField(
              'Price per Month',
              controller: priceController,
              keyboard: TextInputType.number,
            ),
            _inputField(
              'Number of Rooms',
              controller: roomsController,
              keyboard: TextInputType.number,
            ),
            _inputField(
              'Description',
              controller: descriptionController,
              maxLines: 4,
            ),

            const SizedBox(height: 16),
            const Text(
              'Features',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: availableFeatures.map((feature) {
                final isSelected = selectedFeatures.contains(feature);
                return ChoiceChip(
                  label: Text(feature),
                  selected: isSelected,
                  selectedColor: primaryBlue.withOpacity(0.2),
                  backgroundColor: Colors.grey.shade200,
                  labelStyle: TextStyle(
                    color: isSelected ? primaryBlue : Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedFeatures.add(feature);
                      } else {
                        selectedFeatures.remove(feature);
                      }
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: featureController,
                    decoration: InputDecoration(
                      hintText: 'Add custom feature',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                    ),
                    onSubmitted: _addFeature,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _addFeature(featureController.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 18,
                    ),
                  ),
                  child: const Icon(Icons.add, size: 24, color: Colors.white),
                ),
              ],
            ),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  'Save Property',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField(
    String label, {
    TextEditingController? controller,
    TextInputType keyboard = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        cursorColor: Colors.blue,
        controller: controller,
        keyboardType: keyboard,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
        ),
      ),
    );
  }
}
