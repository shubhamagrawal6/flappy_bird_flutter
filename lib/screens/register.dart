import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flappy_bird_flutter/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Register extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final TextEditingController emailController;

  const Register({
    Key key,
    @required this.auth,
    @required this.firestore,
    @required this.emailController,
  }) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xff90F4C4),
      body: Builder(builder: (BuildContext context) {
        return Column(
          children: <Widget>[
            const SizedBox(
              height: 60,
            ),
            Center(child: Image.asset("assets/Title.png")),
            Expanded(
              child: Container(
                color: Colors.transparent,
                width: 360,
                child: Center(
                  child: Container(
                    height: 320,
                    width: 270,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF00B2FF),
                        width: 10.0,
                      ),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 220,
                            height: 50,
                            child: TextFormField(
                              key: const ValueKey("setusername"),
                              textAlign: TextAlign.left,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Color(0xffD7D7D7),
                                hintText: "Set Username",
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Icon(Icons.person),
                                ),
                              ),
                              controller: widget.emailController,
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          SizedBox(
                            width: 220,
                            height: 50,
                            child: TextFormField(
                              obscureText: true,
                              key: const ValueKey("setpassword"),
                              textAlign: TextAlign.left,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Color(0xffD7D7D7),
                                hintText: "Set Password",
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Icon(Icons.lock),
                                ),
                              ),
                              controller: _passwordController,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          // ignore: deprecated_member_use
                          RaisedButton(
                            key: const ValueKey("register"),
                            color: const Color(0xFF00B2FF),
                            onPressed: () async {
                              final String retVal =
                                  await Auth(auth: widget.auth).createAccount(
                                email: widget.emailController.text,
                                password: _passwordController.text,
                              );
                              HapticFeedback.lightImpact();
                              if (retVal == "Success") {
                                widget.emailController.clear();
                                _passwordController.clear();
                                Navigator.pop(context);
                              } else {
                                // ignore: deprecated_member_use
                                Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(retVal),
                                  ),
                                );
                              }
                            },
                            child: const Text(
                              "Register",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ]),
                  ),
                ),
              ),
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
        );
      }),
    );
  }
}
