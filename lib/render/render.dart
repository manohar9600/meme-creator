import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import 'package:image_gallery_saver/image_gallery_saver.dart';

class RenderWidget extends StatefulWidget {
  final stackKey;
  RenderWidget({this.stackKey});
  @override
  _RenderWidget createState() => _RenderWidget();
}

class _RenderWidget extends State<RenderWidget> {
  Random rng = new Random();
  Image renderedImage;
  Uint8List _pngBytes;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    if (renderedImage == null) {
      takeScreenshot();
    }
    return Scaffold(
        key: _scaffoldKey, appBar: getAppBar(), body: _getBodyWidget());
  }

  Widget getAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(FeatherIcons.arrowLeft, color: Colors.black),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text("Render", style: TextStyle(color: Colors.black)),
    );
  }

  Widget _getBodyWidget() {
    Widget bodyWidget = Column(
      children: <Widget>[
        Container(
          height: 300,
          child: renderedImage != null
              ? renderedImage
              : Center(
                  child: Text("Loading......"),
                ),
        ),
        Container(
          height: 60,
          margin: EdgeInsets.only(top: 25),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Center(
                child: _getButton(_share, 'SHARE'),
              )),
              Expanded(
                child: Center(
                  child: _getButton(_download, 'DOWNLOAD'),
                ),
              )
            ],
          ),
        )
      ],
    );
    return bodyWidget;
  }

  Widget _getButton(Function onclick, String text) {
    return InkWell(
      child: Container(
        width: 120,
        height: 50,
        decoration: BoxDecoration(
            color: Color(int.parse("0xFFF46C00")),
            borderRadius: BorderRadius.all(Radius.circular(100)),
            boxShadow: [
              BoxShadow(color: Colors.grey, blurRadius: 2, offset: Offset(1, 1))
            ]),
        child: Center(
            child: Text(
          text,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
        )),
      ),
      onTap: () {
        onclick();
      },
    );
  }

  void takeScreenshot() async {
    // unfocuses all widgets.
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
    await Future.delayed(Duration(seconds: 2));
    RenderRepaintBoundary boundary =
        widget.stackKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    setState(() {
      _pngBytes = pngBytes;
      renderedImage = Image.memory(pngBytes);
    });
  }

  void _share() {
    print("share");
    final snackBar = SnackBar(
      backgroundColor: Colors.white,
      content: Container(
          height: 50,
          decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(100))),
          child: Center(
              child: Text(
            "Feature coming soon.....",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ))),
      duration: Duration(seconds: 2),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void _download() async {
    ImageGallerySaver.saveImage(_pngBytes);
    final snackBar = SnackBar(
      backgroundColor: Colors.white,
      content: Container(
          height: 50,
          decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(100))),
          child: Center(
              child: Text(
            "Download sucessfull!",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ))),
      duration: Duration(seconds: 2),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
