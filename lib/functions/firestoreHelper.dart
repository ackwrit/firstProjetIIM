
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firstprojetimmw/model/User.dart';

class FirestoreHelper{
  //Attributs
  final auth = FirebaseAuth.instance;
  final fire_user = FirebaseFirestore.instance.collection("Users");
  final fire_morceau = FirebaseFirestore.instance.collection("Morceaux");
  final firestorage = FirebaseStorage.instance;



  //Méthode
Future CreationUser({required String? mail, required String? password, String? prenom, String? nom}) async {
  UserCredential authresult = await auth.createUserWithEmailAndPassword(email: mail!, password: password!);
  User? user = authresult.user!;
  String uid = user.uid;
  Map<String,dynamic> map ={
    "PRENOM":prenom,
    "NOM":nom,
    "MAIL":mail,
  };
  addUser(uid, map);

}

Future ConnectUser({required String mail,required String password}) async{
  UserCredential authresult = await auth.signInWithEmailAndPassword(email: mail, password: password);
  User? user = authresult.user!;

}



addUser(String uid, Map<String,dynamic> map){
  fire_user.doc(uid).set(map);
}


addMusique(String uid, Map<String,dynamic> map){
  fire_morceau.doc(uid).set(map);
}

updateUser(String uid,Map<String,dynamic> map){
  fire_user.doc(uid).update(map);
}


deleteUser(String uid){
   fire_user.doc(uid).delete();
}

logUser(){
  auth.signOut();
}

Future <String> getIdentifiant() async {
  String uid =  auth.currentUser!.uid;
  return uid;
}

Future <Users> getUser(String uid) async {
  DocumentSnapshot snapshot = await fire_user.doc(uid).get();
  return Users(snapshot);
}


Future <String >stockageImage(String nomImage,Uint8List data) async {
  TaskSnapshot download = await firestorage.ref("cover/$nomImage").putData(data);
  String urlChemin = await download.ref.getDownloadURL();
  return urlChemin;
}



  Future <String >stockageAudio(String nomAudio,Uint8List data) async {
    TaskSnapshot download = await firestorage.ref("Musique/$nomAudio").putData(data);
    String urlChemin = await download.ref.getDownloadURL();
    return urlChemin;
  }


}