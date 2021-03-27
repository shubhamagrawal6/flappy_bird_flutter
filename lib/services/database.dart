import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flappy_bird_flutter/models/score.dart';

class Database {
  final FirebaseFirestore firestore;

  Database({this.firestore});

  Stream<List<ScoreModel>> streamScore({String uid}) {
    try {
      return firestore
          .collection("users")
          .where("score", isNotEqualTo: "")
          .snapshots()
          .map((query) {
        final List<ScoreModel> retVal = <ScoreModel>[];
        for (final DocumentSnapshot doc in query.docs) {
          retVal.add(ScoreModel.fromDocumentSnapshot(documentSnapshot: doc));
        }
        retVal.sort((a, b) => b.score.compareTo(a.score));
        return retVal;
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateScore({String uid, int score}) async {
    try {
      firestore.collection("users").doc(uid).get().then(
        (doc) {
          if (doc.exists) {
            final String h = doc.get("score").toString();
            final int hscore = int.parse(h);
            if (hscore < score) {
              firestore.collection("users").doc(uid).update(
                {
                  "score": score,
                },
              );
            }
          } else {
            firestore.collection("users").doc(uid).update(
              {
                "score": score,
              },
            );
          }
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setUsername({String uid, String name}) async {
    try {
      List<String> a;
      a = name.split("@");
      firestore.collection("users").doc(uid).set(
        {
          "name": a[0],
          "score": 0,
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}
