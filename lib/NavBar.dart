// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'prixe.dart';
import 'prixg.dart';
import 'tabDistance.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text(''),
            accountEmail: Text('TRIER PAR ',style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage('images.gasstation.jpg')),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.gas_meter),
            title: const Text("Prix d'essence"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const prixe(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.gas_meter),
            title: const Text("Prix de gasoil"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const prixg(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.social_distance),
            title: const Text("Distance"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const tabDistance('Tab Distance', title: 'Tableau de Distance'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
