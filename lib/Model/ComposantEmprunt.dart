class ComposantEmprunt {
  int? id;
  int? idComposant;
  int? idEmprunt;
  int? qte;

  ComposantEmprunt(this.id, this.idComposant, this.idEmprunt, this.qte);

  Map<String, dynamic> toMap() {
    // used when inserting data to the database
    return <String, dynamic>{
      "id": id,
      "idComposant": idComposant,
      "idEmprunt": idEmprunt,
      "qte": qte,
    };
  }


}
