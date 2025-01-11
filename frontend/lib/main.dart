import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/pages/dash_home.dart';
import 'package:frontend/pages/login_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gemini/flutter_gemini.dart';

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
      initialRoute: '/home', // Set the initial route to LoginPage
      routes: {
        '/login': (context) => LoginPage(), // Login page route
        '/signup': (context) => SignUpPage(), // Sign-up page route
        '/home': (context) => DashHomePage() // Homepage
      },
    );
  }
}
