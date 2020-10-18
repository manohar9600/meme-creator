import 'package:flutter/material.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import '../../classes/image_data.dart';

class G1 extends StatelessWidget {
  final List<ImageData> selectedImages;
  G1({this.selectedImages});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(context),
      body: MainWidget(
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

class MainWidget extends StatefulWidget {
  final List<ImageData> selectedImages;
  MainWidget({this.selectedImages});
  @override
  _MainWidget createState() => _MainWidget();
}

class _MainWidget extends State<MainWidget> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final widgetHeight = 400.0;
    /*24 is for notification bar on Android*/
    final double itemHeight = widgetHeight / widget.selectedImages.length;
    final double itemWidth = size.width;

    Widget gridWidget = GridView.count(
      crossAxisCount: 1,
      shrinkWrap: true,
      childAspectRatio: (itemWidth / itemHeight),
      children: List.generate(widget.selectedImages.length, (index) {
        return DraggableWidget(
          selectedImage: widget.selectedImages[index],
          width: size.width,
        );
      }),
    );
    Widget finalWidget = Container(
      height: widgetHeight,
      margin: EdgeInsets.only(top: 50, bottom: 80),
      child: gridWidget,
    );

    return finalWidget;
  }
}

class DragData {
  Function updatePrevious;
  Widget draggedWidget;
  DragData(Function updatePrevious, Widget draggedWidget) {
    this.updatePrevious = updatePrevious;
    this.draggedWidget = draggedWidget;
  }
}

class DraggableWidget extends StatefulWidget {
  final ImageData selectedImage;
  final width;
  DraggableWidget({Key key, this.selectedImage, this.width}) : super(key: key);

  @override
  _DraggableWidgetState createState() => _DraggableWidgetState();
}

class _DraggableWidgetState extends State<DraggableWidget> {
  Widget imageWidget;

  @override
  void initState() {
    super.initState();
    imageWidget = Container(
        width: widget.width,
        child: FittedBox(
            fit: BoxFit.cover,
            child: Image.memory(
              widget.selectedImage.imageData,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<DragData>(
      onWillAccept: (data) => true,
      onAccept: (data) {
        Widget temp = this.imageWidget;
        setState(() {
          updateImage(data.draggedWidget);
        });
        data.updatePrevious(temp);
      },
      builder: (BuildContext context, List incoming, List rejected) {
        return Draggable<DragData>(
          data: DragData(updateImage, imageWidget),
          child: imageWidget,
          feedback: imageWidget,
          childWhenDragging: Container(
              width: widget.width,
              child: Center(
                child: Text("HEEEEEEEEEEEEEE"),
              )),
        );
      },
    );
  }

  void updateImage(Widget data) {
    setState(() {
      this.imageWidget = data;
    });
  }
}
