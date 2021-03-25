import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flappy_bird_flutter/services/auth.dart';
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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        return Center(
          // Important Notice: Create sign-out button first, layout present in figma
          child: RaisedButton(
            key: const ValueKey("signIn"),
            color: Colors.indigoAccent,
            onPressed: () async {
              final String retVal = await Auth(auth: widget.auth).signOut();
              HapticFeedback.lightImpact();
              if (retVal == "Success") {
                _emailController.clear();
                _passwordController.clear();
              } else {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(retVal),
                  ),
                );
              }
            },
            child: const Text("Sign Out"),
          ),
        );
      }),
    );
  }
}
