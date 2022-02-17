import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstprojetimmw/controller/MyWidgets/MessageBubble.dart';
import 'package:firstprojetimmw/functions/firestoreHelper.dart';
import 'package:firstprojetimmw/model/Message.dart';
import 'package:firstprojetimmw/model/User.dart';
import 'package:flutter/material.dart';


class Messagecontroller extends StatefulWidget{
  Users id;
  Users idPartner;
  Messagecontroller(@required Users this.id,@required Users this.idPartner);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MessagecontrollerState();
  }

}

class MessagecontrollerState extends State<Messagecontroller> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<QuerySnapshot>(
        stream: FirestoreHelper().fire_message.orderBy('envoiMessage',descending: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot <QuerySnapshot>snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          else {
            List<DocumentSnapshot>documents = snapshot.data!.docs;

            return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (BuildContext ctx,int index)
                {
                  Message discussion = Message(documents[index]);
                  if((discussion.from==widget.id.id && discussion.to==widget.idPartner.id)||(discussion.from==widget.idPartner.id&&discussion.to==widget.id.id))
                  {

                    return messageBubble(widget.id.id, widget.idPartner, discussion);
                  }
                  else
                  {
                    return Container();
                  }

                }
            );


          }
        }
    );
  }
}