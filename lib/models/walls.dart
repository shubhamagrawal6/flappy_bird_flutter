import 'package:flutter/material.dart';

class Wall extends StatelessWidget {
  final double size;
  Wall({this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: size,
      decoration: BoxDecoration(
        color: Colors.green,
        border: Border.all(width: 5, color: Color(0xFF038D00)),
      ),
    );
  }
}
