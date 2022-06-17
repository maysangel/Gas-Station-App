// ignore_for_file: camel_case_types, avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class prixg extends StatefulWidget {
  const prixg({Key? key}) : super(key: key);

  @override
  State<prixg> createState() => _prixgState();
}

class _prixgState extends State<prixg> {
  List stationslist = [];

  @override
  void initState() {
    super.initState();
    fetchDatabaseList();
  }

  fetchDatabaseList() async {
    dynamic res = await getData();
    if (res == null) {
      print('error');
    } else {
      setState(() {
        stationslist = res;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title:
          Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
            Text(
              "Prix Gasoil",
              style: TextStyle(color: Colors.white),
            ),
          ]),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  stationslist = stationslist.reversed.toList();
                });
              },
              icon: const Icon(Icons.sort),
            ),
          ],
        ),
        body: ListView.builder(
            itemCount: stationslist.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(stationslist[index]['nom station']),
                  trailing:
                  Text('${stationslist[index]['prix gasoil']} Dhs'),
                ),
              );
            }));
  }

  Future getData() async {
    List itemsList = [];
    try {
      await FirebaseFirestore.instance
          .collection('stations')
          .orderBy('prix gasoil')
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var element in querySnapshot.docs) {
          itemsList.add(element.data());
        }
      });
      return itemsList;
    // ignore: empty_catches
    } catch (e) {}
  }
}
