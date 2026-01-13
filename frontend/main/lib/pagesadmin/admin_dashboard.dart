import 'package:flutter/material.dart';
import 'package:main/apiser.dart';
import 'package:main/pagesadmin/pending_users.dart';
import 'package:main/pagesadmin/pending_apartments.dart';
import 'package:main/pagesadmin/all_users.dart';
import 'package:main/pagesadmin/all_apartments.dart';
import 'package:main/information.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentIndex = 0;
  final Color _primaryColor = const Color(0xFF5E35B1); // Deep Purple
  final Color _lightColor = const Color(0xFFEDE7F6);

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      _DashboardHome(primaryColor: _primaryColor),
      const PendingUsersPage(),
      const PendingApartmentsPage(),
      const AllUsersPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _primaryColor,
        title: const Text('Admin Panel', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: _buildDrawer(),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: _primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.person_add), label: 'Pending Users'),
          BottomNavigationBarItem(icon: Icon(Icons.home_work), label: 'Pending Props'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'All Users'),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_primaryColor, _primaryColor.withOpacity(0.7)],
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.admin_panel_settings, size: 60, color: Colors.white),
                SizedBox(height: 10),
                Text('Admin Panel', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                Text('Manage System', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          _drawerItem(Icons.dashboard, 'Dashboard', () => setState(() => _currentIndex = 0)),
          _drawerItem(Icons.person_add, 'Pending Users', () => setState(() => _currentIndex = 1)),
          _drawerItem(Icons.home_work, 'Pending Properties', () => setState(() => _currentIndex = 2)),
          _drawerItem(Icons.people, 'All Users', () => setState(() => _currentIndex = 3)),
          _drawerItem(Icons.apartment, 'All Properties', () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AllApartmentsPage()));
          }),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () async {
              await ApiService.logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const MyLoginPage()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  ListTile _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: _primaryColor),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }
}

class _DashboardHome extends StatelessWidget {
  final Color primaryColor;

  const _DashboardHome({required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: ApiService.getAdminDashboardStats(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final data = snapshot.data?['data'] ?? {};
        final totalUsers = data['total_users'] ?? 0;
        final pendingUsers = data['pending_users'] ?? 0;
        final totalOwners = data['total_owners'] ?? 0;
        final totalTenants = data['total_tenants'] ?? 0;
        final totalApartments = data['total_apartments'] ?? 0;
        final pendingApartments = data['pending_apartments'] ?? 0;
        final approvedApartments = data['approved_apartments'] ?? 0;
        final rejectedApartments = data['rejected_apartments'] ?? 0;

        return RefreshIndicator(
          onRefresh: () async {
            // Trigger rebuild
            (context as Element).markNeedsBuild();
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('System Overview', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              
              // User Stats
              const Text('User Statistics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,
                children: [
                  _statCard('Total Users', totalUsers.toString(), Icons.people, Colors.blue),
                  _statCard('Pending Users', pendingUsers.toString(), Icons.person_add, Colors.orange),
                  _statCard('Owners', totalOwners.toString(), Icons.business, Colors.green),
                  _statCard('Tenants', totalTenants.toString(), Icons.person, Colors.purple),
                ],
              ),
              
              const SizedBox(height: 24),
              const Text('Property Statistics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,
                children: [
                  _statCard('Total Properties', totalApartments.toString(), Icons.home, Colors.indigo),
                  _statCard('Pending', pendingApartments.toString(), Icons.pending, Colors.amber),
                  _statCard('Approved', approvedApartments.toString(), Icons.check_circle, Colors.teal),
                  _statCard('Rejected', rejectedApartments.toString(), Icons.cancel, Colors.red),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
