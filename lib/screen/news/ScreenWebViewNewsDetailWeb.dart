import 'package:DoctorApp/utils/AppUtil.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ScreenWebViewNewsDetailWeb extends StatefulWidget {
  String newsID = '';
  String title = '';
  String htmlString = '';

  ScreenWebViewNewsDetailWeb(
      {Key key,
      @required this.newsID,
      @required this.title,
      @required this.htmlString})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScreenWebViewNewsDetailWebState();
}

class _ScreenWebViewNewsDetailWebState
    extends State<ScreenWebViewNewsDetailWeb> {
//  var _url = "http://register.app.benhvienphusanhanoi.vn/chinh-sach-quyen-rieng-tu";
  // final _key = UniqueKey();
  AppUtil appUtil = AppUtil();
  _ScreenWebViewNewsDetailWebState();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppUtil.customAppBar(context, 'Chi tiết'),
//      appBar: appUtil.getAppBar(new Text(widget.title)),
      body: SingleChildScrollView(
        child: Html(data: widget.htmlString),
      ));
}
