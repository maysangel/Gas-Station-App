// ignore_for_file: avoid_print
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:station_app/NavBar.dart';
import 'package:station_app/bienvenue.dart';

class AdminMap extends StatefulWidget {
  const AdminMap({Key? key}) : super(key: key);
  @override
  State<AdminMap> createState() => _AdminMapState();
}

class _AdminMapState extends State<AdminMap> {
  final Completer<GoogleMapController> _controller = Completer();
  List<Marker> markers = [];

  int id = 1;

  @override
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () => showAlert(context));
    return SafeArea(
      child: Scaffold(
        drawer: const NavBar(),
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title:
          Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
            Text(
              "Gas Station Map",
              style: TextStyle(color: Colors.white),
            ),
          ]),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const bienvenu()));
              },
              icon: const Icon(Icons.arrow_forward_sharp),
            ),
          ],
        ),
        body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              trafficEnabled: true,
              compassEnabled: true,
              mapToolbarEnabled: true,
              onTap: (LatLng latlng) {
                Marker newMarker = Marker(
                  markerId: MarkerId('$id'),
                  position: LatLng(latlng.latitude, latlng.longitude),
                  icon: BitmapDescriptor.defaultMarkerWithHue(0),
                );
                markers.add(newMarker);
                id = id + 1;
                setState(() {});
                print("Vous avez taper sur $latlng");
              },
              initialCameraPosition: const CameraPosition(
                target: LatLng(33.971588, -6.849813),
                zoom: 14.4746,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: markers.map((e) => e).toSet(),
            ),
          ],
        ),
      ),
    );
  } // Widget
}

showAlert(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: const Text("Permission status"),
        content: const Text(
            "Vérification de la permission d'accès à la localisation."),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, checkPermission()),
            child: const Text('Vérifier'),
          ),
        ],
      );
    },
  );
}

Future<void> checkPermission() async {
  final serviceStatus = await Permission.locationWhenInUse.serviceStatus;
  final isGpsOn = serviceStatus == ServiceStatus.enabled;

  if (!isGpsOn) {
    print('Turn on location services before requesting permission.');
    return;
  }
  final status = await Permission.locationWhenInUse.request();

  if (status == PermissionStatus.granted) {
    print('Permission granted');
  } else if (status == PermissionStatus.denied) {
    print('Permission denied. Show a dialog and again ask for the permission');
  } else if (status == PermissionStatus.permanentlyDenied) {
    print('Take the user to the settings page.');
    await openAppSettings();
  }
}