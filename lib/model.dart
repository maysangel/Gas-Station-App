class UserModel {
  // String? uid;
  String? email;
  String? prenom;
  String? nom;
  String? uid;

  // Recevoir data

  UserModel({this.uid, this.email, this.prenom, this.nom});
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      prenom: map['prenom'],
      nom: map['nom'],
    );
  }
// envoyer data
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'prenom': prenom,
      'nom': nom,
    };
  }
}
