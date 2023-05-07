import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_vent/model/user/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UserService {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  final _auth = FirebaseAuth.instance;

  //Upload image
  Future<String> uploadImageUser(File image) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance.ref().child('profile/$fileName');
    UploadTask uploadTask = ref.putFile(File(image.path));
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  // Menambahkan user ke Firestore
  Future<void> addUser(
      {required String name,
      required String email,
      required String role,
      required String image}) async {
    User? user = _auth.currentUser;
    UserModel userModel = UserModel();
    userModel.email = email;
    userModel.name = name;
    userModel.uid = user!.uid;
    userModel.wrole = role;
    userModel.image = image;
    return await usersCollection
        .doc(user.uid)
        .set(userModel.toMap())
        .then((value) => print('User added'))
        .catchError((error) => print('Failed to add User: $error'));
  }

  // Mengupdate user di Firestore
  Future<void> updateUser(UserModel user) async {
    return await usersCollection
        .doc(user.uid)
        .update(user.toMap())
        .then((value) => print('User updated'))
        .catchError((error) => print('Failed to update event: $error'));
  }

  // Mengambil User
  Future<UserModel> getUserById(
      String id, var email, var role, String name, String image) {
    return usersCollection.doc(id).get().then((doc) {
      return UserModel.fromMap(doc);
    }).whenComplete(() {
      const CircularProgressIndicator();
      email = UserModel().email.toString();
      name = UserModel().name.toString();
      role = UserModel().wrole.toString();
      image = UserModel().image.toString();
      id = UserModel().uid.toString();
    });
  }
}
