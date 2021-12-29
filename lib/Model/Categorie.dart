class Categorie{
   int? id;
   String? categorie;

  Categorie(this.categorie);

   Categorie.id(this.id,this.categorie);

  Map<String,dynamic> toMap(){ // used when inserting data to the database
    return <String,dynamic>{
      "id" : id,
      "categorie" : categorie
    };
  }

}