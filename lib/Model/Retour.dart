class Retour {
  int? id;
 // String? dateRetour;
  String? etat;
  int? qte;
  int? idMembre;
  int? idComposant;


  Retour(this.etat, this.qte,this.idMembre,
      this.idComposant);

  Map<String, dynamic> toMap() {
    // used when inserting data to the database
    return <String, dynamic>{
      "id": id,
      "etat": etat,
      "qte": qte,
      "idMembre": idMembre,
      "idComposant": idComposant,
      //"dateRetour": dateRetour,
    };
  }

}
