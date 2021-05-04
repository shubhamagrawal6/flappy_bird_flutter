import 'package:flutter/material.dart';

class Error extends StatefulWidget {
  @override
  _ErrorState createState() => _ErrorState();
}

class _ErrorState extends State<Error> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black,
        child: const Center(
            child: Text(
          "Error, Please Restart",
          textDirection: TextDirection.ltr,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
              fontSize: 20),
        )));
  }
}
