import 'package:animated_card/animated_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Crud_File/crud1.dart';
import 'Login_Page/loginpage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.email ,this.currentTime}) : super(key: key);

  final String email,currentTime;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(DateTime.now());
  CRUD1 crudobj = new CRUD1();
  String logoutTime;
  QuerySnapshot user;

  void insert(BuildContext context) {

    Map<String, dynamic> data = {
      'email': widget.email,
      'loginTime':widget.currentTime.toString(),
      'logoutTime':logoutTime.toString()
    };
    crudobj.adddata(data, context,"Jigar_Data").then((result) {}).catchError((e) {
      print(e);
    }
    );
  }

  @override
  void initState() {
    crudobj.getData('Jigar_Data').then((result) {
      setState(() {
        user = result;
      });
    });
  }

  int l = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: appBar(),
      body: ListView(
        children: <Widget>[
          if (user != null)
            for (int i = 0; i < user.documents.length; i++)
              Column(
                children: <Widget>[
                  returnUser(i),
                ],
              ),
          Padding(padding: EdgeInsets.only(top: 250.0)),
          if (user == null)
            Column(
              children: <Widget>[
                Center(child: CircularProgressIndicator()),
              ],
            )
        ],
      ),
    ));
  }

  Widget appBar() {
    return AppBar(
      title: Text(widget.email),
      actions: <Widget>[
        FlatButton(
            onPressed: () async {
              logoutTime=formattedDate;
              await insert(context);
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('email');
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext ctx) => LoginPage(

                      )
                  ),
              );
            },
            child: Text('LogOut'),
        ),
      ],
    );
  }
  Widget returnUser(int i){
      if (user != null) {
          return Padding(
              padding: EdgeInsets.only(top: 2.0),
              child: AnimatedCard(
                  direction: AnimatedCardDirection.right,
                  initDelay: Duration(milliseconds: 5),
                  duration: Duration(seconds: 3),
                  child: Padding(
                    padding: const EdgeInsets.only(left:10.0,right: 10.0,top: 10.0),
                    child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20.0)),
                        child: ListTile(
                          leading: Icon(
                            Icons.account_circle,
                            size: 60.0,
                          ),
                          title: Text(
                            "${user.documents[i].data["email"]}"),
                          subtitle: Text("Login Time : "
                              "${user.documents[i].data["loginTime"]}\nLogOut Time : ${user.documents[i].data["logoutTime"]}",),
                        )
                    ),
                  )
              )
          );

      } else {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
  }


}
