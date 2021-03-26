import 'dart:async';

import 'package:flappy_bird_flutter/models/bird.dart';
import 'package:flappy_bird_flutter/models/walls.dart';
import 'package:flutter/material.dart';

class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  static double birdYaxis = 0.0;
  double time = 0;
  double height = 0;
  double initialHeight = birdYaxis;
  bool gameHasStarted = false;
  double wallX1 = 0;
  double wallX2 = 1.3;

  void startTimer() {
    gameHasStarted = true;
    Timer.periodic(const Duration(microseconds: 1), (timer) {
      time += 0.0001;
      height = -4.9 * time * time + 3 * time;
      setState(() {
        wallX1 -= 0.5;
        wallX2 -= 0.5;
        birdYaxis = initialHeight - height;
      });
      if (birdYaxis > 1) {
        timer.cancel();
        gameHasStarted = false;
      }
    });
  }

  void jump() {
    setState(() {
      time = 0;
      initialHeight = birdYaxis;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          if (gameHasStarted) {
            jump();
          } else {
            startTimer();
          }
        },
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Stack(children: [
                AnimatedContainer(
                  alignment: Alignment(0, birdYaxis),
                  duration: const Duration(milliseconds: 0),
                  color: const Color(0xff90F4C4),
                  child: Bird(),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 0),
                  alignment: Alignment(wallX1, 1.03),
                  child: Wall(size: 200.0),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 0),
                  alignment: Alignment(wallX1, -1.03),
                  child: Wall(size: 200.0),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 0),
                  alignment: Alignment(wallX2, 1.03),
                  child: Wall(size: 200.0),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 0),
                  alignment: Alignment(wallX2, -1.03),
                  child: Wall(size: 200.0),
                ),
              ]),
            ),
            Container(
              color: Colors.green,
              height: 10,
              width: 360,
            ),
            Container(
              color: Colors.brown,
              height: 160,
              width: 360,
            ),
          ],
        ),
      ),
    );
  }
}
