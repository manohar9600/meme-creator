import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../classes/image_data.dart';

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
  bool isZooming = false;
  double minScale = 0.3;
  double maxScale = 4;

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
    Widget gesturesWidget = getGesturesWidget(imageWidget);
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

  Widget getGesturesWidget(Widget imageWidget) {
    Widget gesturesWidget = RawGestureDetector(
      gestures: <Type, GestureRecognizerFactory>{
        CustomScaleGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<CustomScaleGestureRecognizer>(
                () => CustomScaleGestureRecognizer(),
                (CustomScaleGestureRecognizer instance) {
          instance.onUpdate = (ScaleUpdateDetails details) {
            double presentScale = details.scale - 1;
            if (presentScale < 0) {
              presentScale = presentScale * 2;
            } else {
              presentScale = presentScale * 1.3;
            }
            double newScale = _previousScale + presentScale;
            if (newScale >= minScale && newScale <= maxScale) {
              scale = newScale;
              widget.updateImageZoom(scale);
              setState(() {});
            }
          };
          instance.onEnd = (ScaleEndDetails details) {
            _previousScale = scale;
          };
        })
      },
      child: RawGestureDetector(
        gestures: <Type, GestureRecognizerFactory>{
          CustomHorizontalDragRecognizer: GestureRecognizerFactoryWithHandlers<
                  CustomHorizontalDragRecognizer>(
              () => CustomHorizontalDragRecognizer(),
              (CustomHorizontalDragRecognizer instance) {
            instance.onUpdate = (DragUpdateDetails details) {
              setState(() {
                xPosition += (details.delta.dx);
              });
              widget.updatePosition(xPosition, yPosition);
            };
          }),
          CustomVerticalDragRecognizer: GestureRecognizerFactoryWithHandlers<
                  CustomVerticalDragRecognizer>(
              () => CustomVerticalDragRecognizer(),
              (CustomVerticalDragRecognizer instance) {
            instance.onUpdate = (DragUpdateDetails details) {
              setState(() {
                yPosition += (details.delta.dy);
              });
              widget.updatePosition(xPosition, yPosition);
            };
          }),
        },
        child: imageWidget,
      ),
    );
    return gesturesWidget;
  }
}

class CustomScaleGestureRecognizer extends ScaleGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer);
  }
}

class CustomHorizontalDragRecognizer extends HorizontalDragGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer);
  }
}

class CustomVerticalDragRecognizer extends VerticalDragGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer);
  }
}
