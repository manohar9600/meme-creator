import 'package:flutter/material.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import '../../classes/image.dart';
import '../../edit_page/edit_page.dart';
import '../focused_edit.dart';

class G1 extends StatelessWidget {
  final List<ImageMetaData> selectedImagesMetaData;
  final int crossAxisCount;
  final List<ImageView> selectedImages = [];
  G1(this.selectedImagesMetaData, this.crossAxisCount) {
    int row = -1;
    for (int i = 0; i < this.selectedImagesMetaData.length; i++) {
      int _pos = i % this.crossAxisCount;
      double colPosTag = double.parse("." + _pos.toString());
      if (colPosTag == 0) {
        row++;
      }
      double widgetPosTag = row + colPosTag;
      ImageView imageView = ImageView(
          imageData: this.selectedImagesMetaData[i],
          width: null,
          height: null,
          imagePosition: Offset(0, 0),
          imageScale: 1.0,
          widgetPosTag: widgetPosTag);
      selectedImages.add(imageView);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget frameWidget = FrameWidget(
        selectedImages: selectedImages, crossAxisCount: this.crossAxisCount);
    return Scaffold(appBar: _getAppBar(context), body: frameWidget);
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
                          selectedImages: selectedImages,
                        )));
          },
        )
      ],
    );
  }
}

class FrameWidget extends StatefulWidget {
  final List<ImageView> selectedImages;
  final int crossAxisCount;
  FrameWidget({@required this.selectedImages, @required this.crossAxisCount});
  @override
  _FrameWidget createState() => _FrameWidget();
}

class _FrameWidget extends State<FrameWidget> {
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
          return Expanded(
              child: DraggableWidget(
                  selectedImage: rowImages[index],
                  height: _height / arrangedImages.length,
                  width: _width / rowImages.length));
        })));
      }),
    );
    return Container(
      width: _width,
      height: _height,
      padding: EdgeInsets.only(top: 100),
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
  final double height;
  final double width;
  DraggableWidget({this.selectedImage, this.height, this.width});

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
    imageWidget = Container(
        height: widget.height,
        width: widget.width,
        child: ImageViewWidget(
          imageView: imageView,
        ));
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
              width: widget.width,
              height: widget.height,
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
