import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/pages/dash_home.dart';
import 'package:frontend/pages/login_page.dart';
import 'package:http/http.dart' as http;

void main() {
  // WidgetsFlutterBinding.ensureInitialized();

  // try {
  //   await dotenv.load(fileName: "lib/config/.env");
  //   print('Environment variables loaded successfully');
  //   print(dotenv.env['GEMINI_API_KEY']);
  // } catch (e) {
  //   print('Error loading .env file: $e');
  // }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashHomePage(),
    );
  }
}
