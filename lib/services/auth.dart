import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth auth;

  Auth({this.auth});

  Stream<User> get user => auth.authStateChanges();

  Future<String> createAccount({String email, String password}) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return "Successfully Registered\nWelcome";
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
      return "Signed In Successfully\nWelcome";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> signOut() async {
    try {
      await auth.signOut();
      return "Signed Out Successfully";
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
