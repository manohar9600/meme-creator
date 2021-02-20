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
  String type = "";
  Widget childWidget;
  ImageView(
      {this.imageData,
      this.childWidget,
      @required this.width,
      @required this.height,
      @required this.imagePosition,
      @required this.imageScale,
      @required this.widgetPosTag,
      @required this.type});
}
