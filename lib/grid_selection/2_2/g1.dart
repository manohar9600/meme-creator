import 'package:flutter/material.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import 'package:vector_math/vector_math_64.dart' show Vector3;
import '../../classes/image_data.dart';
import '../../edit_page/edit_page.dart';
import '../focused_edit.dart';

class G1 extends StatelessWidget {
  final List<ImageData> selectedImages;
  final int crossAxisCount;
  final GlobalKey imageKey = new GlobalKey();
  G1({this.selectedImages, this.crossAxisCount});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(context),
      body: MainWidget(
          selectedImages: selectedImages,
          imageKey: imageKey,
          crossAxisCount: this.crossAxisCount),
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
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditPage(
                          imageKey: imageKey,
                        )));
          },
        )
      ],
    );
  }
}

class MainWidget extends StatefulWidget {
  final List<ImageData> selectedImages;
  final Key imageKey;
  final int crossAxisCount;
  MainWidget({this.selectedImages, this.imageKey, this.crossAxisCount});
  @override
  _MainWidget createState() => _MainWidget();
}

class _MainWidget extends State<MainWidget> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final widgetHeight = 400.0;
    final int rowCount = widget.selectedImages.length ~/ widget.crossAxisCount;
    /*24 is for notification bar on Android*/
    final double itemHeight = widgetHeight / rowCount;
    final double itemWidth = size.width / widget.crossAxisCount;

    Widget gridWidget = GridView.count(
      crossAxisCount: widget.crossAxisCount,
      shrinkWrap: true,
      childAspectRatio: (itemWidth / itemHeight),
      children: List.generate(widget.selectedImages.length, (index) {
        return DraggableWidget(
            selectedImage: widget.selectedImages[index],
            width: itemWidth,
            height: itemHeight);
      }),
    );
    Widget finalWidget = Container(
      height: widgetHeight,
      margin: EdgeInsets.only(top: 50, bottom: 80),
      child: RepaintBoundary(key: widget.imageKey, child: gridWidget),
    );

    return finalWidget;
  }
}

class DragData {
  Function updatePrevious;
  ImageData selectedImage;
  DragData(Function updatePrevious, ImageData selectedImage) {
    this.updatePrevious = updatePrevious;
    this.selectedImage = selectedImage;
  }
}

class DraggableWidget extends StatefulWidget {
  final ImageData selectedImage;
  final width;
  final height;
  DraggableWidget({this.selectedImage, this.width, this.height});

  @override
  _DraggableWidgetState createState() => _DraggableWidgetState();
}

class _DraggableWidgetState extends State<DraggableWidget> {
  Widget gestureWidget;
  Widget imageWidget;
  GlobalKey widgetKey = GlobalKey();
  Alignment imagePosition;
  double width;
  ImageData selectedImage;
  double xPosition = 0;
  double yPosition = 0;

  @override
  void initState() {
    super.initState();
    if (imagePosition == null) {
      imagePosition = Alignment(0, 0);
    }
    width = widget.width;
    selectedImage = widget.selectedImage;
  }

  @override
  Widget build(BuildContext context) {
    imageWidget = ClipRect(
        child: Transform.translate(
            offset: Offset(xPosition, yPosition),
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.diagonal3(Vector3(selectedImage.scale,
                  selectedImage.scale, selectedImage.scale)),
              child: Image.memory(
                selectedImage.imageData,
              ),
            )));
    gestureWidget = GestureDetector(
      key: widgetKey,
      child: Container(
          width: width,
          height: widget.height,
          child: ClipRect(child: imageWidget)),
      onLongPress: () {
        longPressFunctionality();
      },
    );
    return DragTarget<DragData>(
      onWillAccept: (data) => true,
      onAccept: (data) {
        ImageData temp = this.selectedImage;
        setState(() {
          updateImage(data.selectedImage);
        });
        data.updatePrevious(temp);
      },
      builder: (BuildContext context, List incoming, List rejected) {
        return Draggable<DragData>(
          data: DragData(updateImage, selectedImage),
          child: gestureWidget,
          feedback: gestureWidget,
          childWhenDragging: Container(
              width: widget.width,
              height: widget.height,
              child: Center(
                child: Text("HEEEEEEEEEEEEEE"),
              )),
        );
      },
    );
  }

  void updateImage(ImageData selectedImage) {
    setState(() {
      this.selectedImage = selectedImage;
    });
  }

  void longPressFunctionality() {
    RenderBox renderBox = widgetKey.currentContext.findRenderObject();
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    Navigator.push(
        context,
        PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 100),
            pageBuilder: (context, animation, secondaryAnimation) {
              animation = Tween(begin: 0.0, end: 1.0).animate(animation);
              return FadeTransition(
                  opacity: animation,
                  child: FocusedEdit(
                      childOffset: offset,
                      childSize: size,
                      child: Image.memory(
                        selectedImage.imageData,
                      ),
                      updateImageZoom: updateImageZoom,
                      initScale: this.selectedImage.scale,
                      xPosition: xPosition,
                      yPosition: yPosition,
                      updatePosition: updatePosition));
            },
            fullscreenDialog: true,
            opaque: false));
  }

  void updateImageZoom(double scale) {
    setState(() {
      this.selectedImage.scale = scale;
    });
  }

  void updatePosition(double xPosition, double yPosition) {
    setState(() {
      this.xPosition = xPosition;
      this.yPosition = yPosition;
    });
  }
}
