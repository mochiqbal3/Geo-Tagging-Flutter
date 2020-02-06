import 'package:flutter/material.dart';
import 'package:geotagging/screen/splash_screen.dart';
import 'package:geotagging/screen/home.dart';
import 'package:geotagging/screen/login.dart';
import 'package:geotagging/screen/maps.dart';

void main() => runApp(MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.blue,
          accentColor: Color(0xFFf9f9fc),
          primaryColorDark: Colors.blue[900]),
      home: SplashScreen(),
      routes: {
        '/home': (context) => HomeScreen(),
        '/login': (context) => LoginPage(),
        '/map':(context) => Map()},
    ));