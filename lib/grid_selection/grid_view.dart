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
  // List<List<ImageView>> arrangedImages = [];

  @override
  Widget build(BuildContext context) {
    List<List<ImageView>> arrangedImages = getArrangedImages();
    double _width = MediaQuery.of(context).size.width;
    double _height = 450;
    Widget _gridWidget = Column(
      children: List.generate(arrangedImages.length, (index) {
        List<ImageView> rowImages = arrangedImages[index];
        return Expanded(
            child: Row(
                children: List.generate(rowImages.length, (index) {
          if (rowImages[index].type == "title") {
            return Expanded(child: rowImages[index].childWidget);
          } else if (widget.draggable) {
            rowImages[index].width = _width / rowImages.length;
            rowImages[index].height = _height / arrangedImages.length;
            return Expanded(
                child: DraggableWidget(
                    key: UniqueKey(), selectedImage: rowImages[index]));
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

  List<List<ImageView>> getArrangedImages() {
    List<List<ImageView>> arrangedImages = [];
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
    return arrangedImages;
  }
}

class DragData {
  Function updatePrevious;
  ImageView imageView;
  DragData({@required this.updatePrevious, @required this.imageView});
}

class DraggableWidget extends StatefulWidget {
  final ImageView selectedImage;
  DraggableWidget({Key key, this.selectedImage}) : super(key: key);

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
          feedback: Container(
            // width: widget.width,
            // height: widget.height,
            child: imageWidget,
          ),
          childWhenDragging: Container(
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

class ImageViewWidget extends StatefulWidget {
  // Widget that show image in desired view.
  final Key key;
  final ImageView imageView;
  ImageViewWidget({this.key, @required this.imageView});
  @override
  _ImageViewWidget createState() => _ImageViewWidget();
}

class _ImageViewWidget extends State<ImageViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.imageView.height,
        width: widget.imageView.width,
        child: ClipRect(
          child: Transform.translate(
            offset: widget.imageView.imagePosition,
            child: Transform.scale(
              alignment: Alignment.center,
              scale: widget.imageView.imageScale,
              child: Image.memory(widget.imageView.imageData.imageData),
            ),
          ),
        ));
  }
}

class GridCellView extends StatefulWidget {
  // Widget that show image in desired view.
  final Key key;
  final ImageView imageView;
  GridCellView({this.key, @required this.imageView});
  @override
  _GridCellView createState() => _GridCellView();
}

class _GridCellView extends State<GridCellView> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.imageView.height,
        width: widget.imageView.width,
        child: ClipRect(
          child: Transform.translate(
            offset: widget.imageView.imagePosition,
            child: Transform.scale(
              alignment: Alignment.center,
              scale: widget.imageView.imageScale,
              child: Image.memory(widget.imageView.imageData.imageData),
            ),
          ),
        ));
  }
}
