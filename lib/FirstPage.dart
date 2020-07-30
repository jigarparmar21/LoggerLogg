import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login_Page/loginpage.dart';
class FirstPagee extends StatefulWidget {
  @override
  FirstPageeState createState() => FirstPageeState();
}

class FirstPageeState extends State<FirstPagee> {
  @override
  void initState() {
    super.initState();
    new Future.delayed(
        const Duration(seconds: 4),
            () =>
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            ));
  }
  addStringToSF(String e) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email',e);

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        body:Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(width: 20.0, height: 100.0),

            ],
          ),
        )
    );
  }
}