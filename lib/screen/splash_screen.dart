import 'package:flutter/material.dart';
import 'package:geotagging/util/shared_pref.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  void navigationPage() {
    SharedPrefs.getBoolPref("isLogin").then(
        (val){
          if(val){
            Navigator.pushReplacementNamed(context,'/home');
          }else{
            Navigator.pushReplacementNamed(context,'/login');
          }
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Theme.of(context).primaryColor,
            width: MediaQuery.of(context).size.width,
            // margin: EdgeInsets.symmetric(horizontal: 20),
            // decoration: BoxDecoration(color: Colors.amber),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Container(
                    // child: new Image(image: AssetImage("image/logo.png"))),
                    child: new Text("GeoTagging"))
              ],
            )));
  }
}
