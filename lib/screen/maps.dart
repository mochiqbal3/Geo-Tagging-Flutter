import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class Map extends StatefulWidget {
  @override
  State<Map> createState() => MapState();
}

class MapState extends State<Map> {
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
    checkPermmission();
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

    _markers.add(Marker(
      markerId: MarkerId("currentLocation"),
      position: LatLng(currentLatitude,currentLongitude),
      onTap: (){
        showModalBottomSheet(
          context: context,
          builder: (context) => Container(
                color: Colors.red,
              ));
      }
    ));

    Future<void> _toCurrent(CameraPosition cameraPosition) async {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    }
    this.setState((){
      _currentLocation = CameraPosition(
        target: LatLng(currentLatitude,currentLongitude),
        zoom: 16,
      );
      _toCurrent(_currentLocation);
    });

    
    
    Set<Circle> circles = Set.from([Circle(
      circleId: CircleId("locationOffice"),
      center: LatLng(latitude, longitude),
      fillColor: Colors.transparent,
      strokeColor: Colors.blue[900],
      radius: 2000,
    )]);
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _currentLocation,
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
      currentLatitude = position.latitude;
      currentLongitude = position.longitude;
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