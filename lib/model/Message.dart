import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String idMessage="";
  String from="";
  String to="";
  String texte="";
  DateTime envoiMessage= DateTime.now();


  Message(DocumentSnapshot snapshot) {
    idMessage = snapshot.id;
    Map<String,dynamic> map = snapshot.data() as Map<String,dynamic>;
    from = map['from'];
    to = map['to'];
    texte = map['texte'];
    Timestamp timestamp = map["envoiMessage"];
    envoiMessage = timestamp.toDate();
  }
}