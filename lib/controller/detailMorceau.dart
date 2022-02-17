import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:firstprojetimmw/model/Morceau.dart';
import 'package:flutter/material.dart';

class detailMorceau extends StatefulWidget{
  Morceau musique;
  detailMorceau({required Morceau this.musique});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return detailMorceauState();
  }

}

class detailMorceauState extends State<detailMorceau> with SingleTickerProviderStateMixin{

  statut lecture=statut.stopped;
  bool isFav = false;
  AudioPlayer audioPlayer = AudioPlayer();
  Duration position= Duration(seconds: 0);
  StreamSubscription? positionStream;
  StreamSubscription? stateStream;
  double volumeSound = 0.5;
  Duration duree = Duration(seconds: 0);
  AnimationController? animationController;
  Animation? colorAnimation;
  Animation? sizeAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(
        vsync: this,
      duration: Duration(seconds: 1)
    );
    colorAnimation = ColorTween(begin:Colors.grey[400],end: Colors.red).animate(animationController!);
    sizeAnimation = TweenSequence <double>([
      TweenSequenceItem(tween: Tween(begin:30,end:50), weight: 50),
      TweenSequenceItem(tween: Tween(begin:50,end:30), weight: 50)
    ]).animate(animationController!);
    configurationPlayer();
    animationController!.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        isFav = true;
      }
      else
        {
          isFav = false;
        }

    });
  }


  @override
  void dispose() {
    // TODO: implement dispose
    animationController!.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.musique.title),
      ),
      body: bodyPage(),
    );
  }

  Widget bodyPage(){
    return Column(
      children: [
        SizedBox(height: 10,),
       Hero(
        child: AnimatedContainer(
          duration: Duration(seconds: 1),
          height: (lecture == statut.stopped)?200:300,
          width: (lecture == statut.stopped)?200:300,
          child: Positioned(
            top: 20,
            child: AnimatedBuilder(
                animation: animationController!,
          builder: (BuildContext context, Widget? widget){
                  return IconButton(
                    icon: Icon(
                      Icons.favorite,
                      size: sizeAnimation!.value,
                      color: colorAnimation!.value,
                    ),
                    onPressed: (){
                      (isFav)?animationController!.reverse():animationController!.forward();

                    },

                  );

              },

            )
            ,
          ),

          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                  image: NetworkImage(widget.musique.image_music!),
                  fit: BoxFit.fill
              )
          ),

        ),
            tag:'${widget.musique.id}'
        ),


        SizedBox(height: 10,),
        Text(widget.musique.title),
        Text(widget.musique.author),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon:Icon(Icons.fast_rewind),
              onPressed: (){
                lecture =statut.playing;
                rewind();

              },

            ),
            (lecture==statut.stopped)? IconButton(
              icon:Icon(Icons.play_arrow,size: 40),
              onPressed: (){
                lecture = statut.paused;
                play();


              },
            ) :IconButton(
              icon:Icon(Icons.pause,size: 40,),
              onPressed: (){
                //musique en pause
                setState(() {
                  lecture = statut.stopped;
                  pause();
                });
              },
            ),
            IconButton(
              icon:Icon(Icons.fast_forward),
              onPressed: (){
                //musique en en avance
                lecture = statut.playing;
                forward();

              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(position.toString().substring(2,7)),
            Text(duree.toString().substring(2,7))

          ],
        ),


        Slider(
            max: (duree == null)?0.0:duree.inSeconds.toDouble(),
            min: 0.0,

            value: position.inSeconds.toDouble(),
            activeColor: Colors.green,
            inactiveColor: Colors.red,
            onChanged: (va){
              setState(() {
                Duration time = Duration(seconds: va.toInt());
                position = time;
                audioPlayer.play(widget.musique.song_path,position: position,volume: volumeSound);
              });


            }),



      ],

    );
  }

  Future play() async {
    if(position>Duration(seconds: 0)){
      await audioPlayer.play(widget.musique.song_path,position: position,volume: volumeSound);
    }
    else{
      await audioPlayer.play(widget.musique.song_path,position: position,volume: volumeSound);
    }


    //configurationPlayer();

  }

  Future pause() async {
    await audioPlayer.pause();


  }

  rewind(){

        audioPlayer.pause();
        audioPlayer.seek(Duration(seconds: 0));
        position = new Duration(seconds: 0);
        audioPlayer.play(widget.musique.song_path,position: position);


  }


  forward(){

        position = new Duration(seconds: position.inSeconds+10);
        audioPlayer.pause();
        audioPlayer.play(widget.musique.song_path,position: position);




  }


  configurationPlayer(){
    audioPlayer.setUrl(widget.musique.song_path);
    positionStream = audioPlayer.onAudioPositionChanged.listen((event) {
      setState(() {
        position = event;
      });
    });

    audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        duree = event;
      });
    });
    stateStream = audioPlayer.onPlayerStateChanged.listen((event) {
      if(event == statut.playing){
        setState(() async {
          duree = audioPlayer.getDuration() as Duration;
        });
      }
      else if(event == statut.stopped){
        setState(() {
          lecture = statut.stopped;
        });
      }
      },onError: (message){
      print("erreur : $message");
      setState(() {
        lecture = statut.stopped;
        position = Duration(seconds: 0);
        duree = Duration(seconds: 0);
      });
    }
    );


  }

}

enum statut{
  playing,
  stopped,
  paused,
  rewind,
  forward
}