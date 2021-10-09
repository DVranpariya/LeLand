import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leland/Screens/HomeScreen.dart';
import 'package:leland/Screens/ProfileInformationScreen.dart';
import 'Utils/Constant.dart';
import 'Screens/SplashScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: kPrimaryColor, // status bar color
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leland T&M',
      theme: Theme.of(context).copyWith(
        appBarTheme: Theme.of(context).appBarTheme.copyWith(brightness: Brightness.light),
        accentColor: kPrimaryColor,
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        '/home': (context) => HomeScreen(),
        '/profile': (context) => ProfileInformationScreen(),
      },
    );
  }
}
