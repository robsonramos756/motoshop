import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'loginPage.dart';
import 'Feed.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MotoShop',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/feed': (context) => FeedPage(loggedIn: true),
      },
    );
  }
}
