import 'dart:async';

import 'package:flappy_bird_flutter/models/bird.dart';
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

  void startTimer() {
    gameHasStarted = true;
    Timer.periodic(const Duration(microseconds: 1), (timer) {
      time += 0.0001;
      height = -4.9 * time * time + 3 * time;
      setState(() {
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
              child: AnimatedContainer(
                alignment: Alignment(0, birdYaxis),
                duration: const Duration(milliseconds: 0),
                color: const Color(0xff90F4C4),
                child: Bird(),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.green,
              ),
            )
          ],
        ),
      ),
    );
  }
}
