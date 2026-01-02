import 'package:flutter/material.dart';
import 'package:main/information.dart';
import 'package:main/homesc.dart';
import 'package:main/database.dart';
import 'package:main/pagestenant/note.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:main/pro1.dart';
import 'package:main/tenant.dart';
import 'package:main/pagesowner/views/dashboardview.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await NotificationsService.initialize();

  final db = Database();

  final bool firstTime = await db.isFirst();
  final bool loggedIn = await db.isLoggedIn();
  final String accountType = await db.getAccountType() ?? "user";

  runApp(
    MyApp(firstTime: firstTime, loggedIn: loggedIn, accountType: accountType),
  );
}

class MyApp extends StatelessWidget {
  final bool firstTime;
  final bool loggedIn;
  final String accountType;

  const MyApp({
    super.key,
    required this.firstTime,
    required this.loggedIn,
    required this.accountType,
  });

  @override
  Widget build(BuildContext context) {
    Widget start;

    if (firstTime) {
      start = const Pro1();
    } else if (loggedIn) {
      start = (accountType == "user") ? const tenant() : const DashboardView();
    } else {
      start = const Information();
    }

    return MaterialApp(debugShowCheckedModeBanner: false, home: start);
  }
}
