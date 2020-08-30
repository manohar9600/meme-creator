import 'package:flutter/material.dart';

class EditOptions2 extends StatefulWidget {
  @override
  _EditOptions2 createState() => _EditOptions2();
}

class _EditOptions2 extends State<EditOptions2> {
  Color _color = Colors.black;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      // color: Colors.green,
      child: ListView(
        padding: EdgeInsets.only(left: 5),
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          getListItem(_color, Icons.collections_bookmark, 'Presets'),
          // getListItem(_color, FeatherIcons.edit3, 'df'),
          // getListItem(_color, FeatherIcons.fileText, 'df')
        ],
      ),
    );
  }

  Widget getListItem(Color color, IconData icon, String label) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.only(top: 10),
        width: 50,
        child: Column(
          children: <Widget>[
            Icon(
              icon,
              size: 30,
            ),
            Text(
              label,
              style: TextStyle(fontSize: 12),
            )
          ],
        ),
      ),
      onTap: () {
        print("Clicked on imagesdfasdfasdfasdf");
      },
    );
  }
}
