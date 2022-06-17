// ignore_for_file: camel_case_types
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:station_app/bienvenue.dart';
import 'package:station_app/main.dart';
import 'package:station_app/mapadmin.dart';

class affichage extends StatefulWidget {
  const affichage({Key? key}) : super(key: key);

  @override
  State<affichage> createState() => _affichageState();
}

class _affichageState extends State<affichage> {
  final _formKey = GlobalKey<FormState>();
  List stationslist = [];
  final TextEditingController prixg = TextEditingController();
  final TextEditingController prixe = TextEditingController();
  final TextEditingController _station = TextEditingController();
  final TextEditingController _address = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 246, 247, 248),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 2, 35, 84),
        title:
        Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
          Text(
            "Vos Stations",
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
                setState(() {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const mapAdmin(),
                    ),
                  );
                });
              },
              icon: const Icon(Icons.map)),
        ],
      ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('stations').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var doc = snapshot.data!.docs[index];
                  return Container(
                      padding: const EdgeInsets.all(5.0),
                      child: Material(
                        elevation: 4.0,
                        borderRadius: BorderRadius.circular(5.0),
                        color: index % 2 == 0
                            ? const Color.fromARGB(255, 55, 64, 194)
                            : const Color.fromARGB(255, 34, 174, 255),
                        child: ListTile(
                            leading: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _station.text = doc['nom station'];
                                _address.text = doc['adresse'];
                                final prixga = doc['prix gasoil'].toString();
                                prixg.text = prixga;
                                final prixes = doc['prix essence'].toString();
                                prixe.text = prixes;
                                showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                        child: Container(
                                          height: 530,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/font.jpg'),
                                                fit: BoxFit.cover),
                                          ),
                                          padding: const EdgeInsets.all(15),
                                          child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                SingleChildScrollView(
                                                    child: Form(
                                                      key: _formKey,
                                                      child: Column(
                                                        children: [
                                                          TextFormField(
                                                            controller: _station,
                                                            decoration: InputDecoration(
                                                              hintText: 'Entrez Nom de la station',
                                                              prefixIcon: const Icon(Icons.gas_meter),
                                                              border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(10),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 20,
                                                          ),
                                                          TextFormField(
                                                            controller: _address,
                                                            decoration: InputDecoration(
                                                              hintText: "Entrez l'adresse de la station",
                                                              prefixIcon: const Icon(Icons.home),
                                                              border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(10),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 20,
                                                          ),
                                                          TextFormField(
                                                            controller: prixg,
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
                                                            controller: prixe,
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
                                                          ElevatedButton.icon(
                                                            icon: const Icon(Icons.update,
                                                              color: Color.fromARGB(255, 0, 10, 19),
                                                              size: 24.0,
                                                            ),
                                                            onPressed: () async {
                                                              if (_formKey.currentState!.validate()) {
                                                                final prixa = double.parse(prixe.text);
                                                                final prixb = double.parse(prixg.text);
                                                                setState(() {
                                                                  snapshot.data!.docs[index].reference.update({
                                                                    'nom station': _station.text,
                                                                    'adresse': _address.text,
                                                                    'prix gasoil': prixb,
                                                                    'prix essence': prixa,
                                                                  }).whenComplete(() => Navigator.pop(context));
                                                                });
                                                              }
                                                            },
                                                            style: ElevatedButton.styleFrom(
                                                              padding:
                                                              const EdgeInsets.fromLTRB(40, 15, 40, 15),
                                                              shadowColor: Colors.white,
                                                              primary:
                                                              const Color.fromARGB(255, 240, 241, 241),),
                                                            label: const Text(' Modifier ',
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 20,
                                                          ),
                                                          ElevatedButton.icon(
                                                            icon: const Icon(
                                                              Icons.delete_forever,
                                                              color: Color.fromARGB(255, 0, 10, 19),
                                                              size: 24.0,
                                                            ),
                                                            onPressed: () async {
                                                              if (_formKey.currentState!.validate()) {
                                                                setState(() {
                                                                  snapshot.data!.docs[index].reference.delete().whenComplete(()
                                                                  => Navigator.pop(context));
                                                                });
                                                              }
                                                            },
                                                            style: ElevatedButton.styleFrom(
                                                              padding:
                                                              const EdgeInsets.fromLTRB(40, 15, 40, 15),
                                                              shadowColor: Colors.white,
                                                              primary: const Color.fromARGB(255, 179, 53, 53),),
                                                            label: const Text('Supprimer',
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ))
                                              ]),
                                        )),
                                );
                              },
                            ),
                            subtitle: Column(
                              children: <Widget>[
                                Text(
                                  doc['nom station'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(doc['adresse'],
                                    style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    )),
                                Text('Prix gasoil : ${doc['prix gasoil']} Dhs',
                                    style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 15,
                                    )),
                                Text(
                                    'Prix essence : ${doc['prix essence']} Dhs',
                                    style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 15,
                                    )),
                              ],
                            )),
                      ),
                  );
                },
              );
            } else {
              return const Text(' ');
            }
          },
        ),
    );
  }
}
