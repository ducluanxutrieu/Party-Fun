import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ImageList extends StatefulWidget {
  final List<String> oldImages;
  final List<Asset> newImages;
  final bool isOldImage;
//  final Function onRemovePress;

  const ImageList({
    Key key,
    this.isOldImage = false,
    this.oldImages,
    this.newImages,
//    this.onRemovePress,
  }) : super(key: key);

  @override
  _ImageListState createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  @override
  Widget build(BuildContext context) {
    int _itemLength;
    if (widget.isOldImage) {
      if (widget.oldImages == null || widget.oldImages.isEmpty)
        return SizedBox();
      else
        _itemLength = widget.oldImages.length;
    } else {
      if (widget.newImages == null || widget.newImages.isEmpty)
        return SizedBox();
      else
        _itemLength = widget.newImages.length;
    }
    return Column(
      children: <Widget>[
        Divider(
          height: 10,
          color: Colors.green,
        ),
        Text(
          widget.isOldImage ? 'Old Images' : 'New Images',
          style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 500,
            minHeight: 0,
            maxWidth: MediaQuery.of(context).size.width,
          ),
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            children: List.generate(_itemLength, (index) {
              return Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(55)),
                  ),
                  child: Stack(children: <Widget>[
                    widget.isOldImage
                        ? Image.network(widget.oldImages[index], fit: BoxFit.cover,)
                        : AssetThumb(
                            asset: widget.newImages[index],
                            width: 300,
                            height: 300,
                          ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () => _setStateImages(index),
                        )
                      ],
                    ),
                  ]));
            }),
          ),
        ),
      ],
    );
  }

  void _setStateImages(int index){
    setState(() {
      if(widget.isOldImage) {
        widget.oldImages.removeAt(index);
      }else {
        widget.newImages.removeAt(index);
      }
    });
  }
}
