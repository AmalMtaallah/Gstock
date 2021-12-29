class Membre {
  int? id;
  String? nom;
  String? email;
  int? tel_1;
  int? tel_2;

  Membre(this.nom, this.email, this.tel_1, this.tel_2);

  Map<String, dynamic> toMap() {
    // used when inserting data to the database
    return <String, dynamic>{
      "id": id,
      "nom": nom,
      "email": email,
      "telephone_1": tel_1,
      "telephone_2": tel_2,
    };
  }

}
