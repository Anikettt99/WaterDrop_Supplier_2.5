/*
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:waterdrop_supplier/helper/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



class MapsScreen extends StatefulWidget {
  const MapsScreen({Key? key}) : super(key: key);

  @override
  _MapsScreenState createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  MapController mapController = MapController(
    initMapWithUserPosition: true,
    initPosition: GeoPoint(latitude: 22.564647063140946, longitude:  88.34337818696595),
  );
  ValueNotifier<GeoPoint?> lastGeoPoint = ValueNotifier(null);
  GeoPoint p = GeoPoint(latitude: 22.564647063140946, longitude:  88.34337818696595);

  @override
  void dispose() {
    // TODO: implement dispose
    mapController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Mark your store\'s location'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          OSMFlutter(
       //     isPicker: true,
            controller: mapController,
            mapIsLoading: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text('Map is Loading...'),
                ],
              ),
            ),
            initZoom: 15,
            minZoomLevel: 2,
            maxZoomLevel: 19,
            stepZoom: 1.0,

            //trackMyPosition: true,
            showDefaultInfoWindow: false,

            onLocationChanged: (myLocation) {
              print(myLocation);
            },
            onGeoPointClicked: (geoPoint) async {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    geoPoint.toMap().toString(),
                  ),
                  action: SnackBarAction(
                    onPressed: () => ScaffoldMessenger.of(context)
                        .hideCurrentSnackBar(),
                    label: 'hide',
                  ),
                ),
              );
            },
       //     staticPoints: [markers],
            markerOption: MarkerOption(
              defaultMarker: MarkerIcon(
                icon: const Icon(
                  Icons.person_pin_circle,
                  color: Colors.blue,
                  size: 56,
                ),
              ),
             // markerO: MarkerIcon(icon: Icon(Icons.location_on_sharp),),
            ),

          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: FlatButton(
                color: primaryColor,
                onPressed: () async {
                await mapController.advancedPositionPicker();
                p = await mapController.getCurrentPositionAdvancedPositionPicker();
                Navigator.pop(context, p);
              },
                child: Text('Save This Marker', style: TextStyle(color: Colors.white),),
              ),

            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.45,
            child: Icon(
              Icons.location_on_sharp,
              size: 30,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}




*/
