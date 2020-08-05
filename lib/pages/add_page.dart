import 'package:flutter/material.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";

class AddScreen extends StatefulWidget {
  final Function() onClose;
  AddScreen({@required this.onClose});
  @override
  _AddScreen createState() => _AddScreen(this.onClose);
}

class _AddScreen extends State<AddScreen> {
  final Function() onClose;
  _AddScreen(this.onClose);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(FeatherIcons.x, color: Colors.black),
          onPressed: () {
            returnToMainScreen(context);
          },
        ),
        title: Text("Edit", style: TextStyle(color: Colors.black)),
        // actions: <Widget>[
        //   IconButton(icon: Icon(FeatherIcons.arrowRight, color: Colors.black)),
        // ],
      ),
    );
  }

  void returnToMainScreen(BuildContext context) {
    Navigator.pop(context, true);
  }
}
