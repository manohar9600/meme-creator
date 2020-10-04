import 'package:flutter/material.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import 'dart:math';
import 'package:badges/badges.dart';

class Coords {
  Key previousWidgetKey;
  double xPosition = 10;
  double yPosition = 10;
  double height = 50;
  double width = 100;
}

class _TextStyle {
  FontStyle fontStyle = FontStyle.normal;
  FontWeight fontWeight = FontWeight.normal;
}

class MoveableTextField extends StatefulWidget {
  final Function addFloatingWidget;
  final String intialText;
  final Function changeText;
  final _TextStyle textStyle;
  MoveableTextField(
      {this.addFloatingWidget,
      this.intialText,
      this.changeText,
      this.textStyle});
  @override
  State<StatefulWidget> createState() {
    return _MoveableTextField();
  }
}

class _MoveableTextField extends State<MoveableTextField> {
  String text = "";
  TextEditingController _controller;
  _TextStyle textStyle = _TextStyle();
  List activeTextControls = [false, false, false];

  @override
  void initState() {
    super.initState();
    text = widget.intialText;
    _controller = TextEditingController(text: widget.intialText);
    _controller.addListener(_handleTextInput);
    if (widget.textStyle != null) {
      textStyle = widget.textStyle;
      if (textStyle.fontWeight == FontWeight.bold) {
        activeTextControls[0] = true;
      }
      if (textStyle.fontStyle == FontStyle.italic) {
        activeTextControls[1] = true;
      }
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
    return Scaffold(
      body: _getBodyWidget(),
    );
  }

  Widget _getBodyWidget() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.4,
          child: Container(
            color: Colors.black,
          ),
        ),
        AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(FeatherIcons.arrowLeft, color: Colors.transparent),
            onPressed: () {},
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(FeatherIcons.check, color: Colors.white70),
              onPressed: () {
                if (widget.changeText != null) {
                  widget.changeText(text, textStyle);
                } else {
                  widget.addFloatingWidget(MovableWidget(
                    text: text,
                    addFloatingWidget: widget.addFloatingWidget,
                    textStyle: textStyle,
                  ));
                }
                Navigator.pop(context);
              },
            )
          ],
        ),
        Center(
          child: _getTextWidget(),
        ),
        getWeightControls()
      ],
    );
  }

  Widget _getTextWidget() {
    final fontSize = 35.0;
    return Container(
        child: TextField(
      controller: _controller,
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Enter text",
          hintStyle: TextStyle(
            color: Colors.white70,
            fontSize: fontSize,
          )),
      autofocus: true,
      maxLines: null,
      minLines: null,
      style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: textStyle.fontWeight,
          fontStyle: textStyle.fontStyle),
      textAlign: TextAlign.center,
    ));
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget getWeightControls() {
    Widget controlsWidget = Align(
      alignment: Alignment.bottomRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          getWeightControl("B", 0, FontWeight.bold, FontStyle.normal),
          getWeightControl("I", 1, FontWeight.normal, FontStyle.italic),
          getWeightControl("U", 2, FontWeight.normal, FontStyle.normal),
        ],
      ),
    );
    return controlsWidget;
  }

  Widget getWeightControl(
      String text, int index, FontWeight fontWeight, FontStyle fontStyle) {
    return GestureDetector(
      onTap: () => changeFontStyle(text),
      child: Container(
          margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
          padding: EdgeInsets.only(bottom: 5, top: 5, left: 10, right: 10),
          decoration: BoxDecoration(
              // border: Border.all(width: 2),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: activeTextControls[index] ? Colors.black54 : null),
          child: Text(text,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 35.0,
                  fontWeight: fontWeight,
                  fontStyle: fontStyle))),
    );
  }

  void changeFontStyle(String styleText) {
    switch (styleText) {
      case 'B':
        {
          setState(() {
            if (textStyle.fontWeight == FontWeight.normal) {
              textStyle.fontWeight = FontWeight.bold;
              activeTextControls[0] = true;
            } else {
              textStyle.fontWeight = FontWeight.normal;
              activeTextControls[0] = false;
            }
          });
        }
        break;
      case 'I':
        {
          setState(() {
            if (textStyle.fontStyle == FontStyle.normal) {
              textStyle.fontStyle = FontStyle.italic;
              activeTextControls[1] = true;
            } else {
              textStyle.fontStyle = FontStyle.normal;
              activeTextControls[1] = false;
            }
          });
        }
        break;
      default:
        {
          setState(() {
            textStyle.fontWeight = FontWeight.normal;
            textStyle.fontStyle = FontStyle.normal;
            activeTextControls[0] = false;
            activeTextControls[1] = false;
          });
        }
    }
  }
}

