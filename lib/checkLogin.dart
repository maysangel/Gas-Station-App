// ignore_for_file: file_names, camel_case_types, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_typing_uninitialized_variables, avoid_print
import 'package:station_app/bienvenue.dart';
import 'model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'map.dart';


class checkLogin extends StatefulWidget {
  const checkLogin({Key? key}) : super(key: key);

  @override
  State<checkLogin> createState() => _checkLoginState();
}

class _checkLoginState extends State<checkLogin> {
  @override
  Widget build(BuildContext context) {
    return const contro();
  }
}

class contro extends StatefulWidget {
  const contro();

  @override
  _controState createState() => _controState();
}

class _controState extends State<contro> {
  _controState();
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  var role;
  var emaill;
  var id;
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users") //.where('uid', isEqualTo: user!.uid)
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
    }).whenComplete(() {
      const CircularProgressIndicator();
      setState(() {
        emaill = loggedInUser.email.toString();
        role = loggedInUser.role.toString();
        id = loggedInUser.uid.toString();

        print(id);
      });
    });
  }

  routing() {
    if (role != 'user') {
      return const bienvenu();
    } else {
      return const MyMap();
    }
  }

  @override
  Widget build(BuildContext context) {
    const CircularProgressIndicator();
    return routing();
  }
}
