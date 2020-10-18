import 'package:flutter/material.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import '../classes/image_data.dart';
import 'edit_options.dart';
import '../render/render.dart';

class EditPage extends StatefulWidget {
  final List<ImageData> selectedImages;
  EditPage({this.selectedImages});
  @override
  _EditPage createState() => _EditPage();
}

class _EditPage extends State<EditPage> {
  List<Widget> stackWidgets = [];
  int _count = 0;
  final GlobalKey stackKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
    Widget imageWidget = Center(
        child: Container(
      child: Image.memory(widget.selectedImages[0].imageData),
    ));
    stackWidgets.add(imageWidget);
    _count += 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: _getAppBar(),
      body: _getBodyWidget(),
    );
  }

  Widget _getAppBar() {
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
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RenderWidget(
                          stackKey: stackKey,
                        )));
          },
        )
      ],
    );
  }

  Widget _getBodyWidget() {
    return GestureDetector(
      onTap: () {
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      },
      child: getImageWidget(),
    );
  }

  Widget getImageWidget() {
    // return
    return Column(
      children: <Widget>[
        Flexible(
          fit: FlexFit.tight,
          flex: 8,
          child: Container(
            padding: EdgeInsets.all(0),
            margin: EdgeInsets.only(bottom: 20, top: 5),
            child: RepaintBoundary(
              key: stackKey,
              child: Stack(
                children: stackWidgets.getRange(0, _count).toList(),
              ),
            ),
          ),
        ),
        Flexible(flex: 1, fit: FlexFit.tight, child: getMenuBar())
      ],
    );
  }

  Widget getMenuBar() {
    return Container(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          verticalDirection: VerticalDirection.up,
          children: <Widget>[
            EditOptions(addFloatingWidget: addFloatingWidget),
            // EditOptions2()
          ],
        ),
      ),
    );
  }

  Widget getHorizontalSeparation() {
    return Container(height: 1.0, color: Colors.black);
  }

  void addFloatingWidget(Widget floatingWidget) {
    setState(() {
      stackWidgets.add(floatingWidget);
      _count += 1;
    });
  }
}
