import 'package:flutter/material.dart';

class SlidePageRoute extends PageRouteBuilder {
  final Widget widget;

  SlidePageRoute({this.widget})
      : super(
            transitionDuration: Duration(milliseconds: 300),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var begin = Offset(0.0, 1.0);
              var end = Offset.zero;
              var curve = Curves.ease;

              var tween = Tween(begin: begin, end: end);
              var curvedAnimation = CurvedAnimation(
                parent: animation,
                curve: curve,
              );

              return SlideTransition(
                position: tween.animate(curvedAnimation),
                child: child,
              );
            },
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secAnimation) {
              return widget;
            });
}
