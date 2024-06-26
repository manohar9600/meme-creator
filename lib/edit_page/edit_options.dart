import 'package:flutter/material.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import 'text_edit.dart';

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
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => MoveableTextField(
        //               intialText: "",
        //               addFloatingWidget: widget.addFloatingWidget,
        //             )));
        Navigator.push(
            context,
            PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 100),
                pageBuilder: (context, animation, secondaryAnimation) {
                  animation = Tween(begin: 0.0, end: 1.0).animate(animation);
                  return FadeTransition(
                      opacity: animation,
                      child: MoveableTextField(
                        intialText: "",
                        addFloatingWidget: widget.addFloatingWidget,
                      ));
                },
                fullscreenDialog: true,
                opaque: false));
      },
    );
  }
}
