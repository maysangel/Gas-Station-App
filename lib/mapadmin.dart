// ignore_for_file: avoid_print, camel_case_types
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:station_app/NavBar.dart';
import 'package:station_app/bienvenue.dart';
import 'package:station_app/login.dart';

class mapAdmin extends StatefulWidget {
  const mapAdmin({Key? key}) : super(key: key);

  @override
  State<mapAdmin> createState() => _mapAdminState();
}

class _mapAdminState extends State<mapAdmin> {
  int selectedIndex = 0;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void initMarker(specify, specifyId) async {
    var es = specify['prix essence'].toString();
    var gs = specify['prix gasoil'].toString();
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      markerId: markerId,
      position:
      LatLng(specify['locations'].latitude, specify['locations'].longitude),
      infoWindow: InfoWindow(
          title: specify['nom station'],
          snippet : "Essence: $es - Gasoil: $gs"),
      icon: BitmapDescriptor.defaultMarkerWithHue(0),
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  getMarkerData() async {
    FirebaseFirestore.instance
        .collection('stations')
        .get()
        .then((QuerySnapshot querySnapshot) {
      // ignore: avoid_function_literals_in_foreach_calls
      querySnapshot.docs.forEach((doc) {
        initMarker(doc.data(), doc.id);
      });
    });
  }

  @override
  void initState() {
    getMarkerData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () => showDialogIfFirstLoaded(context));
    return SafeArea(
      child: Scaffold(
        drawer: const NavBar(),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 2, 35, 84),
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
              icon: const Icon(Icons.person),
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
              initialCameraPosition: const CameraPosition(
                target: LatLng(33.971588, -6.849813),
                zoom: 14.4746,
              ),
              onMapCreated: (GoogleMapController controller) {},
              markers: Set<Marker>.of(markers.values),
            ),
          ],
        ),
      ),
    );
  }
}

showDialogIfFirstLoaded(BuildContext context) async {
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