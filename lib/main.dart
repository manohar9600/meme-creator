import 'package:flutter/material.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import 'widgets/navigation_bar.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  int _currentIndex = 0;
  bool _showAppBar = true;
  List<Widget> tabs;

  _MyApp() {
    this.tabs = getTabs();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Startup Name Generator",
      home: Scaffold(
        appBar: _showAppBar
            ? AppBar(
                title: Text("MeMe Maker"),
              )
            : PreferredSize(
                child: Container(),
                preferredSize: Size(0.0, 0.0),
              ),
        body: tabs[_currentIndex],
        bottomNavigationBar: NavigationBar(
            currentIndex: _currentIndex, changeMainView: _updateMainScreen),
      ),
      theme: ThemeData(fontFamily: 'Inter'),
    );
  }

  List<Widget> getTabs() {
    final tabs = [
      Home(),
      Center(
        child: Text("Search"),
      ),
      AddScreen(
        onClose: () {
          setState(() {
            _showAppBar = true;
            _currentIndex = 0;
          });
        },
      ),
      Center(
        child: Text("Profile34we"),
      )
    ];
    return tabs;
  }

  void _updateMainScreen(int index) {
    setState(() {
      _currentIndex = index;
      if (index == 2) {
        _showAppBar = false;
      }
    });
  }
}

class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Text("Home123");
  }
}

class AddScreen extends StatefulWidget {
  final Function() onClose;
  AddScreen({@required this.onClose});
  @override
  _AddScreen createState() => _AddScreen(this.onClose);
}

class _AddScreen extends State<AddScreen> {
  final Function() onClose;
  _AddScreen(this.onClose);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(FeatherIcons.x, color: Colors.black),
          onPressed: () {
            onClose();
          },
        ),
        title: Text("Edit", style: TextStyle(color: Colors.black)),
        // actions: <Widget>[
        //   IconButton(icon: Icon(FeatherIcons.arrowRight, color: Colors.black)),
        // ],
      ),
    );
  }
}
