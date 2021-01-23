import 'package:flutter/material.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import '../../classes/image.dart';
import '../../edit_page/edit_page.dart';
import '../grid_view.dart';

class G1 extends StatelessWidget {
  final List<ImageMetaData> selectedImagesMetaData;
  final int crossAxisCount;
  final List<ImageView> selectedImages = [];
  G1(this.selectedImagesMetaData, this.crossAxisCount) {
    int row = -1;
    for (int i = 0; i < this.selectedImagesMetaData.length; i++) {
      int _pos = i % this.crossAxisCount;
      double colPosTag = double.parse("." + _pos.toString());
      if (colPosTag == 0) {
        row++;
      }
      double widgetPosTag = row + colPosTag;
      ImageView imageView = ImageView(
          imageData: this.selectedImagesMetaData[i],
          width: null,
          height: null,
          imagePosition: Offset(0, 0),
          imageScale: 1.0,
          widgetPosTag: widgetPosTag);
      selectedImages.add(imageView);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget frameWidget =
        GridViewCustom(selectedImages: selectedImages, draggable: true);
    return Scaffold(appBar: _getAppBar(context), body: frameWidget);
  }

  Widget _getAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(FeatherIcons.arrowLeft, color: Colors.black),
        onPressed: () {
          Navigator.pop(context, true);
        },
      ),
      title: Text("Edit", style: TextStyle(color: Colors.black)),
      actions: <Widget>[
        IconButton(
          icon: Icon(FeatherIcons.arrowRight, color: Colors.black),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditPage(
                          selectedImages: selectedImages,
                        )));
          },
        )
      ],
    );
  }
}
