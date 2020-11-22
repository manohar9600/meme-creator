import 'dart:ui';
import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../classes/image_data.dart';
import 'package:gesture_x_detector/gesture_x_detector.dart';

class FocusedEdit extends StatefulWidget {
  final Offset childOffset;
  final Size childSize;
  final ImageData imageData;
  final Function updateImageZoom;
  final double initScale;
  final double xPosition;
  final double yPosition;
  final Function updatePosition;
  FocusedEdit(
      {Key key,
      @required this.childOffset,
      @required this.childSize,
      @required this.imageData,
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
  double minScale = 0.3;
  double maxScale = 6;

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
      child: Transform.scale(
        alignment: Alignment.center,
        scale: scale,
        child: Image.memory(widget.imageData.imageData),
      ),
    );
    Widget gesturesWidget = getGesturesWidget(imageWidget, context);
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

  Widget getGesturesWidget(Widget imageWidget, BuildContext context) {
    Widget gesturesWidget = XGestureDetector(
      child: imageWidget,
      onScaleUpdate: (changedFocusPoint, _scale, rotationAngle) {
        double presentScale = _scale - 1;
        if (presentScale < 0) {
          presentScale = presentScale * 2;
        } else {
          presentScale = presentScale * 1.3;
        }
        double newScale = _previousScale + presentScale;
        scale = newScale;
        widget.updateImageZoom(scale);
        setState(() {});
      },
      onScaleEnd: () {
        if (scale > maxScale) {
          scale = maxScale;
          widget.updateImageZoom(scale);
        }
        if (scale < minScale) {
          scale = minScale;
          widget.updateImageZoom(scale);
        }
        _previousScale = scale;
        setState(() {});
      },
      onMoveUpdate: (localPos, position, localDelta, delta) {
        double _xPosition = xPosition + delta.dx;
        double _yPosition = yPosition + delta.dy;
        // TODO: Improve this drag limiting
        double xPostionLimit = widget.childSize.width * 0.7 * (scale / 2);
        double yPostionLimit = widget.childSize.height * 0.7 * (scale / 2);
        if (_xPosition.abs() < xPostionLimit) {
          xPosition = _xPosition;
        }
        if (_yPosition.abs() < yPostionLimit) {
          yPosition = _yPosition;
        }
        setState(() {});
        widget.updatePosition(xPosition, yPosition);
        print(_yPosition);
      },
    );
    return gesturesWidget;
  }
}
