// ignore_for_file: file_names, camel_case_types
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class tabDistance extends StatefulWidget {
  const tabDistance(cont, {Key? key, required String title}) : super(key: key);

  @override
  State<tabDistance> createState() => _tabDistanceState();
}

class _tabDistanceState extends State<tabDistance> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        //child: _getData01(_userTransactionList, context)
        child: DataTable(
          columnSpacing: 30.0,
          columns: const <DataColumn>[
            DataColumn(
              label: Text(
                'Nom Station',
                style: TextStyle(
    color: Colors.blue,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
    ),
              ),
            ),
            DataColumn(
              label: Text(
                'Age',
                style: TextStyle(
    color: Colors.blue,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
    ),
              ),
            ),
          ],
          rows: const [],
        ),
    );
  }
}

getMarkerDistance() {
  FirebaseFirestore.instance.collection('stations').get().then(
          (QuerySnapshot querySnapshot) {
        // ignore: avoid_function_literals_in_foreach_calls
        querySnapshot.docs.forEach((doc) {
          calculDistance(doc.data(), doc.id);
        });
      });
}

calculDistance(specify,specifyId) async {
  Position currentPosition = await determinePosition();
  var markerIdVal = specifyId ;
  final MarkerId markerId = MarkerId(markerIdVal) ;
  final Marker marker = Marker(
    markerId : markerId ,
    position : LatLng (
        specify['locations'].latitude ,specify['locations'].longitude ),
    infoWindow: InfoWindow(
        title : specify['nom station']),
  );
  var lat = marker.position.latitude;
  var lng = marker.position.longitude;
  var nom = marker.infoWindow.title;
  var distanceInMeters = Geolocator.distanceBetween(
    lat, lng, currentPosition.latitude, currentPosition.longitude,
  );
  List<List<dynamic>> distances = [
    [nom , distanceInMeters],
  ];
  // ignore: avoid_print
  print(distances)  ;
}


Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled');  // Service disabled
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error("Location permission denied");  // Permission denied
    }
  }
  if (permission == LocationPermission.deniedForever) {
    return Future.error('Location permissions are permanently denied');
  }
  Position currentPosition = await Geolocator.getCurrentPosition();
  return currentPosition;
}
