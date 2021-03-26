import 'dart:async';
import 'dart:math';
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
  static double wallX1 = 1.2;
  double wallX2 = wallX1 + 1.5;
  Random rng = Random();
  double gapSize1;
  double gapSize2;
  double size1up = 200.0;
  double size1down = 200.0;
  double size2up = 300.0;
  double size2down = 150.0;

  void startTimer() {
    gameHasStarted = true;
    Timer.periodic(const Duration(microseconds: 60), (timer) {
      time += 0.00015;
      height = -4.9 * time * time + 2.8 * time;
      birdYaxis = initialHeight - height;

      setState(() {
        if (wallX1 < -1.4) {
          gapSize1 = 100 * rng.nextDouble() + 100;
          size1up = (500 - gapSize1) * ((rng.nextInt(60) / 100.0) + 0.2);
          size1down = ((600 - gapSize1) - size1up).abs();
          wallX1 += 2.9;
        } else {
          wallX1 -= 0.00025;
        }
      });

      setState(() {
        if (wallX2 < -1.4) {
          gapSize2 = 200 * rng.nextDouble() + 100;
          size2up = (500 - gapSize2) * ((rng.nextInt(60) / 100.0) + 0.2);
          size2down = ((500 - gapSize2) - size2up).abs();
          wallX2 += 2.9;
        } else {
          wallX2 -= 0.00025;
        }
      });

      if (birdYaxis > 1.05) {
        timer.cancel();
        gameHasStarted = false;
      }

      if (wallX1 > -0.35 && wallX1 < 0.35) {
        if (birdYaxis < -(size1up / 623) || birdYaxis > (size1up / 623)) {
          timer.cancel();
          gameHasStarted = false;
        }
      }

      if (wallX2 > -0.35 && wallX2 < 0.35) {
        if (birdYaxis < -(size2up / 623) || birdYaxis > (size2up / 623)) {
          timer.cancel();
          gameHasStarted = false;
        }
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
                  alignment: Alignment(wallX1, 1.025),
                  child: Wall(size: size1down),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 0),
                  alignment: Alignment(wallX1, -1.025),
                  child: Wall(size: size1up),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 0),
                  alignment: Alignment(wallX2, 1.025),
                  child: Wall(size: size2down),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 0),
                  alignment: Alignment(wallX2, -1.025),
                  child: Wall(size: size2up),
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
