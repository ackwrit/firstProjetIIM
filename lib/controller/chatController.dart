

import 'package:firstprojetimmw/controller/messageController.dart';
import 'package:firstprojetimmw/model/User.dart';
import 'package:flutter/material.dart';

import 'MyWidgets/ZoneText.dart';

class chatController extends StatefulWidget{
  Users moi;
  Users partenaire;
  chatController(@required this.moi,@required this.partenaire);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return chatControllerState();
  }

}
class chatControllerState extends State<chatController>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.partenaire.prenom} ${widget.partenaire.nom}",style: TextStyle(color: Colors.white),),
      
      ),

      body: bodyPage(),
    );
  }




  Widget bodyPage(){

    return Container(
      child: InkWell(
        onTap: ()=>FocusScope.of(context).requestFocus(new FocusNode()),
        child: Column(
          children: [
            //Zone de chat
            new Flexible(child: Container(
              height: MediaQuery.of(context).size.height,
              child: Messagecontroller(widget.moi,widget.partenaire),
            )),
            //Divider
            new Divider(height: 1.5,),
            //Zone de text
            ZoneText(widget.partenaire,widget.moi),
          ],
        ),
      ),
    );
  }

}