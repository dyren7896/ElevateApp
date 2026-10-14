import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myappren/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    starSplashScreen();
  }

  starSplashScreen() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, (){
     Navigator.of(context).pushReplacement(
       MaterialPageRoute(builder: (context) => MyApp()),
     );
   });
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'assets/logo.jpg',
                width: 300.00,
                height: 300.0,
                fit:BoxFit.contain,
              ),
          ),
          SizedBox(
            height: 24.0,
          ),
        ],
      ),    
    );
  }
}
