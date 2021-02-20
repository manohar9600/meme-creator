import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import '../classes/image.dart';
import '../edit_page/edit_page.dart';
import 'grid_view.dart';
import 'options.dart';

class MainGrid extends StatefulWidget {
  final List<ImageMetaData> selectedImagesMetaData;
  final int crossAxisCount;

  MainGrid(this.selectedImagesMetaData, this.crossAxisCount);
  @override
  _MainGrid createState() => _MainGrid();
}

class _MainGrid extends State<MainGrid> {
  List<ImageView> selectedImages = [];

  @override
  void initState() {
    super.initState();
    int row = -1;
    for (int i = 0; i < widget.selectedImagesMetaData.length; i++) {
      int _pos = i % widget.crossAxisCount;
      double colPosTag = double.parse("." + _pos.toString());
      if (colPosTag == 0) {
        row++;
      }
      double widgetPosTag = row + colPosTag;
      ImageView imageView = ImageView(
          imageData: widget.selectedImagesMetaData[i],
          width: null,
          height: null,
          imagePosition: Offset(0, 0),
          imageScale: 1.0,
          widgetPosTag: widgetPosTag,
          type: "image");
      selectedImages.add(imageView);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget frameWidget =
        GridViewCustom(selectedImages: selectedImages, draggable: true);
    return Scaffold(
        appBar: _getAppBar(context),
        body: Column(
          children: [
            Flexible(
              fit: FlexFit.tight,
              flex: 8,
              child: Container(
                child: frameWidget,
              ),
            ),
            Flexible(flex: 1, fit: FlexFit.tight, child: getMenuBar())
          ],
        ));
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

  void addTitleTextBox() async {
    double height = 20;
    GlobalKey widgetKey = new GlobalKey();
    double colPosTag = 0.0;
    double row = 0.0;
    double widgetPosTag = row + colPosTag;
    Widget titleBackgroundWidget = RepaintBoundary(
      key: widgetKey,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: height,
        color: Colors.yellow,
      ),
    );
    ImageView imageView = ImageView(
        childWidget: titleBackgroundWidget,
        width: MediaQuery.of(context).size.width,
        height: height,
        imagePosition: Offset(0, 0),
        imageScale: 1.0,
        widgetPosTag: widgetPosTag,
        type: "title");
    for (ImageView imageView in selectedImages) {
      imageView.widgetPosTag += 1.0;
    }
    setState(() {
      selectedImages.add(imageView);
    });
  }

  Widget getMenuBar() {
    return Container(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          verticalDirection: VerticalDirection.up,
          children: <Widget>[GridEditOptions(fun1: addTitleTextBox)],
        ),
      ),
    );
  }
}
