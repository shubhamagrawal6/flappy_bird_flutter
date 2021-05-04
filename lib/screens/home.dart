import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flappy_bird_flutter/models/score.dart';
import 'package:flappy_bird_flutter/screens/game.dart';
import 'package:flappy_bird_flutter/screens/loading.dart';
import 'package:flappy_bird_flutter/screens/login.dart';
import 'package:flappy_bird_flutter/services/auth.dart';
import 'package:flappy_bird_flutter/services/database.dart';
import 'package:flappy_bird_flutter/widgets/scorecard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const Home({
    Key key,
    @required this.auth,
    @required this.firestore,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
      // ignore: void_checks
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Game(auth: widget.auth, firestore: widget.firestore)));
      },
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: Database(firestore: widget.firestore)
                  .streamScore(uid: widget.auth.currentUser.uid),
              builder: (BuildContext context,
                  AsyncSnapshot<List<ScoreModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData == false) {
                    return const Center(
                      child: Text("No games Played"),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (_, index) {
                        return ScoreCard(
                          firestore: widget.firestore,
                          uid: widget.auth.currentUser.uid,
                          scoreModel: snapshot.data[index],
                        );
                      },
                    );
                  }
                } else {
                  return Loading();
                }
              },
            ),
          ),
          Expanded(
            // Important Notice: Create sign-out button first, layout present in figma
            child: Align(
              alignment: Alignment.topCenter,
              // ignore: deprecated_member_use
              child: RaisedButton(
                key: const ValueKey("signIn"),
                color: Colors.blue,
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Login(
                              auth: widget.auth, firestore: widget.firestore)));
                  Auth(auth: widget.auth).signOut();
                  HapticFeedback.lightImpact();
                },
                child: const Text("Sign Out"),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
