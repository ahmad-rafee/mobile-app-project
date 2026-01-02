import 'package:flutter/material.dart';
import 'package:main/chatModel/User_model.dart';
import 'package:main/database.dart';
import 'package:main/information.dart';
import 'package:main/pagesowner/controller/dashboar.dart';
import 'package:main/pagesowner/controller/dashboar.dart';
import 'package:main/pagesowner/views/about.dart';
import 'package:main/pagesowner/views/addpage.dart';
import 'package:main/pagesowner/views/meassage.dart';
import 'package:main/pagesowner/views/notiowner.dart';
import 'package:main/pagesowner/views/profile.dart';
import 'package:main/pagesowner/views/propeertypage.dart';

class DashboardView extends StatefulWidget {
  final User_model? user;

  const DashboardView({super.key, this.user});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final DashboardController controller = DashboardController();

  int currentIndex = 0;

  final Color primaryBlue = const Color(0xFF1E88E5);
  final Color lightBlue = const Color(0xFFE3F2FD);

  late final List<Widget> pages;

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.white,
          title: const Text("Choose language", textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Text("🇺🇸", style: TextStyle(fontSize: 20)),
                title: const Text("English"),
                onTap: () => Navigator.pop(context),
              ),
              const Divider(),
              ListTile(
                leading: const Text("🇸🇦", style: TextStyle(fontSize: 20)),
                title: const Text("العربية"),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    pages = [
      _DashboardBody(
        controller: controller,
        primaryBlue: primaryBlue,
        lightBlue: lightBlue,
        onNavigate: (index) => setState(() => currentIndex = index),
      ),
      const PropertiesPage(),
      const AddPropertyPage(),
      const MessagesPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: _buildAppBar(),
      drawer: _buildOwnerDrawer(),
      body: _animatedBody(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _animatedBody() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.08, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: SizedBox(key: ValueKey(currentIndex), child: pages[currentIndex]),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFFF7F9FC),
      centerTitle: true,
      title: Text(
        'Dashboard',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          letterSpacing: -0.4,
          color: primaryBlue,
        ),
      ),
      iconTheme: IconThemeData(color: primaryBlue),
      actions: [
        IconButton(
          icon: Icon(Icons.message_outlined, color: primaryBlue),
          onPressed: () => setState(() => currentIndex = 3),
        ),
      ],
    );
  }

  Drawer _buildOwnerDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryBlue, primaryBlue.withOpacity(0.85)],
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 30, color: Colors.blue),
                ),
                SizedBox(height: 12),
                Text(
                  'Owner Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'owner@gmail.com',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          _drawerItem(Icons.person_outline, 'Profile', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return OwnerProfilePage();
                },
              ),
            );
          }),
          _drawerItem(Icons.business_outlined, 'Business Info', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return BusinessInfoPage();
                },
              ),
            );
          }),
          _drawerItem(Icons.notifications_outlined, 'Notifications', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const OwnerNotificationsPage(),
              ),
            );
          }),
          _drawerItem(Icons.language_outlined, 'Language', () {
            _showLanguageDialog(context);
          }),
          _drawerItem(Icons.phone, 'Contact Us', () {}),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.redAccent),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    title: const Text("Logout"),
                    content: const Text("Are you sure you want to log out?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "exit",
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          Database db = Database();
                          await db.logout();

                          Navigator.of(context).pop();

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyLoginPage(),
                            ),
                            (route) => false,
                          );
                        },
                        child: const Text(
                          "Sure",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  ListTile _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: primaryBlue),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      currentIndex: currentIndex,
      selectedItemColor: primaryBlue,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),

      onTap: (index) => setState(() => currentIndex = index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.apartment_outlined),
          label: 'Properties',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          label: 'Add',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message_outlined),
          label: 'Messages',
        ),
      ],
    );
  }
}

class _DashboardBody extends StatelessWidget {
  final DashboardController controller;
  final Color primaryBlue;
  final Color lightBlue;
  final Function(int) onNavigate;

  const _DashboardBody({
    required this.controller,
    required this.primaryBlue,
    required this.lightBlue,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _header(),
        const SizedBox(height: 24),
        _stats(),
        const SizedBox(height: 30),
        _insights(),
        const SizedBox(height: 32),
        _recentActivity(),
      ],
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryBlue, primaryBlue.withOpacity(0.85)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.dashboard,
              color: Color.fromARGB(255, 5, 110, 197),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Dashboard Overview",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Monitor your properties & earnings",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stats() {
    final stats = [
      _Stat(
        'Properties',
        controller.totalProperties().toString(),
        Icons.apartment_outlined,
        1,
        const Color(0xFF1E88E5),
      ),
      _Stat(
        'Bookings',
        controller.totalBookings().toString(),
        Icons.book_online_outlined,
        1,
        const Color(0xFF43A047),
      ),
      _Stat(
        'Earnings',
        '\$${controller.totalEarnings()}',
        Icons.attach_money_outlined,
        2,
        const Color(0xFF8E24AA),
      ),
      _Stat(
        'Messages',
        '12',
        Icons.message_outlined,
        3,
        const Color(0xFFF4511E),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: stats.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) {
        final s = stats[index];
        return _proStatCard(s);
      },
    );
  }

  Widget _proStatCard(_Stat s) {
    return InkWell(
      onTap: () => onNavigate(s.page),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  s.title,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: s.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(s.icon, color: s.color, size: 20),
                ),
              ],
            ),

            const SizedBox(height: 14),

            TweenAnimationBuilder<int>(
              tween: IntTween(
                begin: 0,
                end: int.parse(s.value.replaceAll(RegExp(r'[^0-9]'), '')),
              ),
              duration: const Duration(milliseconds: 900),
              builder: (context, value, _) {
                return Text(
                  s.title == 'Earnings' ? '\$$value' : '$value',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                );
              },
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Icon(Icons.trending_up, size: 16, color: Colors.green),
                const SizedBox(width: 4),
                Text(
                  '+12% this month',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _insights() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb_outline, color: Colors.redAccent, size: 26),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              "Your earnings increased compared to last month. Consider adding more properties to maximize profit.",
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _recentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Recent Activity",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        _activityItem(
          Icons.apartment_outlined,
          'New property added',
          'Apartment in Dubai Marina',
          Colors.blue,
        ),
        _activityItem(
          Icons.book_online_outlined,
          'New booking received',
          'Booking #2341',
          Colors.green,
        ),
        _activityItem(
          Icons.attach_money_outlined,
          'Payment completed',
          '\$1,200 credited',
          Colors.purpleAccent,
        ),
      ],
    );
  }

  Widget _activityItem(
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: lightBlue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat {
  final String title;
  final String value;
  final IconData icon;
  final int page;
  final Color color;

  _Stat(this.title, this.value, this.icon, this.page, this.color);
}
