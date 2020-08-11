import 'package:flutter/material.dart';
import 'widgets/navigation_bar.dart';
import 'pages/add_page.dart';
import 'pages/home.dart';
import 'animations/slide_page_route.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Startup Name Generator",
      home: MainScreen(),
      theme: ThemeData(fontFamily: 'Inter'),
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
          title: Text("MeMe Maker"),
        ),
        body: tabs[_currentIndex],
        bottomNavigationBar: NavigationBar(
            currentIndex: _currentIndex, changeMainView: _updateMainScreen));
  }

  List<Widget> getTabs() {
    final tabs = [
      Home(),
      Center(
        child: Text("Search"),
      ),
      Text("Edit screen"),
      Center(
        child: Text("Profile34we"),
      )
    ];
    return tabs;
  }

  void _updateMainScreen(int index) {
    setState(() {
      if (index == 2) {
        // add routing logic
        Navigator.push(context, SlidePageRoute(widget: AddScreen()));
      } else {
        _currentIndex = index;
      }
    });
  }
}
