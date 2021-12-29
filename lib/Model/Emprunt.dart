class Emprunt {
  int? id;
  int? idMembre;

  Emprunt(this.id, this.idMembre);

  Map<String, dynamic> toMap() {
    // used when inserting data to the database
    return <String, dynamic>{
      "id": id,
      "idMembre": idMembre,
    };
  }


}
