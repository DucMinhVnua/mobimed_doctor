import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:DoctorApp/utils/AppUtil.dart';

// ignore: must_be_immutable
class ScreenShowPhoto extends StatefulWidget {
  String filePath = '';

  ScreenShowPhoto({Key key, @required this.filePath}) : super(key: key);

  @override
  _ScreenShowPhotoState createState() => _ScreenShowPhotoState();
}

class _ScreenShowPhotoState extends State<ScreenShowPhoto> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AppUtil appUtil = AppUtil();

  // ignore: missing_return
  Widget displayImage() {
    try {
      AppUtil.showLog('displayImage path: ' + widget.filePath);

//      setState(() {
      if (!appUtil.checkValidLocalPath(widget.filePath)) {
        AppUtil.showLog('displayImage url: ' + widget.filePath);
        return Hero(
            tag: widget.filePath,
            child: PhotoView(
              imageProvider: NetworkImage(widget.filePath),
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: 4.0,
            ));
      } else {
        return Hero(
            tag: widget.filePath,
            child: PhotoView(
              imageProvider: AssetImage(widget.filePath),
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: 4.0,
            )
//              Image.file(File(widget.filePath))
            );
//          return Image.file(File(widget.filePath));
      }
//      });
    } catch (e) {
      AppUtil.showPrint('Error: ' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppUtil.customAppBar(context, 'Xem ảnh'),
        backgroundColor: Colors.black87,
        key: _scaffoldKey,
        body: GestureDetector(
          child: Center(
            child: displayImage()
            /*Hero(
            tag: widget.filePath,
            child: displayImage(),
            */ /* Image.network(
              'https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/lakes/images/lake.jpg',
            ),*/ /*
          )*/
            ,
          ),
          onTap: () {
//          Navigator.pop(context);
          },
        ),
      );
}

/*

class ScreenShowPhoto extends StatelessWidget {

  AppUtil appUtil = AppUtil();
  String filePath = "";

  Widget displayImage() {
    try {
      AppUtil.showLog("displayImage path: " + filePath);
      if (filePath != null) {
        AppUtil.showLog(
            "displayImage url: " + filePath);
        return FadeInImage(
            image: NetworkImage( filePath),
            placeholder: AssetImage("assets/defaultimage.png")
//          ,width: 120,
//          height: 90,
        );

      } else {
        return Image.file(File(filePath));
      }
    } catch (e) {
      AppUtil.showPrint("Error: " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: displayImage(),
           */
/* Image.network(
              'https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/lakes/images/lake.jpg',
            ),*//*

          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}*/
