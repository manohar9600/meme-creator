import 'package:flutter/material.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import '../classes/image_data.dart';
import 'edit_page.dart';

class AddScreen extends StatefulWidget {
  @override
  _AddScreen createState() => _AddScreen();
}

class _AddScreen extends State<AddScreen> {
  List<ImageData> selectedImages = [];
  List<Widget> images;
  bool editPage = false;

  _AddScreen() {
    this.images = [
      ImageItemWidget(
          imageData: ImageData(imageLoc: "images/template1.jpg"),
          onImageClick: _onImageClick),
      ImageItemWidget(
          imageData: ImageData(imageLoc: "images/template1.jpg"),
          onImageClick: _onImageClick),
      ImageItemWidget(
          imageData: ImageData(imageLoc: "images/template1.jpg"),
          onImageClick: _onImageClick),
      ImageItemWidget(
          imageData: ImageData(imageLoc: "images/template1.jpg"),
          onImageClick: _onImageClick),
      ImageItemWidget(
          imageData: ImageData(imageLoc: "images/template1.jpg"),
          onImageClick: _onImageClick),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: !editPage
          ? getBodyWidget()
          : EditPage(selectedImages: selectedImages),
      // bottomNavigationBar: NavigationBar(),
    );
  }

  Widget getAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(FeatherIcons.x, color: Colors.black),
        onPressed: () {
          returnToMainScreen(context);
        },
      ),
      title: Text("Edit", style: TextStyle(color: Colors.black)),
      actions: <Widget>[
        IconButton(
          icon: Icon(FeatherIcons.arrowRight, color: Colors.black),
          onPressed: () {
            navigateToEditPage();
          },
        ),
      ],
    );
  }

  Widget getBodyWidget() {
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        children: <Widget>[LocalImagesRow(images)],
      ),
    );
  }

  void returnToMainScreen(BuildContext context) {
    Navigator.pop(context, true);
  }

  void _onImageClick(ImageData clickedImage, bool isSelected) {
    if (isSelected) {
      selectedImages.add(clickedImage);
    } else {
      selectedImages.remove(clickedImage);
    }
  }

  void navigateToEditPage() {
    setState(() {
      editPage = true;
    });
  }
}

class LocalImagesRow extends StatefulWidget {
  final images;
  LocalImagesRow(this.images);
  @override
  _LocalImageRow createState() => _LocalImageRow();
}

class _LocalImageRow extends State<LocalImagesRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 20.0),
        // alignment: Alignment.topLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            getTextNormalHeading("Local images"),
            SizedBox(
              height: 10.0,
            ),
            getImagesRow()
          ],
        ));
  }

  Widget getTextNormalHeading(String text) {
    TextStyle style = TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500);
    return Container(
        alignment: Alignment.topLeft, child: Text(text, style: style));
  }

  Widget getImagesRow() {
    return Container(
      height: 110.0,
      // color: Colors.yellow,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.images.length >= 24 ? 24 : widget.images.length,
        itemBuilder: (BuildContext context, int index) {
          return widget.images[index];
        },
      ),
    );
  }
}

class ImageItemWidget extends StatefulWidget {
  final ImageData imageData;
  final Function onImageClick;
  ImageItemWidget({@required this.imageData, @required this.onImageClick});
  @override
  _ImageItemWidget createState() => _ImageItemWidget();
}

class _ImageItemWidget extends State<ImageItemWidget> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    Widget imageBox = InkWell(
      child: getImageStack(),
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
        widget.onImageClick(widget.imageData, isSelected);
      },
    );
    return imageBox;
  }

  Widget getImageStack() {
    return Stack(
      children: <Widget>[
        Container(
          height: 100.0,
          width: 100.0,
          margin: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10.0)),
          child: FittedBox(
            fit: BoxFit.fill,
            child: Image(
              image: AssetImage(widget.imageData.imageLoc),
              color: Colors.black.withOpacity(isSelected ? 0.9 : 0),
              colorBlendMode: BlendMode.color,
            ),
          ),
        ),
        isSelected
            ? Align(
                alignment: FractionalOffset.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.blue,
                  ),
                ),
              )
            : Container()
      ],
    );
  }
}
