import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';


class afficherCarte extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return afficherCarteState();
  }

}

class afficherCarteState extends State<afficherCarte>{
  Completer <GoogleMapController>controller = Completer();
  Position? maPosition;


  Future<Position> determinerPosition() async {
    bool service;
    LocationPermission locationPermission;
    service = await Geolocator.isLocationServiceEnabled();
    if(!service){
      return Future.error("Nous n'avons pas accès à la localisation");
    }
    locationPermission = await Geolocator.checkPermission();
    if(locationPermission== LocationPermission.denied){
      locationPermission = await Geolocator.requestPermission();
      if(locationPermission== LocationPermission.denied){
        return Future.error("Nous n'avons pas accès à la localisation");
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    determinerPosition().then((value){
      setState(() {
        maPosition = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GoogleMap(
      initialCameraPosition:(maPosition==null)?CameraPosition(target:LatLng(48.858370,2.294481)):CameraPosition(target:LatLng(maPosition!.latitude,maPosition!.longitude)),
      onMapCreated: (GoogleMapController mapController) async {
        String style = await DefaultAssetBundle.of(context).loadString("lib/json/mapStyle.json");
        mapController.setMapStyle(style);
        controller.complete(mapController);
        },
      myLocationEnabled: true,
    );
  }

}