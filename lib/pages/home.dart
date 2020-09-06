import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      "HOME",
      style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Color(int.parse("0xFF333333"))),
    ));
  }
}
