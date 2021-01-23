import 'package:flutter/material.dart';
import '../classes/image.dart';
import 'focused_edit.dart';

class GridViewCustom extends StatefulWidget {
  final List<ImageView> selectedImages;
  final bool draggable;
  GridViewCustom({@required this.selectedImages, @required this.draggable});
  @override
  _GridViewCustom createState() => _GridViewCustom();
}

class _GridViewCustom extends State<GridViewCustom> {
  final widgetHeight = 400.0;
  List<List<ImageView>> arrangedImages = [];

  @override
  void initState() {
    super.initState();
    widget.selectedImages
        .sort((a, b) => a.widgetPosTag.compareTo(b.widgetPosTag));
    for (ImageView selectedImage in widget.selectedImages) {
      int rowPos = selectedImage.widgetPosTag.toInt();
      if (rowPos + 1 > arrangedImages.length) {
        List<ImageView> emptyRow = [];
        arrangedImages.add(emptyRow);
      }
      arrangedImages[rowPos].add(selectedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    double _width = 450;
    double _height = 450;
    Widget _gridWidget = Column(
      children: List.generate(arrangedImages.length, (index) {
        List<ImageView> rowImages = arrangedImages[index];
        return Expanded(
            child: Row(
                children: List.generate(rowImages.length, (index) {
          if (widget.draggable) {
            return Expanded(
                child: DraggableWidget(selectedImage: rowImages[index]));
          } else {
            return Expanded(
                child: ImageViewWidget(imageView: rowImages[index]));
          }
        })));
      }),
    );
    return Container(
      width: _width,
      height: _height,
      padding: EdgeInsets.only(top: 10),
      child: _gridWidget,
    );
  }
}

class DragData {
  Function updatePrevious;
  ImageView imageView;
  DragData({@required this.updatePrevious, @required this.imageView});
}

class DraggableWidget extends StatefulWidget {
  final ImageView selectedImage;
  DraggableWidget({this.selectedImage});

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
    imageView = widget.selectedImage;
  }

  @override
  Widget build(BuildContext context) {
    imageWidget = ImageViewWidget(
      imageView: imageView,
    );
    gestureWidget = GestureDetector(
      child: imageWidget,
      onLongPress: () {
        enableImageViewEdit();
      },
    );
    return DragTarget<DragData>(
      key: _key,
      onWillAccept: (data) => true,
      onAccept: (data) {
        ImageView _prev = this.imageView;
        double _prevTag = data.imageView.widgetPosTag;
        setState(() {
          data.imageView.widgetPosTag = _prev.widgetPosTag;
          updateImageView(data.imageView);
        });
        _prev.widgetPosTag = _prevTag;
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
                      globalOffset: globalOffset,
                      width: renderBox.size.width,
                      height: renderBox.size.height));
            },
            fullscreenDialog: true,
            opaque: false));
  }
}
