import 'dart:typed_data';
import 'package:flutter/material.dart';

class ImageData {
  Uint8List imageData;
  bool isSelected = false;
  String imageLoc = '';
  double scale = 1.0;
  final int height;
  final int width;
  ImageData(
      {this.imageData,
      this.imageLoc,
      @required this.height,
      @required this.width});
}
