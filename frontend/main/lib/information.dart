import 'package:flutter/material.dart';
import 'package:main/gridv.dart';
import 'package:main/homesc.dart';
import 'package:main/signup.dart';

import 'database.dart';
//import 'package:main/HomeScreen.dart';

void main() {
  runApp(const Information());
}

class Information extends StatelessWidget {
  const Information({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "First App",

      home: MyLoginPage(),
    );
  }
}

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() {
    return _MyLoginPageState();
  }
}

class _MyLoginPageState extends State<MyLoginPage> {
  final TextEditingController _userTypeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _userTypeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext cotext) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 100),
            Container(
              margin: EdgeInsets.only(left: 45, bottom: 40),
              child: Row(
                children: [
                  SizedBox(
                    height: 80,
                    child: Image.asset('images/screen1(2).png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text(
                      "Gharr",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 33,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text(
                      "For",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 5, 110, 197),
                        fontWeight: FontWeight.bold,
                        fontSize: 33,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text(
                      ".Sale",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 33,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 45),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 20),
              child: Text(
                "Sign In",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFormField(
                cursorColor: Colors.black,
                controller: _userTypeController,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.person_outlined,
                    color: Colors.grey[600],
                  ),
                  hintText: 'Username',
                  hintStyle: TextStyle(color: Colors.grey[600]),
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
            ),

            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFormField(
                cursorColor: Colors.black,
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[600]),
                  hintText: "Password",
                  hintStyle: TextStyle(color: Colors.grey[600]),
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
            ),

            const SizedBox(height: 40),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 70),
              width: 200,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(23),
                ),
                padding: EdgeInsets.symmetric(vertical: 10),
                color: const Color.fromARGB(255, 5, 110, 197),
                onPressed: () async {
                  String username = _userTypeController.text.trim();
                  String password = _passwordController.text.trim();
                  if (username.isEmpty && password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please enter username and password"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  } else if (username.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please enter username"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  } else if (password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please enter password"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  await Database().login();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => gridv()),
                  );
                },
                child: Text(
                  "Sign In",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 98),
                  child: Text("Create a new account", style: TextStyle(fontSize: 10)),
                ),
                TextButton(style: ButtonStyle(overlayColor: WidgetStatePropertyAll(Colors.transparent)),
                  onPressed: () { Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => signup()));},
                  child: Text(
                    "Sign up",
                    style: TextStyle(color: const Color.fromARGB(255, 5, 110, 197), fontSize: 10),

                  ),

                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
