import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ScreenChinhSachSuDung extends StatefulWidget {
  final String title;

  ScreenChinhSachSuDung({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScreenChinhSachSuDungState();
}

class _ScreenChinhSachSuDungState extends State<ScreenChinhSachSuDung> {
  var _url =
      'http://register.app.benhvienphusanhanoi.vn/chinh-sach-quyen-rieng-tu';
  final _key = UniqueKey();
  _ScreenChinhSachSuDungState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
            child: WebView(
                key: _key,
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl: _url))
      ],
    ));
  }
}
