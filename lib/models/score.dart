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
    final temp = documentSnapshot;
    score = temp.get('score') as String;
  }
}
