import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class RenderWidget extends StatefulWidget {
  final stackKey;
  RenderWidget({this.stackKey});
  @override
  _RenderWidget createState() => _RenderWidget();
}

class _RenderWidget extends State<RenderWidget> {
  Random rng = new Random();
  File _imageFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: getAppBar(), body: _getBodyWidget());
  }

  Widget getAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(FeatherIcons.arrowLeft, color: Colors.black),
        onPressed: () {
          print('back');
        },
      ),
      title: Text("Render", style: TextStyle(color: Colors.black)),
    );
  }

  Widget _getBodyWidget() {
    return FloatingActionButton(
      child: Icon(FeatherIcons.download),
      onPressed: () {
        takeScreenshot();
      },
    );
  }

  void takeScreenshot() async {
    RenderRepaintBoundary boundary =
        widget.stackKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    // Directory appDir = await getApplicationDocumentsDirectory();
    // final directory = (await appDir.create(recursive: true)).path;
    // ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    // Uint8List pngBytes = byteData.buffer.asUint8List();
    // File imgFile = new File('$directory/screenshot${rng.nextInt(200)}.png');
    // setState(() {
    //   _imageFile = imgFile;
    // });
    // _savefile(_imageFile);
    // imgFile.writeAsBytes(pngBytes);
  }

  _savefile(File file) async {
    await _askPermission();
    Directory appDir = Directory('/storage/emulated/0/meme_creator/');
    final directory = (await appDir.create(recursive: true)).path;
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(await file.readAsBytes()),
        name: "hello");
    print(result);
  }

  _askPermission() async {
    Map<Permission, PermissionStatus> statuses =
        await [Permission.photos, Permission.storage].request();
    print(statuses[Permission.photos]);
    print(statuses[Permission.storage]);
  }
}
