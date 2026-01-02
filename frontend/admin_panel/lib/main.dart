import 'package:admin_panel/database.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const GharrAdminApp());
}

class GharrAdminApp extends StatelessWidget {
  const GharrAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gharr Admin Panel',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 5, 110, 197),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 5, 110, 197),
        ),
      ),
      home: const AdminDashboard(),
    );
  }
}

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final List<Map<String, dynamic>> _pendingRequests = [
    {
      "firstName": "أحمد",
      "lastName": "السالم",
      "phone": "0933123456",
      "type": "Owner (صاحب شقة)",
      "dob": "1990-05-10",
      "profilePic": null,
      "idImage": null,
    },
    {
      "firstName": "رنا",
      "lastName": "العلي",
      "phone": "0944987654",
      "type": "Tenant (مستأجر)",
      "dob": "1995-12-20",
      "profilePic": null,
      "idImage": null,
    },
  ];

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("Select Language"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("English"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("العربية"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text(
              "Gharr Admin Panel",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                _showLanguageDialog(context);
              },
              child: const Text(
                "English",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      body: Row(
        children: [
          Container(
            width: 250,
            color: Colors.grey[100],
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Icon(
                  Icons.admin_panel_settings,
                  size: 80,
                  color: Color.fromARGB(255, 5, 110, 197),
                ),
                const Divider(),
                const ListTile(
                  leading: Icon(Icons.pending_actions),
                  title: Text("Registration requests"),
                  selected: true,
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Review new users' data",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _pendingRequests.length,
                      itemBuilder: (context, index) {
                        var user = _pendingRequests[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 15),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue[100],
                              child: Text(user['firstName'][0]),
                            ),
                            title: Text(
                              "${user['firstName']} ${user['lastName']}",
                            ),
                            subtitle: Text(
                              "phone number: ${user['phone']} | Type: ${user['type']}",
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () =>
                                      _showUserDetails(context, user),
                                  icon: const Icon(Icons.info_outline),
                                  label: const Text("All the information"),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                  onPressed: () async {
                                    await Database().setApprovalStatus(true);
                                    setState(
                                      () => _pendingRequests.removeAt(index),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        backgroundColor: Colors.green,
                                        content: Text(
                                          "Account approved and activated",
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "consent",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => setState(
                                    () => _pendingRequests.removeAt(index),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showUserDetails(BuildContext context, Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Registration file: ${user['firstName']} ${user['lastName']}",
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoRow(
                "full name:",
                "${user['firstName']} ${user['lastName']}",
              ),
              _infoRow("Phon Number:", user['phone']),
              _infoRow("date of birth:", user['dob']),
              _infoRow("Account type:", user['type']),
              const Divider(),
              const Text(
                "Personal photo:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Container(
                height: 150,
                width: double.infinity,
                color: Colors.grey[200],
                child: const Icon(Icons.person, size: 50, color: Colors.grey),
              ),
              const SizedBox(height: 15),
              const Text(
                "ID photo:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey[300],
                child: const Center(child: Text("Attached photo of ID")),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("closing"),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 10),
          Text(value),
        ],
      ),
    );
  }
}
