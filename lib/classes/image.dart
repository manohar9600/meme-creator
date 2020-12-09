import 'dart:typed_data';
import 'package:flutter/material.dart';

class ImageMetaData {
  Uint8List imageData;
  String imageLoc = '';
  final int height;
  final int width;
  ImageMetaData(
      {this.imageData,
      this.imageLoc,
      @required this.height,
      @required this.width});
}

class ImageView {
  ImageMetaData imageData;
  double width;
  double height;
  Offset imagePosition;
  double imageScale;
  double widgetPosTag;
  ImageView(
      {@required this.imageData,
      @required this.width,
      @required this.height,
      @required this.imagePosition,
      @required this.imageScale,
      @required this.widgetPosTag});
}

class ImageViewWidget extends StatefulWidget {
  // Widget that show image in desired view.
  final Key key;
  final ImageView imageView;
  ImageViewWidget({this.key, @required this.imageView});
  @override
  _ImageViewWidget createState() => _ImageViewWidget();
}

class _ImageViewWidget extends State<ImageViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.imageView.height,
        width: widget.imageView.width,
        child: ClipRect(
          child: Transform.translate(
            offset: widget.imageView.imagePosition,
            child: Transform.scale(
              alignment: Alignment.center,
              scale: widget.imageView.imageScale,
              child: Image.memory(widget.imageView.imageData.imageData),
            ),
          ),
        ));
  }
}
