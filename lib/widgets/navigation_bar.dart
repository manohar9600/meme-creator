import 'package:flutter/material.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import 'package:flutter_svg/flutter_svg.dart';

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

  Widget _buildNavigationBar() {
    Widget navBar = BottomNavigationBar(
      currentIndex: widget.currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Color(int.parse("0xFFF46C00")),
      // iconSize: 30,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        _buildNavigationButton(_color, FeatherIcons.home, "Home"),
        _buildNavigationButton(_color, FeatherIcons.search, "Search"),
        _buildNavigationButton(_color, FeatherIcons.plusCircle, "Add"),
        _buildNavigationButton(_color, FeatherIcons.bell, "Notifications"),
        _buildNavigationButton(_color, Icons.account_circle, "Profile")
      ],
      onTap: (index) {
        setState(() {
          // _currentIndex = index;
          widget.changeMainView(index); // widget. => calling parent function
        });
      },
    );
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(25), topLeft: Radius.circular(25)),
      child: navBar,
    );
  }

  BottomNavigationBarItem _buildNavigationButton(
      Color color, IconData icon, String label) {
    return BottomNavigationBarItem(icon: Icon(icon), label: label);
  }
}

class NavigationBarV2 extends StatefulWidget {
  final Function(int) changeMainView;
  final currentIndex;
  NavigationBarV2({@required this.currentIndex, @required this.changeMainView});
  @override
  _NavigationBarV2 createState() => _NavigationBarV2();
}

class _NavigationBarV2 extends State<NavigationBarV2> {
  int currentIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomLeft,
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          overflow: Overflow.visible,
          children: <Widget>[
            getAddIconBorder(),
            getNavBar(),
            getAddIconWidget()
          ],
        ));
  }

  Widget getAddIconWidget() {
    final String assetName = 'assets/icons/add-filled.svg';
    Color iconColor = Color(int.parse("0xFFF46C00"));
    Widget addIconWidget = Positioned(
        top: -20,
        child: GestureDetector(
          onTap: () {
            widget.changeMainView(2);
          },
          child: Container(
            // padding: EdgeInsets.all(1),
            decoration: BoxDecoration(
                // boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 4)],
                border: Border.all(width: 5, color: Colors.white),
                color: Colors.white,
                shape: BoxShape.circle),
            child: SvgPicture.asset(
              assetName,
              color: iconColor,
              width: 55,
              height: 55,
            ),
          ),
        ));
    return addIconWidget;
  }

  Widget getAddIconBorder() {
    final String assetName = 'assets/icons/add-filled.svg';
    Color iconColor = Color(int.parse("0xFFF46C00"));
    Widget addIconWidget = Positioned(
      top: -20,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 5, color: Colors.white),
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 4)],
            shape: BoxShape.circle),
        child: SvgPicture.asset(
          assetName,
          color: iconColor,
          width: 55,
          height: 55,
        ),
      ),
    );
    return addIconWidget;
  }

  Widget getNavBar() {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            // border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 4)]),
        child: Row(
          children: <Widget>[
            getNavItem('home', 1),
            getNavItem('search', 2),
            Expanded(
                flex: 1,
                child: Container(
                  height: 50,
                )),
            getNavItem('heart', 4),
            getNavItem('user', 5),
          ],
        ));
  }

  Widget getNavItem(String svgName, int index) {
    final String outlineIcon = 'assets/icons/$svgName.svg';
    final String filledIcon = 'assets/icons/$svgName-filled.svg';
    Color iconColor = currentIndex == index
        ? Color(int.parse("0xFFF46C00"))
        : Color(int.parse("0xFF1A1A1A"));
    String assetName = currentIndex == index ? filledIcon : outlineIcon;
    return Expanded(
        flex: 1,
        child: GestureDetector(
          onTap: () {
            setState(() {
              if (index != 3) {
                currentIndex = index;
              }
              widget.changeMainView(index - 1);
            });
          },
          child: Container(
            height: 50,
            padding: EdgeInsets.all(13),
            child: SvgPicture.asset(
              assetName,
              color: iconColor,
              width: 10,
              height: 10,
            ),
          ),
        ));
  }
}
