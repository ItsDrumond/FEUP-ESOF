import 'package:findit_app/authentication/main_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:findit_app/firebase_options.dart';
import 'package:findit_app/pages/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  final prefs = await SharedPreferences.getInstance();
  final showLoginPage = prefs.getBool('showLoginPage') ?? false;
  
  runApp(MyApp(showLoginPage: showLoginPage));
}

class MyApp extends StatelessWidget {

  final bool showLoginPage;
  const MyApp({super.key, required this.showLoginPage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromRGBO(55, 8, 12, 1),
      ),
      home: showLoginPage ? const MainPage() : const LandingPage(),
    );
  }
}
