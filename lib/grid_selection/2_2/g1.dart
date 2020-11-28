import 'package:flutter/material.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import '../../classes/image.dart';
import '../../edit_page/edit_page.dart';
import '../focused_edit.dart';

class G1 extends StatelessWidget {
  final List<ImageMetaData> selectedImages;
  final int crossAxisCount;
  G1({this.selectedImages, this.crossAxisCount});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(context),
      body: FrameWidget(
          selectedImages: selectedImages, crossAxisCount: this.crossAxisCount),
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
            // TODO: Modify this
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => EditPage(
            //               imageKey: imageKey,
            //             )));
          },
        )
      ],
    );
  }
}

class FrameWidget extends StatefulWidget {
  final List<ImageMetaData> selectedImages;
  final int crossAxisCount;
  FrameWidget({@required this.selectedImages, @required this.crossAxisCount});
  @override
  _FrameWidget createState() => _FrameWidget();
}

class _FrameWidget extends State<FrameWidget> {
  final widgetHeight = 400.0;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
      child: gridWidget,
    );

    return finalWidget;
  }
}

class DragData {
  Function updatePrevious;
  ImageView imageView;
  DragData({@required this.updatePrevious, @required this.imageView});
}

class DraggableWidget extends StatefulWidget {
  final ImageMetaData selectedImage;
  final width;
  final height;
  DraggableWidget({this.selectedImage, this.width, this.height});

  @override
  _DraggableWidgetState createState() => _DraggableWidgetState();
}

class _DraggableWidgetState extends State<DraggableWidget> {
  Widget gestureWidget;
  Widget imageWidget;
  GlobalKey _key = new GlobalKey();
  Alignment imagePosition;
  ImageView imageView;

  @override
  void initState() {
    super.initState();
    imageView = ImageView(
        imageData: widget.selectedImage,
        width: widget.width,
        height: widget.height,
        imagePosition: Offset(0, 0),
        imageScale: 1.0);
  }

  @override
  Widget build(BuildContext context) {
    imageWidget = ImageViewWidget(
      key: _key,
      imageView: imageView,
    );
    gestureWidget = GestureDetector(
      child: imageWidget,
      onLongPress: () {
        enableImageViewEdit();
      },
    );
    return DragTarget<DragData>(
      onWillAccept: (data) => true,
      onAccept: (data) {
        ImageView _prev = this.imageView;
        setState(() {
          updateImageView(data.imageView);
        });
        data.updatePrevious(_prev);
      },
      builder: (BuildContext context, List incoming, List rejected) {
        return Draggable<DragData>(
          data: DragData(updatePrevious: updateImageView, imageView: imageView),
          child: gestureWidget,
          feedback: imageWidget,
          childWhenDragging: Container(
              width: imageView.width,
              height: imageView.height,
              child: Center(
                child: Text("HEEEEEEEEEEEEEE"),
              )),
        );
      },
    );
  }

  void updateImageView(ImageView imageView) {
    setState(() {
      this.imageView = imageView;
    });
  }

  void enableImageViewEdit() {
    RenderBox renderBox = _key.currentContext.findRenderObject();
    Offset globalOffset = renderBox.localToGlobal(Offset.zero);
    Navigator.push(
        context,
        PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 100),
            pageBuilder: (context, animation, secondaryAnimation) {
              animation = Tween(begin: 0.0, end: 1.0).animate(animation);
              return FadeTransition(
                  opacity: animation,
                  child: FocusedEdit(
                      imageView: imageView,
                      updateImageView: updateImageView,
                      globalOffset: globalOffset));
            },
            fullscreenDialog: true,
            opaque: false));
  }
}
