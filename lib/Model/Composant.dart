class Composant{
  int? matricule;
  String? nom;
  String? description;
  int? qte;
  int? idCategory;

  Composant(this.nom,this.description,this.qte,this.idCategory);

  Map<String,dynamic> toMap(){ // used when inserting data to the database
    return <String,dynamic>{
      "matricule" : matricule,
      "nom" : nom,
      "description" : description,
      "qte" : qte,
      "idCategory" : idCategory,
    };
  }
}