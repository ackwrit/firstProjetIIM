import 'package:firstprojetimmw/model/Message.dart';
import 'package:firstprojetimmw/model/User.dart';
import 'package:flutter/material.dart';


class messageBubble extends StatelessWidget{

  Message message;
  Users partenaire;
  String monId;
  Animation? animation;

  messageBubble(@required String this.monId,@required Users this.partenaire,@required Message this.message,{Animation? this.animation});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
        children: widgetBubble(message.from==monId),
      ),
    );
  }

  List< Widget> widgetBubble(bool moi){
    CrossAxisAlignment alignment = (moi)?CrossAxisAlignment.end:CrossAxisAlignment.start;
    Color colorBubble =(moi)? Colors.green: Colors.blue;
    Color textcolor =Colors.white;
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: alignment,
          children: [

            Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              color: colorBubble,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Text(message.texte,style: TextStyle(color: textcolor),),
              ),

            ),


          ],
        ),
      )

    ];

  }

}