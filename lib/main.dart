import 'package:flutter/material.dart';
import 'widgets/navigation_bar.dart';
import 'pages/home.dart';
import 'package:image_picker/image_picker.dart';
import 'classes/image_data.dart';
import 'edit_page/edit_page.dart';

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
          "Search",
          style: TextStyle(color: Colors.black),
        ),
      ),
      Text("Edit screen"),
      Text("Notifications"),
      Center(
        child: Text("Profile34we"),
      )
    ];
    return tabs;
  }

  void _updateMainScreen(int index) {
    if (index == 2) {
      // Navigator.push(context, SlidePageRoute(widget: AddScreen()));
      getImage();
    } else {
      if (_currentIndex != index) {
        setState(() {
          _currentIndex = index;
        });
      }
    }
  }

  Future getImage() async {
    List<ImageData> selectedImages = [];
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        selectedImages.add(ImageData(imageLoc: pickedFile.path));
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    EditPage(selectedImages: selectedImages)));
      }
    });
  }
}
