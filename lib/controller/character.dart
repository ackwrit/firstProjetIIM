import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstprojetimmw/functions/firestoreHelper.dart';
import 'package:firstprojetimmw/model/User.dart';
import 'package:flutter/material.dart';


class character extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return characterState();
  }

}

class characterState extends State<character>{
  String uid="";
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: bodyPage(),
    );
  }

  Widget bodyPage(){
    FirestoreHelper().getIdentifiant().then((value){
      setState(() {
        uid = value;
      });
    });
    return StreamBuilder<QuerySnapshot>(
        stream: FirestoreHelper().fire_user.snapshots(),
        builder: (context,snapshot){
          if(!snapshot.hasData){
            return Container(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(),
            );
          }
          else
            {
              List documents = snapshot.data!.docs;
              return ListView.builder(
                itemCount: documents.length,
                  itemBuilder: (context,index){
                  Users utilisateur = Users(documents[index]);
                  if(utilisateur.id== uid){
                    return Container();
                  }
                  else {
                    return Card(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      color: Colors.green,
                      child:
                      ListTile(
                        title: Text("${utilisateur.prenom} ${utilisateur.nom}"),
                        subtitle: Text("${utilisateur.mail}"),
                      ),


                    );
                  }


                  }
              );
            }
        }
    );
  }

}