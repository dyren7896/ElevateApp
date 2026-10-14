import 'package:flutter/material.dart';
import 'package:myappren/splashscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
     title: 'ElevateApp',
     theme: ThemeData(
      primarySwatch: Colors.deepPurple,
     ),
     home: SplashScreen(),
    );
  }
}
