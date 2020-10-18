import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import '../classes/image_data.dart';
import '2_2/g1.dart';

class GridSelector extends StatelessWidget {
  final List<ImageData> selectedImages;
  GridSelector({this.selectedImages});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(context),
      body: GridWidget(
        selectedImages: selectedImages,
      ),
    );
  }

  Widget _getAppBar(BuildContext context) {
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
            print("TODO");
          },
        )
      ],
    );
  }
}

class GridWidget extends StatefulWidget {
  final List<ImageData> selectedImages;
  GridWidget({this.selectedImages});
  @override
  _GridWidget createState() => _GridWidget();
}

class _GridWidget extends State<GridWidget> {
  @override
  Widget build(BuildContext context) {
    return getWidgets2();
  }

  Widget getWidgets2() {
    Paint linePaint = Paint();
    linePaint.strokeWidth = 2;

    List<Widget> grids = [
      GestureDetector(
        child: Container(
          padding: EdgeInsets.all(15),
          child: CustomPaint(
            painter: Grid2N1(linePaint: linePaint),
          ),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => G1(
                        selectedImages: widget.selectedImages,
                      )));
        },
      ),
      Container(
        padding: EdgeInsets.all(15),
        child: CustomPaint(
          painter: Grid2N2(linePaint: linePaint),
        ),
      ),
      Container(
        padding: EdgeInsets.all(15),
        child: CustomPaint(
          painter: Grid2N3(linePaint: linePaint),
        ),
      ),
      Container(
        padding: EdgeInsets.all(15),
        child: CustomPaint(
          painter: Grid2N4(linePaint: linePaint),
        ),
      ),
    ];
    Widget gridView = GridView.count(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      crossAxisCount: 2,
      children: grids,
      crossAxisSpacing: 7,
      mainAxisSpacing: 7,
      padding: EdgeInsets.only(left: 5, right: 5),
    );
    return Center(
      child: gridView,
    );
  }
}

class Grid2N1 extends CustomPainter {
  Paint linePaint;
  Grid2N1({this.linePaint});
  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    canvas.drawLine(Offset(0, 0), Offset(size.longestSide, 0), linePaint);
    canvas.drawLine(Offset(size.longestSide, 0),
        Offset(size.longestSide, size.longestSide), linePaint);
    canvas.drawLine(Offset(size.longestSide, size.longestSide),
        Offset(0, size.longestSide), linePaint);
    canvas.drawLine(Offset(0, size.longestSide), Offset(0, 0), linePaint);
    canvas.drawLine(Offset(0, size.longestSide / 2),
        Offset(size.longestSide, size.longestSide / 2), linePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class Grid2N2 extends CustomPainter {
  Paint linePaint;
  Grid2N2({this.linePaint});
  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    canvas.drawLine(Offset(0, 0), Offset(size.longestSide, 0), linePaint);
    canvas.drawLine(Offset(size.longestSide, 0),
        Offset(size.longestSide, size.longestSide), linePaint);
    canvas.drawLine(Offset(size.longestSide, size.longestSide),
        Offset(0, size.longestSide), linePaint);
    canvas.drawLine(Offset(0, size.longestSide), Offset(0, 0), linePaint);
    canvas.drawLine(Offset(size.longestSide / 2, size.longestSide),
        Offset(size.longestSide / 2, 0), linePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class Grid2N3 extends CustomPainter {
  Paint linePaint;
  Grid2N3({this.linePaint});
  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    canvas.drawLine(Offset(0, 0), Offset(size.longestSide, 0), linePaint);
    canvas.drawLine(Offset(size.longestSide, 0),
        Offset(size.longestSide, size.longestSide), linePaint);
    canvas.drawLine(Offset(size.longestSide, size.longestSide),
        Offset(0, size.longestSide), linePaint);
    canvas.drawLine(Offset(0, size.longestSide), Offset(0, 0), linePaint);
    canvas.drawLine(
        Offset(0, 0), Offset(size.longestSide, size.longestSide), linePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class Grid2N4 extends CustomPainter {
  Paint linePaint;
  Grid2N4({this.linePaint});
  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    canvas.drawLine(Offset(0, 0), Offset(size.longestSide, 0), linePaint);
    canvas.drawLine(Offset(size.longestSide, 0),
        Offset(size.longestSide, size.longestSide), linePaint);
    canvas.drawLine(Offset(size.longestSide, size.longestSide),
        Offset(0, size.longestSide), linePaint);
    canvas.drawLine(Offset(0, size.longestSide), Offset(0, 0), linePaint);
    canvas.drawLine(
        Offset(0, size.longestSide), Offset(size.longestSide, 0), linePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
