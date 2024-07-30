import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Feed.dart';
import 'google_sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignInService _googleSignInService = GoogleSignInService();

  Future<void> _login() async {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FeedPage(loggedIn: true)),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro no login')),
      );
    }
  }

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
        SnackBar(content: Text('Erro login')),
      );
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final UserCredential? userCredential = await _googleSignInService.signInWithGoogle();
      if (userCredential == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao logar sua conta do google')),
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
        SnackBar(content: Text('Erro ao logar com sua conta do google')),
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
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Senha'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            ElevatedButton(
              onPressed: _signInWithGoogle,
              child: Text('Login com Google'),
            ),
            ElevatedButton(
              onPressed: _signInAnonymously,
              child: Text('Acessar sem login'),
            ),
            SizedBox(height: 20.0),
            TextButton(
              onPressed: () {
                // Navegar para a tela de registro
              },
              child: Text('Não tem uma conta? Registre-se'),
            ),
          ],
        ),
      ),
    );
  }
}
