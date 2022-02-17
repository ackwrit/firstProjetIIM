import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstprojetimmw/controller/detailMorceau.dart';
import 'package:firstprojetimmw/functions/firestoreHelper.dart';
import 'package:firstprojetimmw/model/Morceau.dart';
import 'package:flutter/material.dart';

class allMorceaux extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return allMorceauxState();
  }

}

class allMorceauxState extends State<allMorceaux>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: bodyPage(),
    );
  }

  Widget bodyPage(){
    return StreamBuilder<QuerySnapshot>(
      stream: FirestoreHelper().fire_morceau.snapshots(),
      builder: (context,snapshot){
        if(snapshot.data!.docs.isEmpty){
          return Container(
            width: 25,
            height: 25,
            child: CircularProgressIndicator(),
          );
        }
        else
          {
            
            List documents = snapshot.data!.docs;
            return GridView.builder(
              itemCount: documents.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), 
                itemBuilder: (context,index){
                Morceau musique = Morceau(documents[index]);
                return InkWell(
                  child: Hero(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image:DecorationImage(
                              image: NetworkImage(musique.image_music!)
                          )
                      ),
                    ),
                    tag: '${musique.id}',
                  ),

                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (BuildContext context){
                        return detailMorceau(musique: musique);
                      }
                    ));
                  },
                );

                }
            );
          }
      }

    );
  }

}