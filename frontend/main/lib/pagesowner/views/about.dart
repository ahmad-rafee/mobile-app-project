import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BusinessInfoPage extends StatefulWidget {
  const BusinessInfoPage({super.key});

  @override
  State<BusinessInfoPage> createState() => _BusinessInfoPageState();
}

class _BusinessInfoPageState extends State<BusinessInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _registrationNumberController =
      TextEditingController();
  final TextEditingController _taxIdController = TextEditingController();
  final TextEditingController _ibanController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? _crImage;
  File? _idImage;

  Future<void> _pickImage(bool isCr) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        if (isCr) {
          _crImage = File(image.path);
        } else {
          _idImage = File(image.path);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Business Information',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Legal Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 5, 110, 197),
                ),
              ),
              const SizedBox(height: 15),

              _buildTextField(
                label: 'Business Legal Name',
                controller: _businessNameController,
                icon: Icons.business,
                hint: 'e.g. Al-Nile Real Estate Co.',
              ),
              _buildTextField(
                label: 'Commercial Registration (CR)',
                controller: _registrationNumberController,
                icon: Icons.assignment_outlined,
                hint: 'Enter your CR number',
                isNumber: true,
              ),
              _buildTextField(
                label: 'Tax ID / VAT Number',
                controller: _taxIdController,
                icon: Icons.receipt_long,
                hint: 'Enter tax registration number',
                isNumber: true,
              ),

              const SizedBox(height: 20),
              const Text(
                'Bank Account (Payouts)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 5, 110, 197),
                ),
              ),
              const SizedBox(height: 15),

              _buildTextField(
                label: 'IBAN Number',
                controller: _ibanController,
                icon: Icons.account_balance_wallet,
                hint: 'e.g. SA 0000 0000 ...',
              ),

              const SizedBox(height: 20),
              const Text(
                'Official Documents',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 5, 110, 197),
                ),
              ),
              const SizedBox(height: 15),

              _buildUploadTile(
                'Commercial Register Image',
                Icons.file_upload_outlined,
                _crImage,
                () => _pickImage(true),
              ),
              _buildUploadTile(
                'Owner Identity (ID/Passport)',
                Icons.badge_outlined,
                _idImage,
                () => _pickImage(false),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: MaterialButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Information saved successfully!'),
                        ),
                      );
                    }
                  },
                  color: const Color.fromARGB(255, 5, 110, 197),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Save Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: const Color.fromARGB(255, 5, 110, 197)),
          filled: true,
          fillColor: Colors.grey[100],
          border: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
        validator: (value) =>
            (value == null || value.isEmpty) ? 'Please enter $label' : null,
      ),
    );
  }

  Widget _buildUploadTile(
    String title,
    IconData icon,
    File? imageFile,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              imageFile == null ? title : "File Selected ✔",
              style: TextStyle(
                color: imageFile == null ? Colors.black87 : Colors.green,
                fontWeight: imageFile == null
                    ? FontWeight.normal
                    : FontWeight.bold,
              ),
            ),
          ),
          if (imageFile != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                imageFile,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
          TextButton(
            onPressed: onTap,
            child: Text(
              imageFile == null ? 'Upload' : 'Change',
              style: const TextStyle(color: Color.fromARGB(255, 5, 110, 197)),
            ),
          ),
        ],
      ),
    );
  }
}
