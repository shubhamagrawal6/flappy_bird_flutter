import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flappy_bird_flutter/screens/register.dart';
import 'package:flappy_bird_flutter/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Login extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const Login({
    Key key,
    @required this.auth,
    @required this.firestore,
  }) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
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
                              key: const ValueKey("username"),
                              textAlign: TextAlign.left,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Color(0xffD7D7D7),
                                hintText: "Username",
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Icon(Icons.person),
                                ),
                              ),
                              controller: _emailController,
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          SizedBox(
                            width: 220,
                            height: 50,
                            child: TextFormField(
                              obscureText: true,
                              key: const ValueKey("password"),
                              textAlign: TextAlign.left,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Color(0xffD7D7D7),
                                hintText: "Password",
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Icon(Icons.lock),
                                ),
                              ),
                              controller: _passwordController,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                              onPressed: () async {
                                HapticFeedback.lightImpact();
                                final String retVal =
                                    await Auth(auth: widget.auth).resetPassword(
                                  email: _emailController.text,
                                );
                                if (retVal == "Success") {
                                  _emailController.clear();
                                  _passwordController.clear();
                                } else {
                                  // ignore: deprecated_member_use
                                  Scaffold.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(retVal),
                                    ),
                                  );
                                }
                              },
                              child: const Text("Forgot Password?"),
                            ),
                          ),
                          // ignore: deprecated_member_use
                          RaisedButton(
                            key: const ValueKey("signIn"),
                            color: const Color(0xFF00B2FF),
                            onPressed: () async {
                              HapticFeedback.lightImpact();
                              final String retVal =
                                  await Auth(auth: widget.auth).signIn(
                                email: _emailController.text,
                                password: _passwordController.text,
                              );
                              if (retVal == "Success") {
                                _emailController.clear();
                                _passwordController.clear();
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
                              "Log In",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Register(
                                    auth: widget.auth,
                                    firestore: widget.firestore,
                                    emailController: _emailController,
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              "Register",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
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
              width: 3000,
            ),
            Container(
              color: Colors.brown,
              height: 160,
              width: 3000,
            ),
          ],
        );
      }),
    );
  }
}
