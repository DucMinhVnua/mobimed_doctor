import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';

class ScreenIntroduction extends StatefulWidget {
  String url;
  ScreenIntroduction({Key key, this.url}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScreenIntroductionState();
}

class _ScreenIntroductionState extends State<ScreenIntroduction> {
  final _key = UniqueKey();
  _ScreenIntroductionState();

  WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppUtil.customAppBar(context, 'THÔNG TIN LIÊN HỆ'),
      backgroundColor: Constants.white,
      body: Column(
        children: [
          Expanded(
              child: WebView(
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _webViewController = webViewController;
              _loadHtmlFromAssets(context);
            },
            onPageStarted: (url) {
              //Invoked when a page starts loading.
              print('webview onPageStarted');
//                    EasyLoading.show(status: 'loading...');
//                  AppUtil.showLoadingDialog(context);
            },
            onPageFinished: (url) {
              print('webview onPageFinished');
//                    EasyLoading.dismiss(animation:false);
              AppUtil.hideLoadingDialog(context);
            },
          ))
        ],
      ));

  _loadHtmlFromAssets(BuildContext context) async {
    final String strHtmlContent = """<!DOCTYPE html>
    <html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        </head>
      <body style='"margin: 0; padding: 0;'>
       
        <ul>
        <li><span>Nguồn: <a href=${widget.url}>${widget.url}</a></span></li>
        <li><span>Điện thoại: 1800 888 989</span></li>
        <li><span>Fax: 0210 6 254 103</span></li>
        <li><span>Email: Contact@benhviendakhoatinhphutho.vn</span></li>
        <li><span>Địa chỉ: Nguyễn Tất Thành - P. Tân Dân - TP. Việt Trì - T.Phú Thọ</span></li>
        </ul>
        </div>
      </body>
    </html>""";
    /* String strHtmlContent = """
      <!DOCTYPE html>
      <html>
        <head>
          <title>"""+widget.title+ """</title>
        </head>
        <body>
		<h4>"""+widget.title+ """</h4>
		</br>
        """+articleNewsData.content+
      """ </body>
      </html>""";*/
    AppUtil.showLogFull('HtmlContent display: $strHtmlContent');
    _webViewController.loadUrl(Uri.dataFromString(strHtmlContent,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
//      _webViewController.loadUrl(Uri.dataFromString(articleNewsData.content, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString());
  }
}
