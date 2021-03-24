import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Center(
                child: Text(
              "Loading, Please Wait",
              textDirection: TextDirection.ltr,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlueAccent,
                  fontSize: 20),
            )),
            SizedBox(
              height: 20.0,
              width: 20.0,
            ),
            Center(
              child: SizedBox(
                height: 150.0,
                width: 150.0,
                child: CircularProgressIndicator(
                  strokeWidth: 15.0,
                  color: Color(0xff00b200),
                  backgroundColor: Color(0xff794C2B),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
