import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../controller/ApiGraphQLControllerQuery.dart';
import '../../controller/UserApiGraphQLControllerQuery.dart';
import '../../model/ArticleNewsData.dart';
import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';
import '../account/screen_introduction.dart';

// ignore: must_be_immutable
class ScreenWebViewNewsDetail extends StatefulWidget {
  String newsID = '';
  String title = '';

  ScreenWebViewNewsDetail(
      {Key key, @required this.newsID, @required this.title})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScreenWebViewNewsDetailState();
}

class _ScreenWebViewNewsDetailState extends State<ScreenWebViewNewsDetail> {
//  var _url = "http://register.app.benhvienphusanhanoi.vn/chinh-sach-quyen-rieng-tu";
  // ignore: unused_field
  final _key = UniqueKey();
  AppUtil appUtil = AppUtil();
  _ScreenWebViewNewsDetailState();

  WebViewController _webViewController;
  ArticleNewsData articleNewsData;

  @override
  void initState() {
    super.initState();

    AppUtil.showLog('News ID: ' + widget.newsID);
//    loadNewsDetails();
  }

  loadNewsDetails(BuildContext context) async {
    try {
      AppUtil.showLoadingDialog(context);

//      String response = null;
      // ignore: avoid_init_to_null
      QueryResult result = null;
      final String inReview =
          await AppUtil.getFromSetting(Constants.PREF_INREVIEW);
      if (inReview == 'true') {
        final UserApiGraphQLControllerQuery apiController =
            UserApiGraphQLControllerQuery();

        result = await apiController.requestGetNewsArticleDetail(
            context, widget.newsID);
      } else {
        final ApiGraphQLControllerQuery apiController =
            ApiGraphQLControllerQuery();

        result = await apiController.requestGetNewsArticleDetail(
            context, widget.newsID);
//        String response = result.data.toString();
      }
      final String response = result.data.toString();

//      ApiGraphQLControllerQuery apiController = ApiGraphQLControllerQuery();
//      QueryResult result = await apiController.requestGetNewsArticleDetail(context, widget.newsID);
//      String response = result.data.toString();
      AppUtil.showPrint('Response requestGetNewsArticleDetail: ' + response);
      AppUtil.hideLoadingDialog(context);
      if (response != null) {
        final responseData = appUtil.processResponse(result);
        final int code = responseData.code;
        final String message = responseData.message;

        if (code == 0) {
          final String jsonData = json.encode(responseData.data);
          AppUtil.showPrint('### jsonData: ' + jsonData);
          setState(() {
            articleNewsData = ArticleNewsData.fromJsonMap(jsonDecode(jsonData));
            AppUtil.showPrint('### articleNewsData: ' +
                jsonEncode(articleNewsData.toString()));
            widget.title = articleNewsData.title;
          });
        } else {
          AppUtil.showPopup(context, 'Thông báo', message);
        }
      } else {
        AppUtil.showPopup(context, 'Thông báo',
            'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại');
      }
      AppUtil.hideLoadingDialog(context);
    } on Exception catch (e) {
      AppUtil.hideLoadingDialog(context);
      AppUtil.showPrint('requestGetNewsArticles Error: ' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppUtil.customAppBar(context, 'Chi tiết'),
//      appBar: appUtil.getAppBar(new Text(widget.title)),
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
          )),
          // TextButton(
          //     onPressed: onClickIntroduction,
          //     child: const Text('Thông tin liên hệ',
          //         style: TextStyle(
          //             color: Colors.green,
          //             fontWeight: FontWeight.w500,
          //             fontFamily: Constants.fontName,
          //             letterSpacing: 0,
          //             fontSize: 14)))
        ],
      ));

  void onClickIntroduction() {
    Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) =>
              ScreenIntroduction(url: 'https://benhviendakhoatinhphutho.vn/')),
    );
  }

  _loadHtmlFromAssets(BuildContext context) async {
    AppUtil.hideLoadingDialog(context);
    await loadNewsDetails(context);
    if (articleNewsData != null) {
      final String strHtmlContent = """<!DOCTYPE html>
    <html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        </head>
      <body style='"margin: 0; padding: 0;'>
        <h3 style="text-align:center">${articleNewsData.title}</h3>
        <div>
          ${articleNewsData.content}
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
      AppUtil.showLogFull('HtmlContent display: ' + strHtmlContent);
      _webViewController.loadUrl(Uri.dataFromString(strHtmlContent,
              mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
          .toString());
//      _webViewController.loadUrl(Uri.dataFromString(articleNewsData.content, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString());
    } else {
      AppUtil.showLog('articleNewsData.content: NULL');
    }
  }
}
