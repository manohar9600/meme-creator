import 'package:flutter/material.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";

class NavigationBar extends StatefulWidget {
  final Function(int) changeMainView;
  final currentIndex;
  NavigationBar({@required this.currentIndex, @required this.changeMainView});
  @override
  _NavigationBar createState() => _NavigationBar();
}

class _NavigationBar extends State<NavigationBar> {
  Color _color = Colors.black;
  // int _currentIndex;

  // _NavigationBar() {
  //   this._currentIndex = widget.currentIndex;
  // }

  @override
  Widget build(BuildContext context) {
    return _buildNavigationBar();
  }

  BottomNavigationBar _buildNavigationBar() {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
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
          // _currentIndex = index;
          widget.changeMainView(index); // widget. => calling parent function
        });
      },
    );
  }

  BottomNavigationBarItem _buildNavigationButton(
      Color color, IconData icon, String label) {
    return BottomNavigationBarItem(icon: Icon(icon), title: Text(label));
  }
}
