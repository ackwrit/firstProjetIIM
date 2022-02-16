
import 'package:cloud_firestore/cloud_firestore.dart';

class Morceau{
  String id = "";
  String title="";
  String author = "";
  String song_path = "";
  String? title_album;
  String? image_music;
  String? type_music;




  Morceau(DocumentSnapshot snapshot){
    id = snapshot.id;
    Map<String,dynamic> map = snapshot.data() as Map<String,dynamic>;
    title = map["TITLE"];
    author = map["AUTHOR"];
    title_album = map["TITLE_ALBUM"];
    image_music = map["IMAGE_MUSIC"];
    type_music = map["TYPE_MUSIC"];
    song_path = map["SONG_PATH"];
  }



}