import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
<<<<<<< HEAD
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load();
    print('Environment variables loaded successfully');
    print(dotenv.env['API_KEY']);
  } catch (e) {
    print('Error loading .env file: $e');
  }

=======
import 'package:frontend/pages/login_page.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load();
>>>>>>> 8d2d37d213c6f6d42010b203ca7c1907986ec2f0
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
