
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:firstprojetimmw/functions/firestoreHelper.dart';
import 'package:firstprojetimmw/model/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_stripe_payment/flutter_stripe_payment.dart';
import 'package:http/http.dart' as http;

class myDrawer extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return myDrawerState();
  }

}

class myDrawerState extends State<myDrawer>{
  // Variable de la f
  String? identifiant;
  Users? utilisateur;
  DateTime time = DateTime.now();
  DateFormat dateFormat = DateFormat.yMd("fr_FR");
  String imageFilePath = "";
  Uint8List? bytesImage;
  String imageFileName = "";
  String baseUrl = "https://api.stripe.com/V1/payments_intents";
  String publicKey = "pk_test_QQ6EqdeL67aoCecNqLETZVke00kNCuIBte";
  String privateKey = "sk_test_EIn7PcMgJCh005IxqH1Kmmn600n4wtSOKC";
  final stripePaymentVar = FlutterStripePayment();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stripePaymentVar.setStripeSettings(publicKey);

  }




  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    FirestoreHelper().getIdentifiant().then((value){
      setState(() {
        identifiant = value;
      });
      FirestoreHelper().getUser(identifiant!).then((value){
        setState(() {
          utilisateur = value;
        });
      });
    });
    return Container(
      padding: EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width/2,
      color: Colors.white,
      child:  Column(
        //mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            child: Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: (utilisateur!.image == null)?NetworkImage("https://firebasestorage.googleapis.com/v0/b/firstprojetimm.appspot.com/o/image_disponible.png?alt=media&token=809cfa6c-b1af-44e1-bd85-a12ae9ef0f39"):NetworkImage(utilisateur!.image!),
                    fit: BoxFit.fill

                ),
              ),
            ),
            onTap: (){
              //appuye une fois cela affiche mon image en plus 400*400
              (utilisateur!.image==null)?Container():printImage();

            },
            onLongPress: () async {
              //appuyer longtemps ça doit récuperer une image sur mon téléphone
              FilePickerResult? resultat = await FilePicker.platform.pickFiles(
                withData: true,
              );
              if(resultat!=null){
                setState(() {
                  imageFileName = resultat.files.first.name;
                  bytesImage = resultat.files.first.bytes;
                  print(imageFileName);
                });
                await afficherImage();
              }



            },
          ),
          //Avatar

          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("${utilisateur?.pseudo}",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
              IconButton(
                  onPressed: (){
                        UpdateBox();
                  },
                  icon: Icon(Icons.edit)
              )
            ],
          ),

          SizedBox(height: 10,),
          Row(
            children: [
              Icon(Icons.mail),
              Text("${utilisateur?.mail}"),
            ],
          ),
          SizedBox(height: 10,),
          Text("${utilisateur!.prenom}  ${utilisateur!.nom}"),

          SizedBox(height: 10,),
          (utilisateur!.dateNaissance== null)?Text(dateFormat.format(time)):Text(dateFormat.format(utilisateur!.dateNaissance!)),

          SizedBox(height: 10,),

          // Paiement
          ElevatedButton(
              onPressed: () async {
                PaymentResponse response = await stripePaymentVar.addPaymentMethod();
                Map<String,String> headers ={
                  'Authorization':'Bearer ${privateKey}',
                  'Content-Type':'application/x-www-form-urlencoded'
                };
                int montant = 100*100;

                Map<String,String> body ={
                  'amount':'${montant}',
                  'currency':'eur',
                  "payment_method":response.paymentMethodId!
                };
                String url = '$baseUrl?=$publicKey';
                var responseUrl = await http.post(Uri.parse(url),headers: headers,body: body);

              },
              child: Text("Paiement")
          ),


          SizedBox(height: 10,),





          IconButton(
              onPressed: (){
                FirestoreHelper().logUser();
                //chemein vers page principal
              },
              icon: Icon(Icons.exit_to_app_rounded,)
          ),
         IconButton(
             onPressed: (){
               //Création d'un boite de dialogue
               BoxDelete();

             },
             icon: Icon(Icons.logout,color: Colors.red,)
         ),
        ],

      )

    );
  }


  afficherImage(){
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Souhatez-vous enregistrer cette image ? "),
            content: Image.memory(bytesImage!,width: 400,height: 400,),
            actions: [
              ElevatedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text("Annuler")
              ),
              ElevatedButton(
                  onPressed: (){
                    FirestoreHelper().stockageImage(imageFileName, bytesImage!).then((value){
                      setState(() {
                        imageFilePath = value;
                      });
                      Map<String,dynamic> map = {
                        "IMAGE": imageFilePath,
                      };
                      FirestoreHelper().updateUser(utilisateur!.id, map);
                    });
                    Navigator.pop(context);

                  },
                  child: Text("Enregistrer")
              ),
            ],
          );

        }
    );
  }


 printImage(){
    return showDialog(
      barrierDismissible: false,
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            content: Image.network(utilisateur!.image!,width: 400,height: 400,),
            actions: [
              ElevatedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text("Ok")
              )
            ],
          );

        }
    );

 }

UpdateBox(){
    String update = "";
    return showDialog(
      barrierDismissible: false,
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Modification"),
            content: TextField(
              onChanged: (newValue){
                setState(() {
                  update = newValue;
                });
              },

            ),
            actions: [
              ElevatedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text("Annuler")
              ),
              ElevatedButton(
                  onPressed: (){
                    Map<String,dynamic> map = {
                      "PSEUDO":update
                    };
                    FirestoreHelper().updateUser(utilisateur!.id, map);
                    Navigator.pop(context);
                  },
                  child: Text("Enregistrer")
              )
            ],
          );
        }
    );
}
  //Création de la boite de la dialogue
BoxDelete(){
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          if (Platform.isIOS) {
            return CupertinoAlertDialog(
              title: Text("Suppression du compte définitif ?"),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Non")
                ),
                ElevatedButton(
                    onPressed: () {


                    },
                    child: Text("Oui")
                ),
              ],
            );
          }
          else {
            return AlertDialog(
              title: Text("Suppression du compte définitif ?"),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Non")
                ),
                ElevatedButton(
                    onPressed: () {

                    },
                    child: Text("Oui")
                ),
              ],
            );
          }
        }
    );
}


}