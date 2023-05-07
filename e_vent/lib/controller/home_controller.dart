import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/user/user_model.dart';
import '../view/widget/bottom_nav_admin_widget.dart';
import '../view/widget/bottom_nav_user_widget.dart';

class HomeController extends StatefulWidget {
  const HomeController({super.key});

  @override
  State<HomeController> createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {
  _HomeControllerState();
  @override
  Widget build(BuildContext context) {
    return const Control();
  }
}

class Control extends StatefulWidget {
  const Control({Key? key}) : super(key: key);

  @override
  State<Control> createState() => _ControlState();
}

class _ControlState extends State<Control> {
  _ControlState();
  late User? user = FirebaseAuth.instance.currentUser;
  late UserModel loggedInUser = UserModel();
  late String? email;
  var role;
  var id;

  @override
  void initState() {
    super.initState();
    if (user != null) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .get()
          .then((value) {
        if (value.exists) {
          loggedInUser = UserModel.fromMap(value.data()!);
          setState(() {
            email = loggedInUser.email.toString();
            role = loggedInUser.wrole.toString();
            id = loggedInUser.uid.toString();
          });
        }
      });
    }
  }

  Widget routing() {
    if (role == 'User') {
      return Users(
        id: id,
      );
    } else {
      return Admin(
        id: id,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: role != null ? routing() : const CircularProgressIndicator(),
      ),
    );
  }
}
