
import 'package:cloud_firestore/cloud_firestore.dart';

class Users{
  String id = "";
  String? nom;
  String? prenom;
  String? image;
  String? mail;
  String? pseudo;
  DateTime? dateNaissance;




  Users(DocumentSnapshot snapshot){
    id = snapshot.id;
    Map<String,dynamic> map = snapshot.data() as Map<String,dynamic>;
    nom = map["NOM"];
    prenom = map ["PRENOM"];
    image = map["IMAGE"];
    mail = map["MAIL"];
    pseudo = map ["PSEUDO"];
    dateNaissance = map ["DATENAISSANCE"];

  }
  Map<String,dynamic> toMap()
  {
    Map <String,dynamic> map;
    return map ={
      'NOM':nom,
      'PRENOM':prenom,
      'IMAGE':image,
      'MAIL':mail,
      'PSEUDO':pseudo,
      "DATENAISSANCE":dateNaissance


    };
  }



}