class UserModel {
  // String? uid;
  String? email;
  String? prenom;
  String? nom;
  String? uid;
  String? role;
  String? password;
// recevoir data
  UserModel(
      {this.uid, this.email, this.prenom, this.nom, this.role, this.password});
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      prenom: map['prenom'],
      nom: map['nom'],
      role: map['role'],
      password: map['password'],
    );
  }
// envoyer data
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'password': password,
      'email': email,
      'prenom': prenom,
      'nom': nom,
      'role': 'user',
    };
  }
}
