import 'package:e_vent/controller/home_controller.dart';
import 'package:e_vent/firebase_options.dart';
import 'package:e_vent/view/admin/provider/event_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:e_vent/view/aunt/screen/forgotpass_screen.dart';
import 'package:e_vent/view/aunt/screen/login_screen.dart';
import 'package:e_vent/view/aunt/screen/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EventProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: GoogleFonts.roboto().fontFamily,
          colorSchemeSeed: const Color(0xffF1511B),
          scaffoldBackgroundColor: const Color(0xffF6F6F6),
          appBarTheme: const AppBarTheme(
            color: Colors.white,
            titleTextStyle: TextStyle(
              color: Color(0xffF1511B),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (_) => const LoginPage(),
          '/register': (_) => const Register(),
          '/forgotPass': (_) => const ForgotPass(),
          '/homePage': (_) => const HomeController(),
        },
        //home: const LoginPage(),
      ),
    );
  }
}
