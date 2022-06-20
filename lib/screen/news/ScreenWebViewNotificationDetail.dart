import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../controller/ApiGraphQLControllerQuery.dart';
import '../../model/NotificationData.dart';
import '../../utils/AppUtil.dart';

// ignore: must_be_immutable
class ScreenWebViewNotificationDetail extends StatefulWidget {
  String itemID = '';
  String title = '';

  ScreenWebViewNotificationDetail(
      {Key key, @required this.itemID, @required this.title})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _ScreenWebViewNotificationDetailState();
}

class _ScreenWebViewNotificationDetailState
    extends State<ScreenWebViewNotificationDetail> {
//  var _url = "http://register.app.benhvienphusanhanoi.vn/chinh-sach-quyen-rieng-tu";
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // ignore: unused_field
  final _key = UniqueKey();
  AppUtil appUtil = new AppUtil();
  _ScreenWebViewNotificationDetailState();

  WebViewController _webViewController;
  NotificationData itemData;

  @override
  void initState() {
    super.initState();

    AppUtil.showLog('item ID: ${widget.itemID}');
//    loadNewsDetails();
  }

  loadNewsDetails(BuildContext context) async {
    try {
//      AppUtil.showLoadingDialog(context);
      ApiGraphQLControllerQuery apiController = new ApiGraphQLControllerQuery();

      QueryResult result =
          await apiController.requestGetNotification(context, widget.itemID);
      String response = result.data.toString();
      AppUtil.showPrint('Response requestGetNotificationSent: $response');
      AppUtil.hideLoadingDialog(context);
      if (response != null) {
        var responseData = appUtil.processResponse(result);
        int code = responseData.code;
        String message = responseData.message;

        if (code == 0 && responseData != null && responseData.data != null) {
          AppUtil.hideLoadingDialog(context);
          String jsonData = json.encode(responseData.data);
          AppUtil.showPrint('### jsonData: $jsonData');
          setState(() {
            itemData = NotificationData.fromJsonMap(jsonDecode(jsonData));
            AppUtil.showPrint(
                '### articleNewsData: ${jsonEncode(itemData.toString())}');
          });
        } else {
          AppUtil.hideLoadingDialog(context);
          appUtil.showToastWithScaffoldState(_scaffoldKey, message);
        }
      } else {
        AppUtil.showPopup(context, 'Thông báo',
            'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại');
      }
      AppUtil.hideLoadingDialog(context);
    } on Exception catch (e) {
      AppUtil.hideLoadingDialog(context);
      AppUtil.showPrint('requestGetNewsArticles Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      key: _scaffoldKey,
      appBar: AppUtil.customAppBar(context, widget.title),
      body: Column(
        children: [
          Expanded(
              child: WebView(
//          initialUrl: '',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _webViewController = webViewController;
              _loadHtmlFromAssets(context);
            },
            onPageStarted: (url) {
              //Invoked when a page starts loading.
              AppUtil.showPrint('webview onPageStarted');
//                    EasyLoading.show(status: 'loading...');
//                  AppUtil.showLoadingDialog(context);
            },
            onPageFinished: (url) {
              AppUtil.showPrint('webview onPageFinished');
//                    EasyLoading.dismiss(animation:false);
              AppUtil.hideLoadingDialog(context);
            },
          ))
        ],
      ));

  _loadHtmlFromAssets(BuildContext context) async {
    AppUtil.hideLoadingDialog(context);
    await loadNewsDetails(context);
    if (itemData != null) {
      AppUtil.showLog('itemData.content: ${itemData.content}');

      String strHtmlContent = """<!DOCTYPE html>
    <html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        </head>
      <body style='"margin: 0; padding: 0;'>
        <div>
          ${itemData.content}
        </div>
      </body>
    </html>""";

      _webViewController.loadUrl(Uri.dataFromString(strHtmlContent,
              mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
          .toString());
//      _webViewController.loadUrl(Uri.dataFromString(itemData.content, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString());
    } else {
      AppUtil.showLog('itemData.content: NULL');
    }
  }
}
