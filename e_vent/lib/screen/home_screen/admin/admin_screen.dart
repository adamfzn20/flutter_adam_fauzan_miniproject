import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/user/user_model.dart';
import '../../login/login_screen.dart';

class Admin extends StatefulWidget {
  String id;
  Admin({super.key, required this.id});
  @override
  State<Admin> createState() => _AdminState(id: id);
}

class _AdminState extends State<Admin> {
  String id;
  var role;
  var email;
  UserModel loggedInUser = UserModel();

  _AdminState({required this.id});

  late SharedPreferences logindata;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users") //.where('uid', isEqualTo: user!.uid)
        .doc(id)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
    }).whenComplete(() {
      const CircularProgressIndicator();
      setState(() {
        email = loggedInUser.email.toString();
        role = loggedInUser.wrole.toString();
        id = loggedInUser.uid.toString();
      });
    });
    initial();
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Admin",
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              logout(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(child: Text('Ini Home $email')),
    );
  }

  Future<void> logout(BuildContext context) async {
    const CircularProgressIndicator();
    await FirebaseAuth.instance.signOut();
    logindata.setBool('login', true);
    Navigator.pushReplacementNamed(context, '/');
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => LoginPage(),
    //   ),
    // );
  }
}
