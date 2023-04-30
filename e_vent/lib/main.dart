import 'package:e_vent/firebase_options.dart';
import 'package:e_vent/screen/forgot_password/forgotpass_screen.dart';
import 'package:e_vent/screen/home_screen/home_service.dart';
import 'package:e_vent/screen/login/login_screen.dart';
import 'package:e_vent/screen/register/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xffF1511B),
        appBarTheme: const AppBarTheme(color: Color(0xffF1511B)),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const LoginPage(),
        '/register': (_) => const Register(),
        '/forgotpass': (_) => const Forgotpass(),
        '/homepage': (_) => const HomePage(),
      },
      //home: const LoginPage(),
    );
  }
}
