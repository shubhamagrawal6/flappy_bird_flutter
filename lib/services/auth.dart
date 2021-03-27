import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flappy_bird_flutter/services/database.dart';

class Auth {
  final FirebaseAuth auth;

  Auth({this.auth});

  Stream<User> get user => auth.authStateChanges();

  Future<String> createAccount({
    String email,
    String password,
    FirebaseFirestore firestore,
  }) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      Database(firestore: firestore).setUsername(
        uid: auth.currentUser.uid,
        name: auth.currentUser.email,
      );
      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> signIn({String email, String password}) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> signOut() async {
    try {
      await auth.signOut();
      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> removeAccount() async {
    try {
      await auth.currentUser.delete();
      return "Account deleted";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> resetPassword({String email}) async {
    try {
      await auth.sendPasswordResetEmail(
        email: email.trim(),
      );
      return "Please check E-mail";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      rethrow;
    }
  }
}
