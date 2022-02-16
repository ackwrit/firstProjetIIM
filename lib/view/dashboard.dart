import 'package:firstprojetimmw/controller/addMorceau.dart';
import 'package:firstprojetimmw/controller/allMorecaux.dart';
import 'package:firstprojetimmw/controller/character.dart';
import 'package:firstprojetimmw/view/Mydrawer.dart';
import 'package:flutter/material.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';

class dashboard extends StatefulWidget{
  String? mail;
  String? password;
  dashboard(String? this.mail,String? this.password);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return dashboardState();
  }

}


class dashboardState extends State<dashboard>{
  int currentIndex = 1;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      drawer: myDrawer(),



      appBar: AppBar(
        centerTitle: true,
        title: Text("Nouvelle page"),
        actions: [
          IconButton(
              onPressed: (){
                //Créer la fonction d'enrgister des morecaux dans la base donnée
                Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context){
                      return addMorceau();
                    }
                ));
              },
              icon: Icon(Icons.add)
          )
        ],

      ),
      body: bodyPage(currentIndex),
      bottomNavigationBar: DotNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.amber,
        onTap: (int newValue){
          setState(() {
            currentIndex = newValue;
          });
        },
        currentIndex: currentIndex,
        items: [
          DotNavigationBarItem(
              icon: Icon(Icons.music_note_sharp),
          ),
          DotNavigationBarItem(
            icon: Icon(Icons.person),
          ),
          DotNavigationBarItem(
            icon: Icon(Icons.map_sharp),
          ),
        ],
      )

    );
  }



  Widget bodyPage(int value){
    switch (value) {
      case 0 : return allMorceaux();
      case 1: return character();
      case 2: return Text("Afficher une carte");
      default: return Text("Aucune info");

    }
  }

}