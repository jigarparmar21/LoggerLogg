import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomePage.dart';
import 'Login_Page/loginpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String spe;
  spe = prefs.getString('email');
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: spe != null ? HomePage(email: spe) : LoginPage()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Test",
      home: SafeArea(
        child: Scaffold(
          body: LoginPage(),
        ),
      ),
    );
  }
}
