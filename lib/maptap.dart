// ignore_for_file: avoid_print
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:station_app/ajouter.dart';
import 'package:station_app/bienvenue.dart';
import 'package:station_app/mapadmin.dart';

class MapTap extends StatefulWidget {
  const MapTap({Key? key}) : super(key: key);
  @override
  State<MapTap> createState() => _MapTapState();
}

class _MapTapState extends State<MapTap> {
  final Completer<GoogleMapController> _controller = Completer();
  List<Marker> markers = [];
  int id = 1;
  String stationId = DateTime.now().millisecondsSinceEpoch.toString();
  late double latitude;
  late double longitude;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController prixg = TextEditingController();
  final TextEditingController prixe = TextEditingController();
  final TextEditingController _station = TextEditingController();
  final TextEditingController _address = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 2, 35, 84),
            title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Gas Station Map",
                    style: TextStyle(color: Colors.white),
                  ),
                ]),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const bienvenu(),
                    ),
                  );
                },
                icon: const Icon(Icons.person),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const mapAdmin()));
                },
                icon: const Icon(Icons.map),
              ),
            ]),
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
                longitude = newMarker.position.longitude;
                latitude = newMarker.position.latitude;
                markers.add(newMarker);
                id = id + 1;
                setState(() {});
                print("Vous avez taper sur $latlng");
                showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      child: Container(
                        height: 500,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/font.jpg'),
                              fit: BoxFit.cover),
                        ),
                        padding: const EdgeInsets.all(15),
                        child:
                        Stack(alignment: Alignment.center, children: [
                          SingleChildScrollView(
                            child: Form(
                              key: _formKey,
                              child: Column(children: [
                                TextFormField(
                                  controller: _station,
                                  decoration: InputDecoration(
                                    hintText: 'Entrez Nom de la station',
                                    prefixIcon: const Icon(Icons.gas_meter),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: _address,
                                  decoration: InputDecoration(
                                    hintText:
                                    "Entrez l'adresse de la station",
                                    prefixIcon: const Icon(Icons.home),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: prixg,
                                  decoration: InputDecoration(
                                    prefixIcon:
                                    const Icon(Icons.price_check),
                                    hintText: 'Prix Gasoil',
                                    border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: prixe,
                                  decoration: InputDecoration(
                                    prefixIcon:
                                    const Icon(Icons.price_check),
                                    hintText: 'Prix Essence',
                                    border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        tapStation();
                                      });
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.fromLTRB(
                                        40, 15, 40, 15),
                                    shadowColor: Colors.white,
                                    primary: const Color.fromARGB(
                                        255, 242, 241, 245),
                                  ),
                                  child: const Text(
                                    'Ajouter',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        ]),
                      ),
                    ));
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

  void tapStation() async {
    final prixa = double.parse(prixe.text);
    final prixb = double.parse(prixg.text);
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore.collection("stations").doc(stationId).set({
      'nom station': _station.text,
      'adresse': _address.text,
      'locations': GeoPoint(latitude, longitude),
      'prix gasoil': prixb,
      'prix essence': prixa,
    }).whenComplete(() => Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ajoute(),
      ),
    ));
    // ignore: use_build_context_synchronously
  }
}