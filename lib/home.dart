import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_2d/barrier.dart';
import 'package:game_2d/bird.dart';
import 'package:game_2d/coverscreen.dart';



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {
  static double birdY = 0;
  double initialPos = birdY;
  double height = 0;
  double time = 0;
  double gravity = -4.9;
  double velocity = 3.5;
  double birdWidth = 0.1;
  double birdHeight = 0.1;
  bool gameStarted = false;

  static List<double> barrierX = [2, 2 + 1.5];
  static double barrierWidth = 0.5;
  List<List<double>> barrierHeight = [
    [0.6, 0.4],
    [0.4, 0.6],
  ];
void startGame() {
  gameStarted = true;
  Timer.periodic(Duration(milliseconds:10), (timer) {
    height = gravity * time * time + velocity * time;

    setState(() {
      birdY = initialPos - height;
    });

    if(birdIsDead()) {
      timer.cancel();
      gameStarted = false;
      _showDialog();
    }

    time += 0.01;
  });
}
void resetGame() {
  Navigator.pop(context);
  setState(() {
    birdY = 0;
    gameStarted = false;
    time = 0;
    initialPos = birdY;
  });
}
void _showDialog() {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context){
      return AlertDialog(
        backgroundColor: Colors.brown,
        title: Center(
          child: Text(
            'Game Over',
            style: TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: resetGame,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                padding: EdgeInsets.all(7),
                color: Colors.white,
                child: Text('play again',
                style: TextStyle(color: Colors.brown))
              ),
            ),
          )
        ],
      );
    }
  );
}
void moveMap () {
  for (int i=0; i < barrierX.length; i++){
    setState(() {
      barrierX[i] -= 0.005;
    });
    if(barrierX[i] < -1.5){
      barrierX[i] += 3;
    }
  }
}
bool birdIsDead() {
  if(birdY < -1 || birdY > 1){
    return true;
  }

  for(int i = 0; i < barrierX.length; i++ ){
    if (barrierX[i] <= birdWidth &&
    barrierX[i] + barrierWidth >= -birdWidth &&
        (birdY <= -1 + barrierHeight[i][0] ||
        birdY + birdHeight >= 1 - barrierHeight[i][1])){
      return true;
    }
  }
  return false;
}


  void jump() {
  setState(() {
    time = 0;
    initialPos = birdY;
  });
    // Timer.periodic(Duration(milliseconds: 50), (timer) {
    //   height = gravity * time * time + velocity * time;
    //   setState(() {
    //     birdY = initialPos - height;
    //   });
    //   print(birdY);
    //
    //   if(birdY < -1){
    //     timer.cancel();
    //   }
    //   time += 0.1;
    // });
    time = 0;
  }
 @override
  Widget build(BuildContext context) {
   return GestureDetector(
     onTap: gameStarted ? jump : startGame,
     child: Scaffold(
     body: Column(children: [
       Expanded(
         flex: 2,
         child: Container(
           color: Colors.blue,
           child: Center(
             child: Stack(
               children: [
                 MyBird(
                   birdY: birdY,
                   birdHeight: birdHeight,
                   birdWidth: birdWidth,
                 ),
                 CoverScreen(gameStarted: gameStarted),
                 Container(
                   child: MyBarrier(
                       barrierHeight: barrierHeight[0][0],
                       barrierWidth: barrierWidth,
                       barrierX: barrierX[0],
                       isThisBottomBarrier: false),
                 ),
                 Container(
                   child: MyBarrier(
                       barrierHeight: barrierHeight[0][0],
                       barrierWidth: barrierWidth,
                       barrierX: barrierX[0],
                       isThisBottomBarrier: false),
                 ),
                 Container(
                   child: MyBarrier(
                       barrierHeight: barrierHeight[0][1],
                       barrierWidth: barrierWidth,
                       barrierX: barrierX[0],
                       isThisBottomBarrier: true),
                 ),
                  Container(
                    child:  MyBarrier(
                        barrierHeight: barrierHeight[1][0],
                        barrierWidth: barrierWidth,
                        barrierX: barrierX[1],
                        isThisBottomBarrier: false),
                  ),
                Container(
                  child: MyBarrier(
                      barrierHeight: barrierHeight[1][1],
                      barrierWidth: barrierWidth,
                      barrierX: barrierX[1],
                      isThisBottomBarrier: true),
                ),
                 Container(
                   alignment: Alignment(0, -0.5),
                   child: Text('Tap to play'),
                 )
               ],
             ),
           ),
       )),
       Expanded(
         child: Container(
           color: Colors.brown
         ),
       )
     ],),
     ));
 }
  }

