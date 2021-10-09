import 'dart:async';
import 'package:flutter/material.dart';
import 'package:leland/Screens/HomeScreen.dart';
import 'package:leland/Screens/LoginScreen.dart';
import 'package:leland/Utils/Constant.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String userToken;

  @override
  void initState() {
    super.initState();
    startTime();
    getData();
  }

  startTime() async {
    var duration = new Duration(seconds: 3);
    return new Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => userToken == null || userToken == 'null' || userToken == '' ? LoginScreen() : HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xff2291FF),
        child: Center(
          child: Image.asset('assets/logo.png', height: 200, width: 200),
        ),
      ),
    );
  }

  Future getData() async {
    var user_token = await getPrefData(key: 'user_token');
    // print('user_token');
    // print(user_token);
    setState(() {
      userToken = user_token;
    });
  }
}
