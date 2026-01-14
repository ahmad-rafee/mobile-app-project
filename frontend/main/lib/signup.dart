import 'package:flutter/material.dart';
import 'package:main/pagesowner/views/dashboardview.dart';
import 'package:main/pagestenant/hometenant.dart';
import 'package:main/tenant.dart';

import 'database.dart';
import 'homesc.dart';

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _SignupState();
}

class _SignupState extends State<signup> {
  String accountType = "tenant";
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _conpasswordController = TextEditingController();
  final TextEditingController _userTypeController = TextEditingController();
  bool _obscurePassword = true;
  @override
  void dispose() {
    _numberController.dispose();
    _passwordController.dispose();
    _conpasswordController.dispose();
    _userTypeController.dispose();
    super.dispose();
  }

  GlobalKey<FormState> pasword = GlobalKey<FormState>();

  //GlobalKey<FormState> conpasword = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
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
                "Sign Up",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
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
                keyboardType: TextInputType.number,
                cursorColor: Colors.black,
                controller: _numberController,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.phone_outlined,
                    color: Colors.grey[600],
                  ),
                  hintText: "Number",
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
            Form(
              key: pasword,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFormField(
                      validator: (val) {
                        if (val == null) {
                          return "error";
                        } else if (val.length < 8) {
                          return "The password must be 8 characters long.";
                        }
                        return null;
                      },
                      cursorColor: Colors.black,
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_outline),
                        hintText: "Password",
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey[600],
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
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
                      validator: (val) {
                        if (val == null) {
                          return "error";
                        } else if (val.length < 8) {
                          return "The password must be 8 characters long.";
                        } else if (val != _passwordController.text) {
                          return "The password must match the verification.";
                        }
                        return null;
                      },
                      cursorColor: Colors.black,
                      controller: _conpasswordController,
                      obscureText: _obscurePassword,

                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_outline),
                        hintText: "Confirm Password",
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
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
                ],
              ),
            ),
            const SizedBox(height: 40),
            Container(
              child: accountTypeSelector(
                selected: accountType,
                onChanged: (newValue) {
                  setState(() {
                    accountType = newValue;
                  });
                },
                context: context,
              ),
            ),
            const SizedBox(height: 20),
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
                  String number = _numberController.text.trim();
                  String passwordd = _conpasswordController.text.trim();
                  if (username.isEmpty &&
                      password.isEmpty &&
                      number.isEmpty &&
                      passwordd.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please enter the information"),
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
                  } else if (number.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please enter number"),
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
                  } else if (passwordd.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please enter confirm password"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  if (pasword.currentState!.validate()) {
                    // لا تقم بحفظ الداتا في قاعدة البيانات هنا Database().login()
                    // بل انتظر حتى الصفحة التالية لتسجيل المستخدم كاملاً

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => homesc(
                          accountType: accountType,
                          phoneNumber: _numberController.text, // نرسل الرقم
                          password: _passwordController.text,  // نرسل كلمة المرور
                        ),
                      ),
                    );
                  }
                },
                child: Text(
                  "Continue",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget accountTypeSelector({
    required String selected,
    required Function(String) onChanged,
    required BuildContext context,
  }) {
    return SegmentedButton<String>(
      segments: const [
        ButtonSegment(
          value: "tenant",
          label: Text("Tenant", style: TextStyle(color: Colors.black)),
          icon: Icon(Icons.person_outlined, color: Colors.black),
        ),
        ButtonSegment(
          value: "owner",
          label: Text("Owner", style: TextStyle(color: Colors.black)),
          icon: Icon(Icons.store, color: Colors.black),
        ),
      ],
      selected: {selected},
      onSelectionChanged: (value) {
        onChanged(value.first);
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color.fromARGB(255, 5, 110, 197);
          }
          return null;
        }),
      ),
    );
  }
}
