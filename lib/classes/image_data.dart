import 'dart:typed_data';

class ImageData {
  Uint8List imageData;
  bool isSelected = false;
  String imageLoc = '';
  double scale = 1.0;
  ImageData({this.imageData, this.imageLoc});
}
