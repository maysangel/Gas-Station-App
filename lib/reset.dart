// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:station_app/login.dart';

class ResetScreen extends StatefulWidget {
  const ResetScreen({Key? key}) : super(key: key);

  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  late String  _email;
  final auth = FirebaseAuth.instance;

  @override

  @override
  Widget build(BuildContext context) {
    return Scaffold (
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Mot de Passe Oublié",
                  style: TextStyle(color: Colors.white),
                ),
              ]),
          actions: [
            IconButton(
              alignment: Alignment.topRight,
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginPage(title: "Se connecter")
                    ));
              },
              icon: const Icon(Icons.arrow_back_rounded ),
            ),
          ],
        ),
      body: Container(
        width: 700.0,
        height: 1100.0,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/gasanime.jpg'),
              fit: BoxFit.cover),
        ),
        padding: const EdgeInsets.all(20),
          child: Stack(alignment: Alignment.center,
            children: [
              Column(
              mainAxisAlignment : MainAxisAlignment.center,
              children : [
                const Text ( 'Entrez votre email pour \n réinitialiser le mot de passe',
                  textAlign : TextAlign.center ,
                  style : TextStyle (fontSize : 24) ,
                ),
                const SizedBox ( height : 20 ) ,
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      hintText: 'Email'
                  ),
                  onChanged: (value) {
                    setState(() {
                      _email = value.trim();
                    });
                  },
                ),
                    const SizedBox(height : 20) ,
                ElevatedButton.icon(
                    style : ElevatedButton.styleFrom (
                        minimumSize : const Size.fromHeight (50)),
                    icon : const Icon (Icons.lock_open),
                    label : const Text ('Réinitialiser le mot de passe',
                    ),
                    onPressed : () {
                      auth.sendPasswordResetEmail(email: _email);
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content:
                          Text("L'email de réinitialisation est envoyé !"),
                              backgroundColor: Color.fromRGBO(255, 0, 0, 0.5),
                          ));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                          builder: (context) => const LoginPage(title: "Se connecter")
                      ));
                    }
                    ),
              ]),
        ]),
      ),
    );
  }
}