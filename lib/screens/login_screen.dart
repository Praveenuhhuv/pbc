import 'package:figma/api/api.dart';
import 'package:figma/helper/dialogs,dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:figma/main.dart';
import 'package:figma/screens/home_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimate = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isAnimate = true;
      });
    });
  }

  _handleGoogle() {
    _signInWithGoogle().then((user) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    });
  }

  Future<UserCredential> _signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  _handleLogin() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      Dialogs.showProgressBar(context); //show progress bar

      try {
        await APIs.auth
            .signInWithEmailAndPassword(email: email, password: password);
        Navigator.pop(context); //hide progress bar

        if (await APIs.userExists()) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        } else {
          Dialogs.showSnackbar(context, 'User not found.');
        }
      } catch (e) {
        Navigator.pop(context); //hide progress bar
        Dialogs.showSnackbar(context, 'Invalid email or password');
      }
    } else {
      Dialogs.showSnackbar(context, 'Please enter email and password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Figma icon at the top
            Center(
              child: Image.asset(
                'images/figma_icon.png',
                height: 60.0, // Adjust the size as needed
              ),
            ),
            SizedBox(height: 30.0),
            // Title
            Center(
              child: Text(
                'Sign in to Figma',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 30.0),
            // Google Sign-In Button
            ElevatedButton.icon(
              onPressed: () {
                _handleGoogle();
              },
              icon: Image.asset(
                'images/google_icon.png',
                height: 24.0,
              ),
              label: Text('Continue with Google'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.black, width: 1.0),
              ),
            ),
            SizedBox(height: 20.0),
            // OR Divider
            Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text('or'),
                ),
                Expanded(child: Divider()),
              ],
            ),
            SizedBox(height: 20.0),
            // Email TextField
            TextField(
              decoration: InputDecoration(
                labelText: 'EMAIL',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            // Password TextField
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'PASSWORD',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            // Login Button
            ElevatedButton(
              onPressed: () {},
              child: Text('Log in'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
              ),
            ),
            SizedBox(height: 20.0),
            // Links
            TextButton(
              onPressed: () {},
              child: Text('Use single sign-on'),
            ),
            TextButton(
              onPressed: () {},
              child: Text('Reset password'),
            ),
            SizedBox(height: 10.0),
            // Create account link
            Center(
              child: TextButton(
                onPressed: () {},
                child: Text('No account? Create one'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
