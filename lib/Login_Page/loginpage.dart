import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../Crud_File/crud1.dart';
import '../FirstPage.dart';
import '../HomePage.dart';

void main() {
  runApp(LoginPage());
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  FirstPageeState ob1 = new FirstPageeState();
  CRUD1 crudobj = new CRUD1();
  final formKey = GlobalKey<FormState>();
  String lic, rc, model;

  bool size = false;

  String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(DateTime.now());

  String _email;
  FormType _formType = FormType.login;
  String _password;
  bool _toggleVisibility = true;
  bool isLoading = true;
  LoginPage ob;

  @override
  Widget build(BuildContext context) {
    final _font = (size) ? 14 : 14;
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.blue,
          resizeToAvoidBottomPadding: false,
          body: ListView(
            children: <Widget>[
              Form(key: formKey, child: mainLayout()),
            ],
          ),
      ),
    );
  }

  //Main Layout
  Widget mainLayout() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top:100.0),
          child: Text('LoggerLogg',style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right:35.0,left: 35.0,top: 10),
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.white,fontSize: 18),
            decoration: InputDecoration(
              labelStyle: TextStyle(color: Colors.white,fontSize: 16),
                labelText: "Email",
            ),
//            border: Border.all(color: Colors.white,width: 2.0),
            validator: (value) => validateEmail(value),
            onSaved: (value) => _email = value,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right:35.0,left: 35.0,top: 10),
          child: TextFormField(
            style: TextStyle(color: Colors.white,fontSize: 18),
            decoration: InputDecoration(
              labelStyle: TextStyle(color: Colors.white,fontSize: 16),
              labelText: "Password",
              suffixIcon: Padding(
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 0),
                child: IconButton(
                  color: Colors.white,
                  onPressed: () {
                    setState(() {
                      _toggleVisibility = !_toggleVisibility;
                    });
                  },
                  icon: _toggleVisibility
                      ? Icon(Icons.visibility_off)
                      : Icon(Icons.visibility),
                ),
              ),
            ),
            obscureText: _toggleVisibility,
            onSaved: (value) => _password = value,
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
         Padding(
           padding: const EdgeInsets.all(20),
           child: InkWell(
              onTap: () {
                submit();

              },
              child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    'Log In',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600),)),
            ),
         ),
      ],
    );
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    form.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      setState(() {
        isLoading = true;
      });
      return false;
    }
  }

  void submit() async {
    bool v = true;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
      if (validateAndSave()) {
        if (_formType == FormType.login) {
          setState(() {
            isLoading = false;
          });
          FirebaseAuth.instance
              .signInWithEmailAndPassword(email: _email, password: _password)
              .then((user) {
            v = false;
            Navigator.pop(context);
            ob1.addStringToSF(_email);
            var route = new MaterialPageRoute(
              // builder: (BuildContext context) =>Home_page(email: _email, ),
              builder: (BuildContext context) => HomePage(
                email: _email,
                currentTime: formattedDate
              ),
            );
            Navigator.of(context).push(route);
          }).catchError((e) {
            setState(() {
              isLoading = true;
            });
            var alertDialog1 = AlertDialog(
              title: Text("Error"),
              content: Text("your email/password is wrong"),
            );
            showDialog(
                context: context,
                builder: (BuildContext context) => alertDialog1);
            print(e);
          });
        }
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = true;
      });
      var alertDialog = AlertDialog(
        title: Text("Oops,there is no internet connection"),
        content: Text("please switch on mobile data"),
      );

      showDialog(
          context: context, builder: (BuildContext context) => alertDialog);
    }
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.length == 0) {
      return 'Email can\'t be empty!';
    } else {
      if (!regex.hasMatch(value))
        return 'Enter Valid Email';
      else
        return null;
    }
  }
}
