import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geotagging/util/connection.dart';
import 'package:geotagging/model/presence.dart';

class Map extends StatefulWidget {
  @override
  State<Map> createState() => MapState();
}

class MapState extends State<Map> {
  List<Presence> presences = [];
  Presence presence;
  double latitude = 0.0;
  double longitude = 0.0;
  double currentLatitude = 0.0;
  double currentLongitude = 0.0;
  Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};
  CameraPosition _currentLocation = CameraPosition(
    target: LatLng(0.7893,113.9213),
    zoom: 6,
  );
  @override
  void initState(){
    latitude = -6.905563;
    longitude = 107.603798;
    getListPresence();
  }
  showDetailModal({bool isSignIn = true}){
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        margin: EdgeInsets.all(16),
        child: Container(
          child: Column(
            children: <Widget>[
              Row(children: <Widget>[
                Expanded(child: Text("Username",
                style: TextStyle(
                  color: Colors.white
                ),),),
                Expanded(child: Text(":",style: TextStyle(
                  color: Colors.white
                )),),
                Expanded(child: Text(presence.username,style: TextStyle(
                  color: Colors.white
                )),)
              ],),
              Row(children: <Widget>[
                Expanded(child: Text(isSignIn ? "Sign In" : "Sign Out",style: TextStyle(
                  color: Colors.white
                )),),
                Expanded(child: Text(":",style: TextStyle(
                  color: Colors.white
                )),),
                Expanded(child: Text(isSignIn ? presence.signIn : presence.signOut,style: TextStyle(
                  color: Colors.white
                )),)
              ],),
              Row(children: <Widget>[
                Expanded(child: Text("Latitude",style: TextStyle(
                  color: Colors.white
                )),),
                Expanded(child: Text(":",style: TextStyle(
                  color: Colors.white
                )),),
                Expanded(child: Text(isSignIn ? presence.latSignIn.toString() : presence.latSignOut.toString(),style: TextStyle(
                  color: Colors.white
                )),)
              ],),
              Row(children: <Widget>[
                Expanded(child: Text("Longitude",style: TextStyle(
                  color: Colors.white
                )),),
                Expanded(child: Text(":",style: TextStyle(
                  color: Colors.white
                )),),
                Expanded(child: Text(isSignIn ? presence.longSignIn.toString() : presence.longSignOut.toString(),style: TextStyle(
                  color: Colors.white
                )),)
              ],)
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.blue[900],
            borderRadius: BorderRadius.all(
              Radius.circular(8)
          ),
        ),
        )
      ));
  }
  getListPresence() async{
    await ApiService()
      .getWithListResponse({}, "api/v1/Presence","").then((response) {
      if (response.status) {
        if (response.data != null) {
          var _presences = Presence.fromJsonList(response.data);
          this.setState(() {
            presences = _presences;
          });
          _presences.forEach((value) async{
            print(value.latSignIn.toString() + " " + value.longSignIn.toString());
            _markers.add(
              Marker(
                markerId: MarkerId(value.username+"signIn"),
                position: LatLng(value.latSignIn,value.longSignIn),
                onTap: (){
                  setState(() {
                    presence = value;
                  });
                  showDetailModal();
                }
              )
            );
            _markers.add(
              Marker(
                markerId: MarkerId(value.username+"signOut"),
                position: LatLng(value.latSignOut,value.longSignOut),
                onTap: (){
                  setState(() {
                    presence = value;
                  });
                  showDetailModal(isSignIn: false);
                }
              )
            );
          });
        }
      } else {
        print("error ");
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final CameraPosition _office = CameraPosition(
      target: LatLng(latitude,longitude),
      zoom: 14);

    Future<void> _toOffice() async {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(_office));
    }

    
    

    Future<void> _toCurrent(CameraPosition cameraPosition) async {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    }
    this.setState((){
      _currentLocation = CameraPosition(
        target: LatLng(currentLatitude,currentLongitude),
        zoom: 14,
      );
    });

    
    
    Set<Circle> circles = Set.from([Circle(
      circleId: CircleId("locationOffice"),
      center: LatLng(latitude, longitude),
      fillColor: Colors.transparent,
      strokeColor: Colors.blue[900],
      radius: 2000,
    )]);
    return new Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ), 
        title: Text("Maps Picker"),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _office,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: _markers,
        circles: circles,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _toOffice,
        label: Text('To office!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  getCurrentLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState((){
      currentLatitude = position.latitude ?? 0;
      currentLongitude = position.longitude ?? 0;
      
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