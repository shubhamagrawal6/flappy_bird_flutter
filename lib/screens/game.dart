import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flappy_bird_flutter/models/bird.dart';
import 'package:flappy_bird_flutter/models/walls.dart';
import 'package:flappy_bird_flutter/services/auth.dart';
import 'package:flappy_bird_flutter/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Game extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const Game({
    @required this.auth,
    @required this.firestore,
  });

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  static double birdYaxis = 0.0;
  double time = 0;
  double height = 0;
  double initialHeight = birdYaxis;
  bool gameHasStarted = false;
  static double wallX1 = 1.3;
  double wallX2 = wallX1 + 1.5;
  Random rng = Random();
  double gapSize1;
  double gapSize2;
  double size1up = 150.0;
  double size1down = 150.0;
  double size2up = 200.0;
  double size2down = 150.0;
  double speed = 0.000075;
  int score = 0;

  void startTimer() {
    gameHasStarted = true;
    Timer.periodic(
      const Duration(microseconds: 60),
      (timer) {
        time += 0.000030;
        height = -4.9 * time * time + 2.8 * time;
        birdYaxis = initialHeight - height;

        setState(() {
          if (wallX1 < -1.4) {
            gapSize1 = 100 * rng.nextDouble() + 100;
            size1up = (500 - gapSize1) * ((rng.nextInt(60) / 100.0) + 0.2);
            size1down = ((500 - gapSize1) - size1up).abs();
            wallX1 += 2.9;
            score += 1;
          } else {
            wallX1 -= speed;
          }
        });

        setState(() {
          if (wallX2 < -1.4) {
            gapSize2 = 200 * rng.nextDouble() + 100;
            size2up = (500 - gapSize2) * ((rng.nextInt(60) / 100.0) + 0.2);
            size2down = ((500 - gapSize2) - size2up).abs();
            wallX2 += 2.9;
            score += 1;
            if (score % 10 == 0) {
              speed += 0.000025;
            }
          } else {
            wallX2 -= speed;
          }
        });

        if (birdYaxis > 1.05) {
          timer.cancel();
          gameHasStarted = false;
          _showDialog();
        }

        if (wallX1 > -0.35 && wallX1 < 0.35) {
          if (birdYaxis < -(1 - size1up / 311) ||
              birdYaxis > (1 - size1down / 311)) {
            timer.cancel();
            gameHasStarted = false;
            _showDialog();
          }
        }

        if (wallX2 > -0.35 && wallX2 < 0.35) {
          if (birdYaxis < -(1 - size2up / 311) ||
              birdYaxis > (1 - size2down / 311)) {
            timer.cancel();
            gameHasStarted = false;
            _showDialog();
          }
        }
      },
    );
  }

  void jump() {
    setState(() {
      time = 0;
      initialHeight = birdYaxis;
    });
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Database(firestore: widget.firestore).updateScore(
          uid: widget.auth.currentUser.uid,
          score: score,
        );
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            "GAME OVER",
            style: TextStyle(
              color: Color(0xFF00B2FF),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Score: $score",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.deepOrange,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                setState(() {
                  birdYaxis = 0.0;
                  time = 0;
                  height = 0;
                  initialHeight = birdYaxis;
                  wallX1 = 1.3;
                  wallX2 = wallX1 + 1.5;
                  size1up = 150.0;
                  size1down = 150.0;
                  size2up = 200.0;
                  size2down = 150.0;
                  score = 0;
                  speed = 0.000050;
                  gameHasStarted = false;
                });
                Navigator.of(context).pop();
              },
              child: const Text(
                "Play Again",
                style: TextStyle(
                  color: Color(0xFF00B2FF),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                Auth(auth: widget.auth).signOut();
                Navigator.of(context).pop();
              },
              child: const Text(
                "Sign Out",
                style: TextStyle(
                  color: Color(0xFF00B2FF),
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        );
      },
    );
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
                  duration: const Duration(),
                  color: const Color(0xff90F4C4),
                  child: Bird(),
                ),
                AnimatedContainer(
                  duration: const Duration(),
                  alignment: Alignment(wallX1, 1.025),
                  child: Wall(size: size1down),
                ),
                AnimatedContainer(
                  duration: const Duration(),
                  alignment: Alignment(wallX1, -1.025),
                  child: Wall(size: size1up),
                ),
                AnimatedContainer(
                  duration: const Duration(),
                  alignment: Alignment(wallX2, 1.025),
                  child: Wall(size: size2down),
                ),
                AnimatedContainer(
                  duration: const Duration(),
                  alignment: Alignment(wallX2, -1.025),
                  child: Wall(size: size2up),
                ),
                AnimatedContainer(
                  alignment: const Alignment(-0.8, -0.8),
                  duration: const Duration(),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          width: 2,
                        )),
                    height: 45,
                    width: 90,
                    child: Center(
                        child: Text(
                      "Score: $score",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                  ),
                ),
              ]),
            ),
            Container(
              color: Colors.green,
              height: 10,
              width: 3000,
            ),
            Container(
              color: Colors.brown,
              height: 160,
              width: 3000,
            ),
          ],
        ),
      ),
    );
  }
}
