import 'package:station_app/verifyemail.dart';
import 'model.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isObscure3 = true;
  bool visible = false;
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _nom = TextEditingController();
  final TextEditingController _prenom = TextEditingController();

  CollectionReference ref = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Container(
            width: 700.0,
            height: 1100.0,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/interface.jpg'),
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
                        height: 70,
                      ),
                      const Text(
                        'Inscription',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                        ),
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _prenom,
                                  decoration: InputDecoration(
                                    hintText: 'Prénom',
                                    prefixIcon: const Icon(Icons.person),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: _nom,
                                  decoration: InputDecoration(
                                    hintText: 'Nom',
                                    prefixIcon: const Icon(Icons.person),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
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
                            controller: _emailcontroller,
                            validator: (value) =>
                            EmailValidator.validate(value!)
                                ? null
                                : "Please enter a valid email",
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
                                return 'Please enter your password';
                              }
                              return null;
                            },
                            maxLines: 1,
                            //obscureText: true,
                            obscureText: _isObscure3,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  icon: Icon(_isObscure3
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      _isObscure3 = !_isObscure3;
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
                          ElevatedButton.icon(
                            icon: const Icon(
                              Icons.app_registration_outlined,
                              color: Color.fromARGB(255, 0, 10, 19),
                              size: 24.0,
                            ),
                            onPressed: () async {
                              signUp(
                                _emailcontroller.text,
                                _passwordcontroller.text,
                                _nom.text,
                                _prenom.text,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding:
                              const EdgeInsets.fromLTRB(40, 15, 40, 15),
                              shadowColor: Colors.white,
                              primary: const Color.fromARGB(255, 242, 241, 245),
                            ),
                            label: const Text(
                              'Inscription',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Déja un compte?',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                ),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                        const LoginPage(title: 'Login UI'),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Se connecter',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromARGB(255, 1, 12, 20),
                                      fontSize: 18,
                                    ),
                                  )),
                            ],
                          ),
                        ]),
                      )
                    ]),
              )
            ])));
  }

  void signUp(String email, String password, String nom, String prenom) async {
    const CircularProgressIndicator();
    if (_formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim())
          .then(
              (value) => {postDetailsToFirestore(email, nom, prenom, password)})
          .catchError((e) {});
    }
  }

  postDetailsToFirestore(
      String email, String nom, String prenom, String password) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    UserModel userModel = UserModel();
    userModel.email = email;
    userModel.uid = user!.uid;
    userModel.nom = nom;
    userModel.password = password;
    userModel.prenom = prenom;
    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const verify(),
      ),
    );
  }
}
