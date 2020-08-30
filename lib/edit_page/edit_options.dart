import 'package:flutter/material.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import 'dart:math';

class EditOptions extends StatefulWidget {
  final Function addFloatingWidget;
  EditOptions({this.addFloatingWidget});
  @override
  _EditOptions createState() => _EditOptions();
}

class _EditOptions extends State<EditOptions> {
  Color _color = Colors.black;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      color: Colors.blue,
      child: ListView(
        padding: EdgeInsets.only(left: 5),
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          getListItem(_color, FeatherIcons.type, 'df'),
          // getListItem(_color, FeatherIcons.edit3, 'df'),
          // getListItem(_color, FeatherIcons.fileText, 'df')
        ],
      ),
    );
  }

  Widget getNewWidgetDummy() {
    return Text("Dummy 🚗");
  }

  Widget getListItem(Color color, IconData icon, String label) {
    return InkWell(
      child: Container(
        width: 50,
        child: Icon(
          icon,
          size: 30,
        ),
      ),
      onTap: () {
        widget.addFloatingWidget(getTextField());
      },
    );
  }

  Widget getTextField() {
    return MoveableTextField();
  }
}

class MoveableTextField extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MoveableTextField();
  }
}

class _MoveableTextField extends State<MoveableTextField> {
  double xPosition = 10;
  double yPosition = 10;
  double height = 50;
  double width = 100;
  String text = "Icecream in summer 🌞";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget textField = _editableTextField();
    return Positioned(
        top: yPosition,
        left: xPosition,
        child: GestureDetector(
            onPanUpdate: (tapInfo) {
              setState(() {
                width = max(25, width + tapInfo.delta.dx);
                height = max(25, height + tapInfo.delta.dy);
              });
            },
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(color: Colors.black, width: 1.0),
                  ),
                  child: textField,
                ),
                Align(
                  alignment: FractionalOffset.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.blue,
                    ),
                  ),
                )
              ],
            )));
  }

  Widget _editableTextField() {
    return GestureDetector(
      onPanUpdate: (tapInfo) {
        setState(() {
          xPosition += tapInfo.delta.dx;
          yPosition += tapInfo.delta.dy;
        });
      },
      child: Container(
        margin: EdgeInsets.all(5),
        height: height,
        width: width,
        child: Text(text),
      ),
    );
  }
}
