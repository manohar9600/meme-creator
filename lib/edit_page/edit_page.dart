import 'package:flutter/material.dart';
import '../classes/image_data.dart';
import 'edit_options.dart';
import 'edit_options2.dart';

class EditPage extends StatefulWidget {
  final List<ImageData> selectedImages;
  EditPage({this.selectedImages});
  @override
  _EditPage createState() => _EditPage();
}

class _EditPage extends State<EditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: getImageWidget());
  }

  Widget getImageWidget() {
    // return
    return Column(
      children: <Widget>[
        Container(
          height: 300,
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fitHeight,
              image: AssetImage(widget.selectedImages[0].imageLoc),
            ),
          ),
        ),
        getMenuBar()
      ],
    );
  }

  Widget getMenuBar() {
    return Container(
      height: MediaQuery.of(context).size.height - 420,
      // color: Colors.yellow,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          verticalDirection: VerticalDirection.up,
          children: <Widget>[
            EditOptions(),
            // EditOptions2()
          ],
        ),
      ),
    );
  }

  Widget getHorizontalSeparation() {
    return Container(height: 1.0, color: Colors.black);
  }
}
