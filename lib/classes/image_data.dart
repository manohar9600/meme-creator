import 'dart:typed_data';

class ImageData {
  Uint8List imageData;
  bool isSelected = false;
  String imageLoc = '';
  ImageData({this.imageData, this.imageLoc});
}
