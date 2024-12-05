import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Feed.dart';
import 'google_sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignInService _googleSignInService = GoogleSignInService();

  Future<void> _signInAnonymously() async {
    try {
      await _auth.signInAnonymously();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FeedPage(loggedIn: false)),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao acessar sem login')),
      );
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final UserCredential? userCredential = await _googleSignInService.signInWithGoogle();
      if (userCredential == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao logar com a conta do Google')),
        );
        return;
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FeedPage(loggedIn: true)),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao logar com a conta do Google')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Login')),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElevatedButton(
              onPressed: _signInWithGoogle,
              child: Text('Login com Google'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _signInAnonymously,
              child: Text('Acessar sem login'),
            ),
          ],
        ),
      ),
    );
  }
}
