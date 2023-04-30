import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../login/login_screen.dart';

class Forgotpass extends StatefulWidget {
  const Forgotpass({Key? key}) : super(key: key);

  @override
  State<Forgotpass> createState() => _ForgotpassState();
}

class _ForgotpassState extends State<Forgotpass> {
  // bool showProgress = false;
  bool visible = false;
  final _auth = FirebaseAuth.instance;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()));
                              },
                              icon: const Icon(Icons.arrow_back),
                            ),
                          ],
                        ),
                        const Text(
                          'Lupa Password',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Image(
                            image: AssetImage('assets/forgot_pass.png')),
                        const SizedBox(
                          height: 30,
                        ),
                        const Text(
                            'Masukan email telah kamu daftarkan sebagai akun'),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color.fromARGB(255, 226, 226, 226),
                            hintText: 'Email',
                            enabled: true,
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 8.0, top: 15.0),
                            prefixIcon: const Icon(Icons.email_outlined),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value!.length == 0) {
                              return "Email cannot be empty";
                            }
                            if (!RegExp(
                                    "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                .hasMatch(value)) {
                              return ("Please enter a valid email");
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            // emailController.text = value!;
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        MaterialButton(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          elevation: 3.0,
                          height: 50,
                          minWidth: BouncingScrollSimulation
                              .maxSpringTransferVelocity,
                          onPressed: () {
                            Forgotpassss(emailController.text);
                            setState(() {
                              visible = true;
                            });
                          },
                          color: const Color(0xffF1511B),
                          textColor: Colors.white,
                          child: const Text(
                            "Submit",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   crossAxisAlignment: CrossAxisAlignment.end,
                        //   children: [
                        //     MaterialButton(
                        //       shape: RoundedRectangleBorder(
                        //           borderRadius: BorderRadius.all(
                        //               Radius.circular(20.0))),
                        //       elevation: 5.0,
                        //       height: 40,
                        //       onPressed: () {
                        //         Navigator.pushReplacement(
                        //             context,
                        //             MaterialPageRoute(
                        //                 builder: (context) => LoginPage()));
                        //       },
                        //       child: Text(
                        //         "Login",
                        //         style: TextStyle(
                        //           fontSize: 20,
                        //         ),
                        //       ),
                        //       color: Colors.white,
                        //     ),
                        //     MaterialButton(
                        //       shape: RoundedRectangleBorder(
                        //           borderRadius: BorderRadius.all(
                        //               Radius.circular(20.0))),
                        //       elevation: 5.0,
                        //       height: 40,
                        //       onPressed: () {
                        //         Forgotpassss(emailController.text);
                        //         setState(() {
                        //           visible = true;
                        //         });
                        //       },
                        //       child: Text(
                        //         "Ok",
                        //         style: TextStyle(
                        //           fontSize: 20,
                        //         ),
                        //       ),
                        //       color: Colors.white,
                        //     ),
                        //   ],
                        // ),
                        SizedBox(
                          height: 10,
                        ),
                        Visibility(
                            maintainSize: true,
                            maintainAnimation: true,
                            maintainState: true,
                            visible: visible,
                            child: Container(
                                child: CircularProgressIndicator(
                              color: Colors.white,
                            ))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void Forgotpassss(String email) async {
    if (_formkey.currentState!.validate()) {
      await _auth
          .sendPasswordResetEmail(email: email)
          .then((uid) => {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginPage()))
              })
          .catchError((e) {});
    }
  }
}
