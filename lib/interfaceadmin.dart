// ignore_for_file: camel_case_types, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';

class adminInt extends StatefulWidget {
  const adminInt({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<adminInt> createState() => _adminIntState();
}

class _adminIntState extends State<adminInt> {

  final _formKey = GlobalKey<FormState>();
  String stationId = DateTime.now().millisecondsSinceEpoch.toString();
  late double latitude;
  late double longitude;
  late double prixg;
  late double prixe;
  final TextEditingController _station = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Admin",
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

        body: Container(
            padding: const EdgeInsets.all(20),
            child:
            Stack(
                alignment: Alignment.center,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const SizedBox(
                          height: 80,
                        ),
                        const Text(
                          "Ajouter une position",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _station,
                                decoration: InputDecoration(
                                  hintText: 'Entrez le nom de la station',
                                  prefixIcon: const Icon(Icons.gas_meter),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      onChanged: (value) {
                                        setState(() {
                                          latitude = double.parse(value);
                                        });
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Latitude',
                                        prefixIcon: const Icon(Icons.place),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      onChanged: (value) {
                                        setState(() {
                                          longitude = double.parse(value);
                                        });
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Longitude',
                                        prefixIcon: const Icon(Icons.place),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              10),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    prixg = double.parse(value);
                                  });
                                },
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.price_check),
                                  hintText: 'Prix Gasoil',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    prixe = double.parse(value);
                                  });
                                },
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.price_check),
                                  hintText: 'Prix Essence',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      saveplaces();
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  padding:
                                  const EdgeInsets.fromLTRB(40, 15, 40, 15),
                                ),
                                child: const Text(
                                  'Ajouter',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ])
        )
    );
  }

  void saveplaces() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore.collection("stations").doc(stationId).set({
      'Nom station': _station.text,
      'Locations': GeoPoint(latitude, longitude),
      'Prix gasoil': prixg,
      'Prix essence': prixe,
    });
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginPage(title: 'Login UI'),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    const CircularProgressIndicator();
    await FirebaseAuth.instance.signOut();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const adminInt(title: 'admin UI'),
      ),
    );
  }
}
