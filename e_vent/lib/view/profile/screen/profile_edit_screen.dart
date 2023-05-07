import 'dart:io';

import 'package:e_vent/model/user/user_model.dart';
import 'package:e_vent/service/user_service.dart';
import 'package:e_vent/view/profile/screen/profile_screen.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEditScreen extends StatefulWidget {
  final UserModel user;

  const ProfileEditScreen({super.key, required this.user});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  late DateTime _date;
  bool _isLoading = false;

  File? _imageFile;
  String? imageUrl;
  final picker = ImagePicker();

  final userService = UserService();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.name!;
  }

  Future<void> _selectImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        if (kDebugMode) {
          print('No image selected.');
        }
      }
    });
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    if (_imageFile != null) {
      if (_imageFile!.lengthSync() > 2 * 1024 * 1024) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('File too large'),
              content: const Text('File size cannot exceed 2 MB'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          },
        );
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = true;
        });
        imageUrl = await userService.uploadImageUser(_imageFile!);
      }
    }

    final editedUser = UserModel(
      uid: widget.user.uid,
      email: widget.user.email,
      wrole: widget.user.wrole,
      name: _nameController.text,
      image: imageUrl ?? widget.user.image,
    );

    if (_isLoading == true) {
      await userService.updateUser(editedUser);
      Navigator.popAndPushNamed(context, '/homePage');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Color(0xffF1511B),
        ),
        title: const Text('Edit Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: _selectImage,
                child: _imageFile != null
                    ? ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        child: Image.file(
                          _imageFile!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        height: 200,
                        decoration: const BoxDecoration(
                          color: Color(0xffD9D9D9),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Image.network(
                          widget.user.image.toString(),
                          height: 200,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Name',
                  filled: true,
                  fillColor: const Color(0xffD9D9D9),
                  enabled: true,
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 15.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Tittle cannot be empty.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : MaterialButton(
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      elevation: 3.0,
                      height: 50,
                      minWidth:
                          BouncingScrollSimulation.maxSpringTransferVelocity,
                      onPressed: _submitForm,
                      color: const Color(0xffF1511B),
                      textColor: Colors.white,
                      child: const Text(
                        "Save",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
