import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/pages/dash_home.dart';
import 'package:frontend/pages/login_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:frontend/pages/sign_up_page.dart';
import 'package:firebase_core/firebase_core.dart';

void streamPromptResponse(String prompt) {
  Gemini.instance.promptStream(parts: [
    Part.text(prompt),
  ]).listen((value) {
    if (value != null && value.output != null) {
      print(value.output);
    }
  }, onError: (error) {
    print('error in streaming: $error');
  }, onDone: () {
    print('streaming completed');
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: "lib/config/.env");
    final apiKey = dotenv.get('GEMINI_API_KEY');
    Gemini.init(apiKey: apiKey);
    print('Environment variables loaded successfully');
    print(dotenv.env['GEMINI_API_KEY']);
  } catch (e) {
    print('Error loading .env file: $e');
  }
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashHomePage(),
      initialRoute: '/login', // Set the initial route to LoginPage
      routes: {
        '/login': (context) => LoginPage(), // Login page route
        '/home': (context) => DashHomePage(), // Homepage
        '/signup': (context) => SignUpPage()
      },
    );
  }
}
