import 'package:flutter/material.dart';

class Wall extends StatelessWidget {
  final double size;
  const Wall({this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: size,
      color: Colors.green,
    );
  }
}
