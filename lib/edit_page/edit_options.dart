import 'package:flutter/material.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import 'dart:math';
import 'package:badges/badges.dart';

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
  String text = "";
  bool _hasFocus = true;
  FocusNode _node = FocusNode();
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _node.addListener(_handleFocusChange);
    _controller.addListener(_handleTextInput);
  }

  void _handleFocusChange() {
    if (_node.hasFocus != _hasFocus) {
      setState(() {
        _hasFocus = _node.hasFocus;
      });
    }
  }

  void _handleTextInput() {
    text = _controller.text;
    _controller.value = _controller.value.copyWith(
      text: text,
      selection:
          TextSelection(baseOffset: text.length, extentOffset: text.length),
      composing: TextRange.empty,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget focusedWidget = Badge(
        badgeContent: GestureDetector(
          onPanUpdate: (tapInfo) {
            setState(() {
              width = max(50, width + tapInfo.delta.dx);
              height = max(50, height + tapInfo.delta.dy);
            });
          },
          child: Text("."),
        ),
        badgeColor: Colors.blue,
        showBadge: _hasFocus,
        position: BadgePosition.bottomRight(bottom: -10, right: -5),
        child: Expanded(
          child: Container(
            height: height,
            width: width,
            padding: EdgeInsets.only(left: 5, top: 0),
            decoration: _hasFocus
                ? BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(color: Colors.black, width: 1.0),
                  )
                : BoxDecoration(),
            child: _editableTextField(),
          ),
        ));

    return Positioned(
      top: yPosition,
      left: xPosition,
      child: focusedWidget,
    );
  }

  Widget _editableTextField() {
    return GestureDetector(
      onPanUpdate: (tapInfo) {
        setState(() {
          xPosition += tapInfo.delta.dx;
          yPosition += tapInfo.delta.dy;
        });
      },
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
            border: InputBorder.none, hintText: _hasFocus ? "Enter text" : ""),
        autofocus: true,
        maxLines: null,
        minLines: null,
        focusNode: _node,
      ),
    );
  }

  void dispose() {
    _node.dispose();
    _controller.dispose();
    super.dispose();
  }
}
