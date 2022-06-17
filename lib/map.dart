// ignore_for_file: avoid_print
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' ;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart' ;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:station_app/NavBar.dart';
import 'package:station_app/login.dart';

class MyMap extends StatefulWidget {
  const MyMap({Key? key}) : super(key: key);
  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {

  Map <MarkerId,Marker> markers = <MarkerId,Marker> {} ;

  get cont => null;

  void initMarker (specify,specifyId) async {
    var markerIdVal = specifyId ;
    final MarkerId markerId = MarkerId(markerIdVal) ;
    final Marker marker = Marker(
      markerId : markerId ,
      position : LatLng (
          specify['locations'].latitude ,specify['locations'].longitude ) ,
      infoWindow : InfoWindow (
          title : specify['nom station'] ,
          snippet : specify['prix essence''prix gasoil']),
          icon: BitmapDescriptor.defaultMarkerWithHue(0) ,
    );
    setState(() {
      markers[markerId] = marker ;
    }) ;
  }

  getMarkerData() async {
    FirebaseFirestore.instance.collection('stations').get().then(
            (QuerySnapshot querySnapshot) {
          // ignore: avoid_function_literals_in_foreach_calls
          querySnapshot.docs.forEach((doc) {
            initMarker(doc.data(), doc.id);
          });
        });
  }

  @override
  void initState () {
    getMarkerData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () => showAlert(context));
    return SafeArea(
        child: Scaffold(
          drawer: const NavBar(),
      appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Gas Station Map",
                    style: TextStyle(color: Colors.white),
                  ),
                ]),
            actions: [
              IconButton(
                onPressed: () {
                  logout(context);
                },
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
          body: Stack (
          children: [
            GoogleMap(
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              trafficEnabled: true,
              compassEnabled: true,
              mapToolbarEnabled: true,
              initialCameraPosition: const CameraPosition(
                target: LatLng(33.971588, -6.849813),
                zoom: 14.4746,
              ),
              onMapCreated: (GoogleMapController controller)
              {},
              markers: Set<Marker>.of(markers.values) ,
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
          content: const Text("Vérification de la permission d'accès à la localisation."),
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


Future<void> logout(BuildContext context) async {
  const CircularProgressIndicator();
  await FirebaseAuth.instance.signOut();

  // ignore: use_build_context_synchronously
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => const LoginPage(title: 'admin UI'),
    ),
  );
}
