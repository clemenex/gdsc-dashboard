import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  LoginPage({super.key});

  Future<String?> _loginWithEmailAndPassword(LoginData data) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: data.name,
        password: data.password,
      );

      if (userCredential.user != null) {
        return ''; // Return empty string to indicate success
      }
    } catch (e) {
      return 'Login failed: ${e.toString()}'; // Return error message if login fails
    }
    return ''; // Ensure the method returns a String, even if no user is found.
  }

  Future<void> _loginWithGoogle(BuildContext context) async {
    try {
      GoogleSignInAccount? user = await _googleSignIn.signIn();

      if (user != null) {
        GoogleSignInAuthentication googleAuth = await user.authentication;
        OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await _auth.signInWithCredential(credential);

        // Navigate to home page
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google login failed: $error')),
      );
    }
  }

  Future<String?> _recoverPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null; // Indicate success
    } catch (e) {
      return 'Password recovery failed: ${e.toString()}'; // Return error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'DashGov',
      logo: null,
      theme: LoginTheme(
        primaryColor: Colors.red.shade200,
        titleStyle: TextStyle(
            fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
        //pageColorLight: Colors.white,
        //pageColorDark: Colors.blueAccent,
      ),
      onLogin: _loginWithEmailAndPassword,
      onRecoverPassword: _recoverPassword,
      onSignup: (SignupData data) async {
        // Handle sign-up logic
        return null;
      },
      onSubmitAnimationCompleted: () {
        Navigator.pushReplacementNamed(context, '/home');
      },
      headerWidget: Center(
          child: Lottie.asset('assets/book.json', width: 150, height: 150)),
    );
  }
}
