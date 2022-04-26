import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:waterdrop_supplier/services/location_service.dart';

import '../helper/widgets.dart';

class GoogleMapsScreen extends StatefulWidget {
  const GoogleMapsScreen({Key? key}) : super(key: key);

  @override
  _GoogleMapsScreenState createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends State<GoogleMapsScreen> {
  Completer<GoogleMapController> _controller = Completer();
  //Set<Marker> _markers = {};
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  Position? position;
  LatLng? markerPoint;

  @override
  void initState() {
    getCurrentLocation().then((value) async {
      print(position);
      markerPoint = LatLng(position!.latitude, position!.longitude);
      await  _goToMyLocation();
    });
    // TODO: implement initState
    super.initState();
  }

  void getMarkers(double lat, double long){
    print(lat);
    print(long);
    markerPoint = LatLng(lat, long);
    MarkerId markerId = MarkerId(lat.toString() + long.toString());
    Marker marker = Marker(
      markerId: markerId,
      position: LatLng(lat, long),
      infoWindow: InfoWindow(snippet: 'Address')
    );
    _markers.clear();
    setState(() {
      _markers[markerId] = marker;
      print('@@@@@@@@@@@@@@@@@@@@@@2');
      print(_markers);
    });
  }


  Future<void> _goToMyLocation() async {
    final GoogleMapController controller = await _controller.future;
    print(position);
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(bearing: 192.8334901395799, target: LatLng(position!.latitude, position!.longitude),
        zoom: 19.151926040649414)));
  }

  Future<void> getCurrentLocation() async{
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    if(permission == LocationPermission.deniedForever){
      await Geolocator.requestPermission();
    }
    Position currentPosition = await GeolocatorPlatform.instance.getCurrentPosition();
    setState(() {
      position = currentPosition;
      getMarkers(position!.latitude, position!.longitude);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: const Text('Mark your store\'s location'),
        ),
      body: GoogleMap(
        myLocationEnabled: true,
        markers: Set<Marker>.of(_markers.values),
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: position == null ? LatLng(22.54, 88.36) : LatLng(position!.latitude.toDouble(), position!.longitude.toDouble()),
          zoom: 15
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          getMarkers(position!.latitude, position!.longitude);
        },
        onTap: (tapped) async {
          getMarkers(tapped.latitude, tapped.longitude);
        },
      ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: primaryColor,
          onPressed: (){
            Navigator.pop(context, markerPoint);
          },
          label: Text('Save Marker'),
          icon: Icon(Icons.location_on),
        ),
    );
  }
}
