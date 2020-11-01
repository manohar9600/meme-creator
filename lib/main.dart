import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'widgets/navigation_bar.dart';
import 'pages/home.dart';
import 'package:image_picker/image_picker.dart';
import 'classes/image_data.dart';
import 'grid_selection/grid_selector.dart';
import 'edit_page/edit_page.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Meme Generator",
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreen createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> {
  int _currentIndex = 0;
  List<Widget> tabs;

  _MainScreen() {
    this.tabs = getTabs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Me Me Creator",
            style: TextStyle(
                color: Color(int.parse("0xFF1A1A1A")),
                fontWeight: FontWeight.w600),
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: getBodywidget());
  }

  Widget getBodywidget() {
    Widget bodyWidget = Stack(
      children: <Widget>[
        tabs[_currentIndex],
        Container(
          child: NavigationBarV2(
              currentIndex: _currentIndex, changeMainView: _updateMainScreen),
        )
      ],
    );
    return bodyWidget;
  }

  List<Widget> getTabs() {
    final tabs = [
      Home(),
      Center(
          child: Text(
        "Coming soon....",
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Color(int.parse("0xFF333333"))),
      )),
      Center(
          child: Text(
        "Coming soon....",
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Color(int.parse("0xFF333333"))),
      )),
      Center(
          child: Text(
        "Coming soon....",
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Color(int.parse("0xFF333333"))),
      )),
      Center(
          child: Text(
        "Coming soon....",
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Color(int.parse("0xFF333333"))),
      ))
    ];
    return tabs;
  }

  void _updateMainScreen(int index) {
    if (index == 2) {
      // Navigator.push(context, SlidePageRoute(widget: AddScreen()));
      getImages();
    } else {
      if (_currentIndex != index) {
        setState(() {
          _currentIndex = index;
        });
      }
    }
  }

  Future getImages() async {
    List<ImageData> selectedImages = [];
    List<Asset> resultList;
    try {
      resultList = await MultiImagePicker.pickImages(maxImages: 4);
    } on Exception catch (e) {
      String error = e.toString();
      print(error);
    }
    if (resultList != null) {
      for (Asset e in resultList) {
        final byteData = await e.getByteData();
        Uint8List pngBytes = byteData.buffer.asUint8List();
        selectedImages.add(ImageData(imageData: pngBytes));
      }
      if (selectedImages.length == 1) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditPage(
                      singleImage: selectedImages[0],
                    )));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    GridSelector(selectedImages: selectedImages)));
      }
    }
  }
}
