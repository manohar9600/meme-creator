import 'package:flutter/material.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";

class GridEditOptions extends StatefulWidget {
  final Function fun1;
  GridEditOptions({this.fun1});
  @override
  _GridEditOptions createState() => _GridEditOptions();
}

class _GridEditOptions extends State<GridEditOptions> {
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
        widget.fun1();
      },
    );
  }
}
