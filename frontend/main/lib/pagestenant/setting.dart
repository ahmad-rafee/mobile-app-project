import 'dart:ui';

import 'package:flutter/material.dart';

class Setteing extends StatefulWidget {
  const Setteing({super.key});

  @override
  State<Setteing> createState() => _SetteingState();
}

class _SetteingState extends State<Setteing> {
  String userName = "Mohammad";
  String userEmail = "tenant@gmail.com";
  String userPhone = "+981454621";
  String userAddress = "Syria, Masyaf";


  void _showEditDialog() {
    TextEditingController nameController = TextEditingController(
      text: userName,
    );
    TextEditingController emailController = TextEditingController(
      text: userEmail,
    );
    TextEditingController phoneController = TextEditingController(
      text: userPhone,
    );
    TextEditingController addressController = TextEditingController(
      text: userAddress,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(backgroundColor: Colors.grey[300],
          title: const Text("Edit Profile"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Full Name"),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: "Phone"),
                ),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: "Address"),
                ),
              ],
            ),
          ),
          actions: [
            MaterialButton(
              onPressed: () => Navigator.pop(context),
              child:  Text("Cancel",style: TextStyle(color: Colors.blueAccent)),
            ),
           MaterialButton(
              onPressed: () {
                setState(() {
                  userName = nameController.text;
                  userEmail = emailController.text;
                  userPhone = phoneController.text;
                  userAddress = addressController.text;
                });
                Navigator.pop(context);
              },
              child:  Text("Save",style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text('tenant Profile'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey.shade200,
              child: const Icon(Icons.person, size: 60, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            Text(
              userName,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              userEmail,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 8),

            Text(
              userPhone,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 30),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _infoRow(
                      Icons.person_outline,
                      'Full Name',
                      userName,
                      Colors.blue,
                    ),
                    const Divider(height: 30),
                    _infoRow(
                      Icons.email_outlined,
                      'Email',
                      userEmail,
                      Colors.amber,
                    ),
                    const Divider(height: 30),
                    _infoRow(
                      Icons.phone_outlined,
                      'Phone',
                      userPhone,
                      Colors.blueGrey,
                    ),
                    const Divider(height: 30),
                    _infoRow(
                      Icons.location_on_outlined,
                      'Address',
                      userAddress,
                      Colors.redAccent,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      _showEditDialog();
                    },
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {},
                    child: Text(
                      'Change Password',
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 16),
        Text('$label:', style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(value, style: const TextStyle(color: Colors.black54)),
        ),
      ],
    );
  }
}
