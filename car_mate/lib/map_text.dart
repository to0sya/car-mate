import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? gasController;
  GoogleMapController? parkingController;
  GoogleMapController? washingController;


  Set<Marker> _gasStationMarkers = {};
  Set<Marker> _parkingMarkers = {};
  Set<Marker> _washingStationsMarkers = {};



  void _onGasMapCreate(GoogleMapController controller) {
    gasController = controller;
    _determinePosition(gasController, "азс", 10, _gasStationMarkers);
  }

  void _onParkingMapCreate(GoogleMapController controller) {
    parkingController = controller;
    _determinePosition(parkingController, "паркінг", 10, _parkingMarkers);
  }

  void _onWashingMapCreate(GoogleMapController controller) {
    washingController = controller;
    _determinePosition(washingController, "автомийка", 10, _washingStationsMarkers);
  }

  Future<void> _determinePosition(GoogleMapController? controller, String keyword, int count, Set<Marker> markers) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        return Future.error('Location permissions are denied (actual value: $permission).');
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    LatLng currentLocation = LatLng(position.latitude, position.longitude);
    controller?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: currentLocation,
        zoom: 14.0,
      ),
    ));
    _findPlaces(keyword, currentLocation, count, markers);
  }
 // азс, автомийка, паркінг 10

  Future<void> _findPlaces(String keyword, LatLng near, int count, Set<Marker> markers) async {
    const String baseUrl =
        "https://maps.googleapis.com/maps/api/place/textsearch/json";
    const String apiKey = "AIzaSyDmGlUtfWUmS67O12AV_-HfrR-LBNlOvQY";
    final response = await http.get(Uri.parse("$baseUrl?query=$keyword&location=${near.latitude},${near.longitude}&radius=5&key=$apiKey"));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      markers.clear();

      for (var place in data['results'].take(count)) {
        LatLng latLng = LatLng(place['geometry']['location']['lat'], place['geometry']['location']['lng']);
        markers.add(
          Marker(
            markerId: MarkerId(place['place_id']),
            position: latLng,
            infoWindow: InfoWindow(title: place['name'], snippet: place['formatted_address']),
          ),
        );
        setState(() {});
      }
    } else {
      throw Exception('Failed to load places');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(35, 0, 30, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Gas Station", style: TextStyle(fontFamily: 'AudiWideNormal', fontSize: 20)),
              Container(
                width: 320,
                height: 200,
                color: Colors.white,
                child: GoogleMap(
                  onMapCreated: _onGasMapCreate,
                  markers: _gasStationMarkers,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(0,0),
                    zoom: 15.0,
                  ),
                  zoomControlsEnabled: false,
                ),
              ),
              const SizedBox(height: 30.0),
              Text("Parking", style: TextStyle(fontFamily: 'AudiWideNormal', fontSize: 20)),
              Container(
                width: 320,
                height: 200,
                color: Colors.white,
                child: GoogleMap(
                  onMapCreated: _onParkingMapCreate,
                  markers: _parkingMarkers,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(0,0),
                    zoom: 15.0,
                  ),
                  zoomControlsEnabled: false,

                ),

              ),
              const SizedBox(height: 30.0),
              Text("Washing Station", style: TextStyle(fontFamily: 'AudiWideNormal', fontSize: 20)),
              Container(
                width: 320,
                height: 200,
                color: Colors.white,
                child: GoogleMap(
                  onMapCreated: _onWashingMapCreate,
                  markers: _washingStationsMarkers,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(0,0),
                    zoom: 15.0,
                  ),
                  zoomControlsEnabled: false,
                ),
              ),
              const SizedBox(height: 30.0),
              /*GoogleMap(
              onMapCreated: _onMapCreated,
              markers: _markers,
              initialCameraPosition: CameraPosition(
                target: LatLng(0,0),
                zoom: 15.0,
              ),
            ),*/
            ],
          ),
        )
      )

    );
  }
}
