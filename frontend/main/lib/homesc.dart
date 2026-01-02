import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:main/chatModel/User_model.dart';
import 'package:main/database.dart';
import 'package:main/pagesowner/views/dashboardview.dart';
import 'package:main/tenant.dart';

import 'gridv.dart';

class homesc extends StatefulWidget {
  final String accountType;
  final String phoneNumber;
  final String password;

  const homesc({
    super.key,
    required this.accountType,
    required this.phoneNumber,
    required this.password,
  });

  @override
  State<homesc> createState() => _HomescState();
}

class _HomescState extends State<homesc> {
  File? imageFile;
  final TextEditingController fNameController = TextEditingController();
  final TextEditingController lNameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  void _showOption(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[200],
        title: const Text("Make a Choice"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text("Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _imageFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () {
                  Navigator.pop(context);
                  _imageFromCamera();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _imageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imageFile = File(image.path);
      });
    }
  }

  Future<void> _imageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        imageFile = File(image.path);
      });
    }
  }

  DateTime? selectedDate;
  File? idImageFile;

  void _showDatePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SizedBox(
          height: 300,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: DateTime(2000, 1, 1),
            minimumYear: 1950,
            maximumYear: DateTime.now().year,
            onDateTimeChanged: (DateTime newDate) {
              setState(() {
                selectedDate = newDate;
              });
            },
          ),
        );
      },
    );
  }

  Future<void> _imageIdFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        idImageFile = File(image.path);
      });
    }
  }

  Future<void> _imageIdFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        idImageFile = File(image.path);
      });
    }
  }

  void _showIdOption(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Select ID Image"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text("Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _imageIdFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () {
                  Navigator.pop(context);
                  _imageIdFromCamera();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 90, top: 20),
              child: Row(
                children: [
                  SizedBox(
                    height: 50,
                    child: Image.asset('images/screen1(2).png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 35),
                    child: Text(
                      "Gharr",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 35),
                    child: Text(
                      "For",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 35),
                    child: Text(
                      ".Sale",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => _showOption(context),
              child: CircleAvatar(
                radius: 90,
                backgroundColor: Colors.grey[300],
                backgroundImage: imageFile != null
                    ? FileImage(imageFile!)
                    : null,
                child: imageFile == null
                    ? const Icon(
                        Icons.camera_alt,
                        size: 40,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              cursorColor: Colors.black,
              controller: fNameController,
              decoration: InputDecoration(
                hintText: 'FirstName',
                hintStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
                filled: true,
                fillColor: Color.fromRGBO(245, 245, 245, 0.842),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 10.0,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              cursorColor: Colors.black,
              controller: lNameController,
              decoration: InputDecoration(
                hintText: 'LastName',
                hintStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
                filled: true,
                fillColor: Color.fromRGBO(245, 245, 245, 0.842),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 10.0,
                ),
              ),
            ),
            const SizedBox(height: 10),

            GestureDetector(
              onTap: () => _showDatePicker(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(245, 245, 245, 0.842),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDate == null
                          ? "Select Date of Birth"
                          : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Icon(
                      Icons.calendar_month,
                      color: Color.fromARGB(255, 5, 110, 197),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text("Upload ID", style: TextStyle(fontSize: 14)),
            GestureDetector(
              onTap: () => _showIdOption(context),
              child: Container(
                height: 200,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                  image: idImageFile != null
                      ? DecorationImage(
                          image: FileImage(idImageFile!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: idImageFile == null
                    ? const Icon(
                        Icons.credit_card,
                        size: 40,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 10),
            MaterialButton(
              color: const Color.fromARGB(255, 5, 110, 197),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(23),
              ),

              onPressed: () async {
                if (imageFile == null ||
                    fNameController.text.isEmpty ||
                    lNameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text("Please fill all data"),
                    ),
                  );
                  return;
                }
                Database db = Database();
                await db.login();
                await db.saveAccountType(widget.accountType);
                await db.isNotFirst();

                User_model currentUser = User_model(
                  id: widget.phoneNumber,
                  name: "${fNameController.text} ${lNameController.text}",
                  email: "email@example.com",
                  pass: widget.password,
                  image: imageFile!.path,
                );

                if (widget.accountType == "user") {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => tenant(user: currentUser),
                    ),
                  );
                } else {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => DashboardView(user: currentUser),
                    ),
                  );
                }
              },
              child: const Text(
                "Sign up",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
