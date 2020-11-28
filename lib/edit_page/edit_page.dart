import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import 'edit_options.dart';
import '../render/render.dart';
import '../classes/image.dart';

class EditPage extends StatefulWidget {
  final GlobalKey imageKey;
  final ImageMetaData singleImage;
  EditPage({this.imageKey, this.singleImage});
  @override
  _EditPage createState() => _EditPage();
}

class _EditPage extends State<EditPage> {
  List<Widget> stackWidgets = [];
  int _count = 0;
  final GlobalKey stackKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.singleImage == null) {
      takeScreenshot();
    } else {
      Widget imageWidget = Center(
          child: Container(
        child: Image.memory(widget.singleImage.imageData),
      ));
      stackWidgets.add(imageWidget);
      _count += 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: _getAppBar(),
      body: _getBodyWidget(),
    );
  }

  Widget _getAppBar() {
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
                    builder: (context) => RenderWidget(
                          stackKey: stackKey,
                        )));
          },
        )
      ],
    );
  }

  Widget _getBodyWidget() {
    return GestureDetector(
      onTap: () {
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      },
      child: getImageWidget(),
    );
  }

  Widget getImageWidget() {
    // return
    return Column(
      children: <Widget>[
        Flexible(
          fit: FlexFit.tight,
          flex: 8,
          child: Container(
            padding: EdgeInsets.all(0),
            margin: EdgeInsets.only(bottom: 20, top: 5),
            child: RepaintBoundary(
              key: stackKey,
              child: Stack(
                children: stackWidgets.getRange(0, _count).toList(),
              ),
            ),
          ),
        ),
        Flexible(flex: 1, fit: FlexFit.tight, child: getMenuBar())
      ],
    );
  }

  Widget getMenuBar() {
    return Container(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          verticalDirection: VerticalDirection.up,
          children: <Widget>[
            EditOptions(addFloatingWidget: addFloatingWidget),
            // EditOptions2()
          ],
        ),
      ),
    );
  }

  Widget getHorizontalSeparation() {
    return Container(height: 1.0, color: Colors.black);
  }

  void addFloatingWidget(Widget floatingWidget) {
    setState(() {
      if (stackWidgets.length != 0) {
        stackWidgets.add(floatingWidget);
        _count += 1;
      }
    });
  }

  void takeScreenshot() async {
    // unfocuses all widgets.
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
    RenderRepaintBoundary boundary =
        widget.imageKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    Widget imageWidget = Center(
        child: Container(
      child: Image.memory(pngBytes),
    ));
    setState(() {
      stackWidgets.add(imageWidget);
      _count += 1;
    });
  }
}
