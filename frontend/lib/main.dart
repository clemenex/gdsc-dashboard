import 'package:flutter/material.dart';
import 'package:frontend/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:frontend/pages/dash_home.dart';
import 'package:frontend/pages/sign_up_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  // await dotenv.load();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DashGov',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login', // Set the initial route to LoginPage
      routes: {
        '/login': (context) => LoginPage(), // Login page route
        '/signup': (context) => SignUpPage(), // Sign-up page route
        '/home': (context) => DashHomePage() // Homepage

      },
    );
  }
}

