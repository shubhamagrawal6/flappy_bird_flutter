import 'package:cloud_firestore/cloud_firestore.dart';

class ScoreModel {
  String uid;
  String score;
  String name;

  ScoreModel({
    this.score,
    this.uid,
    this.name,
  });

  ScoreModel.fromDocumentSnapshot({DocumentSnapshot documentSnapshot}) {
    uid = documentSnapshot.id;
    score = documentSnapshot.data()["score"] as String;
  }
}
