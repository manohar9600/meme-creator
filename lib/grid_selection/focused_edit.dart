import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class FocusedEdit extends StatefulWidget {
  final Offset childOffset;
  final Size childSize;
  final Widget child;
  final Function updateImageZoom;
  final double initScale;
  final double xPosition;
  final double yPosition;
  final Function updatePosition;
  FocusedEdit(
      {Key key,
      @required this.childOffset,
      @required this.childSize,
      @required this.child,
      @required this.updateImageZoom,
      @required this.initScale,
      @required this.xPosition,
      @required this.yPosition,
      @required this.updatePosition})
      : super(key: key);

  @override
  _FocusedEditState createState() => _FocusedEditState();
}

class _FocusedEditState extends State<FocusedEdit> {
  double scale = 1.0;
  double _previousScale = 1.0;
  double xPosition = 0;
  double yPosition = 0;
  bool isZooming = false;

  @override
  void initState() {
    super.initState();
    scale = widget.initScale;
    _previousScale = scale;
    xPosition = widget.xPosition;
    yPosition = widget.yPosition;
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = Transform.translate(
      offset: Offset(xPosition, yPosition),
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.diagonal3(Vector3(scale, scale, scale)),
        child: widget.child,
      ),
    );
    Widget gesturesWidget = GestureDetector(
        // zoom functions
        onScaleStart: (ScaleStartDetails details) {
          isZooming = true;
          setState(() {});
        },
        onScaleUpdate: (ScaleUpdateDetails details) {
          double presentScale = details.scale - 1;
          // if (isZooming) {

          //   // print(scale);
          // }
          if (presentScale < 0) {
            presentScale = presentScale * 2;
          } else {
            presentScale = presentScale * 1.3;
          }
          scale = _previousScale + presentScale;
          widget.updateImageZoom(scale);
          setState(() {});
        },
        onScaleEnd: (ScaleEndDetails details) {
          if (isZooming) {
            isZooming = false;
            _previousScale = scale;
            setState(() {});
          }
        },
        child: GestureDetector(
          onHorizontalDragUpdate: (DragUpdateDetails details) {
            if (!isZooming) {
              setState(() {
                xPosition += (details.delta.dx * 2);
              });
              widget.updatePosition(xPosition, yPosition);
            }
          },
          onVerticalDragUpdate: (DragUpdateDetails details) {
            if (!isZooming) {
              setState(() {
                yPosition += (details.delta.dy * 2);
              });
              widget.updatePosition(xPosition, yPosition);
            }
          },
          child: Container(
              width: widget.childSize.width,
              height: widget.childSize.height,
              child: ClipRect(child: imageWidget)),
        ));
    return Scaffold(
        // appBar: AppBar(),
        backgroundColor: Colors.transparent,
        body: Container(
          child: Stack(
            children: <Widget>[
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),
              ),
              Positioned(
                top: widget.childOffset.dy,
                left: widget.childOffset.dx,
                child: Container(
                    width: widget.childSize.width,
                    height: widget.childSize.height,
                    child: ClipRect(child: gesturesWidget)),
              ),
            ],
          ),
        ));
  }
}
