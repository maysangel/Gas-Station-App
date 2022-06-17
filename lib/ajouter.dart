// ignore_for_file: camel_case_types
import 'package:flutter/material.dart';
import 'package:station_app/bienvenue.dart';
import 'interfaceadmin.dart';

class ajoute extends StatefulWidget {
  const ajoute({Key? key}) : super(key: key);

  @override
  State<ajoute> createState() => _ajouteState();
}

class _ajouteState extends State<ajoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: 450.0,
            height: 900.0,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/check.png'),
                  fit: BoxFit.cover),
            ),
            child: Stack(alignment: Alignment.center, children: [
              Column(children: [
                const SizedBox(
                  height: 450,
                ),
                const Text(
                  "Station Ajoutée !",
                  style: TextStyle(
                      color: Color.fromARGB(255, 7, 6, 6),
                      fontSize: 22,
                      fontWeight: FontWeight.w300),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton.icon(
                  icon: const Icon(
                    Icons.home,
                    color: Color.fromARGB(255, 0, 10, 19),
                    size: 24.0,
                  ),
                  label: const Text("Page d'accueil"),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const bienvenu(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
                    shadowColor: Colors.white,
                    primary: const Color.fromARGB(255, 242, 241, 245),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton.icon(
                  icon: const Icon(
                    Icons.add,
                    color: Color.fromARGB(255, 0, 10, 19),
                    size: 24.0,
                  ),
                  label: const Text("Rajouter une station"),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const adminInt(title: 'title'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
                    shadowColor: Colors.white,
                    primary: const Color.fromARGB(255, 242, 241, 245),
                  ),
                ),
              ])
            ]),
        ),
    );
  }
}
