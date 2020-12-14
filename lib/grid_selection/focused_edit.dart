import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../classes/image.dart';
import 'package:gesture_x_detector/gesture_x_detector.dart';

class FocusedEdit extends StatefulWidget {
  final ImageView imageView;
  final Function updateImageView;
  final Offset globalOffset;
  final double height;
  final double width;
  FocusedEdit(
      {Key key,
      @required this.imageView,
      @required this.updateImageView,
      @required this.height,
      @required this.width,
      this.globalOffset})
      : super(key: key);

  @override
  _FocusedEditState createState() => _FocusedEditState();
}

class _FocusedEditState extends State<FocusedEdit> {
  ImageView imageView;
  double _previousScale = 1.0;
  double minScale = 0.3;
  double maxScale = 6;

  @override
  void initState() {
    super.initState();
    this.imageView = widget.imageView;
    _previousScale = imageView.imageScale;
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = Container(
        width: widget.width,
        height: widget.height,
        child: ImageViewWidget(imageView: imageView));
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
                top: widget.globalOffset.dy,
                left: widget.globalOffset.dx,
                child: gesturesWidget,
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
        imageView.imageScale = newScale;
        widget.updateImageView(imageView);
        setState(() {});
      },
      onScaleEnd: () {
        if (imageView.imageScale > maxScale) {
          imageView.imageScale = maxScale;
        }
        if (imageView.imageScale < minScale) {
          imageView.imageScale = minScale;
        }
        widget.updateImageView(imageView);
        _previousScale = imageView.imageScale;
        setState(() {});
      },
      onMoveUpdate: (localPos, position, localDelta, delta) {
        Offset _prevPosition = imageView.imagePosition;
        double _xPosition = _prevPosition.dx + delta.dx;
        double _yPosition = _prevPosition.dy + delta.dy;
        // TODO: Improve this drag limiting
        double xPostionLimit =
            imageView.width * 0.7 * (imageView.imageScale / 2);
        double yPostionLimit =
            imageView.height * 0.7 * (imageView.imageScale / 2);
        if (_xPosition.abs() < xPostionLimit || true) {
          _prevPosition = Offset(_xPosition, _prevPosition.dy);
        }
        if (_yPosition.abs() < yPostionLimit || true) {
          _prevPosition = Offset(_prevPosition.dx, _yPosition);
        }
        setState(() {});
        imageView.imagePosition = _prevPosition;
        widget.updateImageView(imageView);
      },
    );
    return gesturesWidget;
  }
}
