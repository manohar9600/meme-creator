import 'package:flutter/material.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  int _currentIndex = 0;
  final tabs = [
    Home(),
    Center(
      child: Text("Search"),
    ),
    Center(
      child: Text("Create"),
    ),
    Center(
      child: Text("Profile"),
    )
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Startup Name Generator",
      home: Scaffold(
        appBar: AppBar(
          title: Text("MeMe Maker"),
        ),
        body: tabs[_currentIndex],
        bottomNavigationBar: NavigationBar(
            currentIndex: _currentIndex,
            changeMainView: (int index) {
              setState(() {
                _currentIndex = index;
              });
            }),
      ),
    );
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

class NavigationBar extends StatefulWidget {
  final Function(int) changeMainView;
  final currentIndex;
  NavigationBar({@required this.currentIndex, @required this.changeMainView});
  @override
  _NavigationBar createState() => _NavigationBar(
      currentIndex: this.currentIndex, changeMainView: this.changeMainView);
}

class _NavigationBar extends State<NavigationBar> {
  Color _color = Colors.black;
  int currentIndex;
  final Function(int) changeMainView;

  _NavigationBar({@required this.currentIndex, @required this.changeMainView});
  @override
  Widget build(BuildContext context) {
    return _buildNavigationBar();
  }

  BottomNavigationBar _buildNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      // iconSize: 30,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        _buildNavigationButton(_color, FeatherIcons.home, "Home"),
        _buildNavigationButton(_color, FeatherIcons.search, "Search"),
        _buildNavigationButton(_color, FeatherIcons.plusCircle, "Add"),
        _buildNavigationButton(_color, Icons.account_circle, "Profile")
      ],
      onTap: (index) {
        setState(() {
          currentIndex = index;
          changeMainView(index);
        });
      },
    );
  }

  BottomNavigationBarItem _buildNavigationButton(
      Color color, IconData icon, String label) {
    return BottomNavigationBarItem(icon: Icon(icon), title: Text(label));
  }
}
