// ignore_for_file: use_build_context_synchronously, avoid_print, unused_local_variable, must_be_immutable
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:station_app/checkLogin.dart';
import 'package:station_app/register.dart';
import 'package:station_app/reset.dart';

class LoginPage extends StatefulWidget {
   const LoginPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  bool cacher = true;
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: 700.0,
        height: 1100.0,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/setup.jpeg'),
              fit: BoxFit.cover),
        ),
        padding: const EdgeInsets.all(20),
        child: Stack(alignment: Alignment.center, children: [
          SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 130,
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(children: [
                      TextFormField(
                        controller: _emailcontroller,
                        validator: (value) =>
                        EmailValidator.validate(value!)
                            ? null
                            : "svp entrez votre email",
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: 'Entrez votre email',
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _passwordcontroller,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'svp entrez votre mdp';
                          }
                          return null;
                        },
                        maxLines: 1,
                        obscureText: cacher,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              icon: Icon(cacher
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  cacher = !cacher;
                                });
                              }),
                          prefixIcon: const Icon(Icons.lock),
                          hintText: 'Entrez votre mot de passe',
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
                            signIn(_emailcontroller.text,
                                _passwordcontroller.text);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding:
                          const EdgeInsets.fromLTRB(40, 15, 40, 15),
                          shadowColor: Colors.white,
                          primary: const Color.fromARGB(255, 242, 241, 245),
                        ),
                        child: const Text(
                          'Se connecter',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 1, 12, 20),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            child: const Text('Mot de passe oublié ? ',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Color.fromARGB(255, 1, 12, 20),
                              ),
                            ),
                            onPressed: () {
                                Navigator.pushReplacement(
                                context,
                                  MaterialPageRoute(
                                builder: (context) => const ResetScreen(),),
                          );})],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Pas encore de compte?'),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  const RegisterPage(
                                      title: 'Register UI'),
                                ),
                              );
                            },
                            child: const Text(
                              'Créer un compte',
                              style: TextStyle(
                                color: Color.fromARGB(255, 1, 12, 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]),
                  )
                ]),
          )
        ]),
      ),
    );
  }

  void signIn(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const checkLogin(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
}