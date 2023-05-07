import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_vent/view/profile/screen/profile_edit_screen.dart';
import 'package:e_vent/view/widget/profile_list_item_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/user/user_model.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late User? user = FirebaseAuth.instance.currentUser;
  late UserModel loggedInUser = UserModel();
  late String? email;
  String? role;
  String? id;
  String? name;
  String? image;

  late SharedPreferences loginData;

  void initial() async {
    loginData = await SharedPreferences.getInstance();
  }

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
          const CircularProgressIndicator();
          loggedInUser = UserModel.fromMap(value.data()!);
          setState(() {
            email = loggedInUser.email.toString();
            role = loggedInUser.wrole.toString();
            id = loggedInUser.uid.toString();
            name = loggedInUser.name.toString();
            image = loggedInUser.name.toString();
          });
        }
      });
    }
    initial();
  }

  Future<void> _editUser() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProfileEditScreen(user: loggedInUser),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    const CircularProgressIndicator();
    await FirebaseAuth.instance.signOut();
    loginData.setBool('login', true);
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: id != null
          ? Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircleAvatar(
                      backgroundImage:
                          NetworkImage(loggedInUser.image.toString()),
                      radius: 60,
                    ),
                  ),
                  Text(name.toString()),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(email.toString()),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: _editUser,
                    child: const ProfileListItem(
                      icon: Icons.person,
                      text: 'Edit Profile',
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      logout(context);
                    },
                    child: const ProfileListItem(
                      icon: Icons.logout_rounded,
                      text: 'Logout',
                      hasNavigation: false,
                    ),
                  )
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