class MovableWidget extends StatefulWidget {
  final String text;
  final Function addFloatingWidget;
  final Coords rectCoords;
  final _TextStyle textStyle;
  MovableWidget(
      {this.text, this.addFloatingWidget, this.rectCoords, this.textStyle});
  @override
  _MovableWidget createState() => _MovableWidget(this.text, this.textStyle);
}

class _MovableWidget extends State<MovableWidget> {
  bool _hasFocus = true;
  Coords rectCoords = Coords();
  FocusNode _node = FocusNode();
  String _text;
  _TextStyle textStyle = _TextStyle();

  _MovableWidget(String text, _TextStyle textStyle) {
    _text = text;
    this.textStyle = textStyle;
  }

  @override
  void initState() {
    super.initState();
    if (widget.rectCoords != null) {
      rectCoords = widget.rectCoords;
    }
    _node.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (_node.hasFocus != _hasFocus) {
      setState(() {
        _hasFocus = _node.hasFocus;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget focusedWidget = Badge(
        badgeContent: GestureDetector(
          onPanUpdate: (tapInfo) {
            setState(() {
              rectCoords.width = max(50, rectCoords.width + tapInfo.delta.dx);
              rectCoords.height = max(50, rectCoords.height + tapInfo.delta.dy);
              rectCoords.width =
                  min(rectCoords.width, MediaQuery.of(context).size.width);
              rectCoords.height =
                  min(rectCoords.height, MediaQuery.of(context).size.height);
            });
          },
          child: Text(
            ".",
            style: TextStyle(fontSize: 20),
          ),
        ),
        badgeColor: Colors.blue,
        showBadge: _hasFocus,
        position: BadgePosition.bottomRight(bottom: -13, right: -4),
        child: Container(
          height: rectCoords.height,
          width: rectCoords.width,
          padding: EdgeInsets.only(left: 5, top: 0),
          decoration: _hasFocus
              ? BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(color: Colors.white, width: 1.5),
                )
              : BoxDecoration(),
          child: _getTextWidget(),
        ));

    return Positioned(
        top: rectCoords.yPosition,
        left: rectCoords.xPosition,
        child: Focus(
          autofocus: true,
          child: focusedWidget,
          focusNode: _node,
        ));
  }

  Widget _getTextWidget() {
    return GestureDetector(
        onPanUpdate: (tapInfo) {
          setState(() {
            rectCoords.xPosition += tapInfo.delta.dx;
            rectCoords.yPosition += tapInfo.delta.dy;
          });
        },
        onTap: () {
          setState(() {
            _hasFocus = true;
            _node.requestFocus();
          });
        },
        onDoubleTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MoveableTextField(
                      intialText: _text,
                      addFloatingWidget: widget.addFloatingWidget,
                      changeText: changeWidgetState,
                      textStyle: textStyle)));
        },
        child: FittedBox(
          child: Text(
            _text,
            style: TextStyle(
                color: Colors.white,
                fontWeight: textStyle.fontWeight,
                fontStyle: textStyle.fontStyle),
          ),
        ));
  }

  changeWidgetState(String text, _TextStyle textStyle) {
    setState(() {
      _text = text;
      this.textStyle = textStyle;
    });
  }
}
