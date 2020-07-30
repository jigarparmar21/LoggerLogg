import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class CRUD1 {
  bool checksignin() {
    if (FirebaseAuth.instance.currentUser() != null)
      return true;
    else
      return false;
  }
  
  Future<void> addData(signupdata, BuildContext context) async {
    if (checksignin()) {
      Firestore.instance.collection('user').add(signupdata).catchError((e) {
        print(e);
      });
    } else {
      final snackBar = SnackBar(content: Text('Please Do Login'));
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> adddata(data, BuildContext context,String coll) async {
    Firestore.instance.collection(coll).add(data).catchError((e) {
      print(e);
    });
  }

  getData(String table) async {
    return await Firestore.instance.collection(table).getDocuments();
  }

  updateData(selectedDoc, newValue,String coll) {
    Firestore.instance
        .collection(coll)
        .document(selectedDoc)
        .updateData(newValue)
        .catchError((e) {
      print(e);
    });
  
  }

  deleteData(docId,String coll) {
    Firestore.instance
        .collection(coll)
        .document(docId)
        .delete()
        .catchError((e) {
      print(e);
    });
  }

  deleteads(docId) {
    Firestore.instance
        .collection("sell car")
        .document(docId)
        .delete()
        .catchError((e) {
      print(e);
    });
  }

  deleterequest(docId) {
    Firestore.instance
        .collection("ride request")
        .document(docId)
        .delete()
        .catchError((e) {
      print(e);
    });
  }

  deletefavcar(docId) {
    Firestore.instance
        .collection("car fav")
        .document(docId)
        .delete()
        .catchError((e) {
      print(e);
    });
  }

  deleteintrestcar(docId) {
    Firestore.instance
        .collection("intrest request")
        .document(docId)
        .delete()
        .catchError((e) {
      print(e);
    });
  }
}
