import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geotagging/util/shared_pref.dart';
import 'package:geotagging/util/constant.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var latitude = "";
  var longitude = "";
  var username = "";
  var clockSignIn = "";
  var locationSignIn = "";
  var clockSignOut = "";
  var locationSignOut = "";
  @override
  void initState() {
    super.initState();
    checkPermmission();
    SharedPrefs.getStringPref("username").then((val){
      username = val ?? "";
    });
    SharedPrefs.getStringPref(Constant.getTodayDate()+"clockSignIn").then((val){
      clockSignIn = val ?? "";
    });
    SharedPrefs.getStringPref(Constant.getTodayDate()+"locationSignIn").then((val){
      locationSignIn = val ?? "";
    });
    SharedPrefs.getStringPref(Constant.getTodayDate()+"clockSignOut").then((val){
      clockSignOut = val ?? "";
    });
    SharedPrefs.getStringPref(Constant.getTodayDate()+"locationSignOut").then((val){
      locationSignOut = val ?? "";
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(Icons.map),
            onPressed: () {
              Navigator.pushNamed(context, "/map");
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(8),
          color: Theme.of(context).primaryColor,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(child: Text("Halo, $username"),)
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Text(
                  "Lokasi Saat Ini",
                  textAlign : TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                    ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(const Radius.circular(8)),
                  color: Theme.of(context).accentColor
                ),
                padding: EdgeInsets.all(8),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(child: Text("Latitude"),),
                        Expanded(child: Text(":"),),
                        Expanded(child: Text('$latitude'),)
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(child: Text("Longitude"),),
                        Expanded(child: Text(":"),),
                        Expanded(child: Text('$longitude'),)
                      ],
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(const Radius.circular(8)),
                  color: Theme.of(context).accentColor
                ),
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(child: Text("Jam Masuk"),),
                        Expanded(child: Text(":"),),
                        Expanded(child: Text('$clockSignIn'))
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(child: Text("Lokasi Masuk"),),
                        Expanded(child: Text(":"),),
                        Expanded(child: Text('$locationSignIn'),)
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(child: Text("Jam Keluar"),),
                        Expanded(child: Text(":"),),
                        Expanded(child: Text('$clockSignOut'),)
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(child: Text("Lokasi Keluar"),),
                        Expanded(child: Text(":"),),
                        Expanded(child: Text('$locationSignOut'),)
                      ],
                    )
                  ],
                ),
              ),
              RaisedButton(
                onPressed: () {
                  sign(latitude,longitude);
                },
                color: isSignColor(),
                child: Text(isSignText(), style: TextStyle(color: isSignTextColor()),),
              )
            ],
          )
        )
      );
  }

  isSignColor(){
    if(clockSignIn == ""){
      return Colors.blue[600];
    }else if (clockSignIn != "" && clockSignOut == ""){
      return Colors.blue[600];
    }else{
      return Theme.of(context).accentColor;
    }
  }

  isSignTextColor(){
    if(clockSignIn == ""){
      return Theme.of(context).accentColor;
    }else if (clockSignIn != "" && clockSignOut == ""){
      return Theme.of(context).accentColor;
    }else{
      return Theme.of(context).primaryColor;
    }
  }

  isSignText(){
    if(clockSignIn == ""){
      return "Sign In";
    }else if (clockSignIn != "" && clockSignOut == ""){
      return "Sign Out";
    }else{
      return "Disabled";
    }
  }

  getCurrentLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState((){
      latitude = position.latitude.toString();
      longitude = position.longitude.toString();
    });
  }

  sign(String latitude, String longitude){
    setState(() {
      if(clockSignIn != "" && clockSignOut == ""){
        SharedPrefs.storePref(Constant.getTodayDate()+"clockSignOut", Constant.getTimeNow());
        SharedPrefs.storePref(Constant.getTodayDate()+"locationSignOut",latitude + " " + longitude);
        clockSignOut = Constant.getTimeNow();
        locationSignOut = latitude + " " + longitude;
      }else if (clockSignIn == ""){
        SharedPrefs.storePref(Constant.getTodayDate()+"clockSignIn", Constant.getTimeNow());
        SharedPrefs.storePref(Constant.getTodayDate()+"locationSignIn",latitude + " " + longitude);
        clockSignIn = Constant.getTimeNow();
        locationSignIn = latitude + " " + longitude;  
      }else{
        print("action disabled");
      }
    });
  }

  grantPermission() async{
    final PermissionHandler _permissionHandler = PermissionHandler();
    var result = await _permissionHandler.requestPermissions([PermissionGroup.locationWhenInUse]);
    switch (result[PermissionGroup.locationWhenInUse]) {
      case PermissionStatus.granted:
        getCurrentLocation();
        break;
      case PermissionStatus.denied:
        // do something
        break;
      case PermissionStatus.disabled:
        // do something
        break;
      case PermissionStatus.restricted:
        // do something
        break;
      default:
    }
  }

  checkPermmission() async {
    final PermissionHandler _permissionHandler = PermissionHandler();
    var permissionStatus = await _permissionHandler.checkPermissionStatus(PermissionGroup.locationWhenInUse);
    switch (permissionStatus) {
      case PermissionStatus.granted:
        getCurrentLocation();
        break;
      case PermissionStatus.denied:
        grantPermission();
        break;
      default:
    }
  }
}