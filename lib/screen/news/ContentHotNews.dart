import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../controller/ApiGraphQLControllerQuery.dart';
import '../../controller/UserApiGraphQLControllerQuery.dart';
import '../../model/ArticleNewsData.dart';
import '../../pageviewslide/Indicator.dart';
import '../../utils/AppUtil.dart';
import 'ScreenWebViewNewsDetailWeb.dart';

class ContentHotNews extends StatefulWidget {
  const ContentHotNews({
    Key key,
  }) : super(key: key);

  @override
  _ContentHotNewsState createState() => _ContentHotNewsState();
}

class _ContentHotNewsState extends State<ContentHotNews> {
  AppUtil appUtil = AppUtil();
  final PageController controller = PageController(initialPage: 0);
  List<ArticleNewsData> arrHotNews = [];
  bool isLoadingDataHotNews = false;
  void _pageChanged(int index) {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    requestGetHotNews();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> requestGetHotNews() async {
    try {
      setState(() {
        isLoadingDataHotNews = true;
        arrHotNews.clear();
      });
      final UserApiGraphQLControllerQuery apiController =
          UserApiGraphQLControllerQuery();

      final QueryResult result = await apiController.requestGetHotNews(context);
      final String response = result.data.toString();
      if (response != null) {
        final responseData = appUtil.processResponse(result);
        final int code = responseData.code;
        final String message = responseData.message;

        if (code == 0) {
          arrHotNews = List<ArticleNewsData>.from(
              responseData.data.map((it) => ArticleNewsData.fromJsonMap(it)));
          isLoadingDataHotNews = false;

          AppUtil.showLogFull('GetHotNews: ' + jsonEncode(arrHotNews));
        } else {
          await AppUtil.showPopup(context, 'Thông báo', message);
        }
      } else {
        await AppUtil.showPopup(context, 'Thông báo',
            'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại');
      }
    } on Exception catch (e) {
      AppUtil.showPrint('requestGetHotNews Error: ' + e.toString());
    }
    setState(() {
      isLoadingDataHotNews = false;
    });
  }

  @override
  Widget build(BuildContext context) => isLoadingDataHotNews == false
      ? arrHotNews != null && arrHotNews.isNotEmpty
          ? SizedBox(
              height: 200,
              child: Stack(
                children: <Widget>[
                  Container(
                    color: Colors.black,
                    child: PageView.builder(
                      itemCount: arrHotNews.length,
                      onPageChanged: _pageChanged,
                      controller: controller,
                      itemBuilder: (context, index) {
                        final ArticleNewsData itemHotNews = arrHotNews[index];
                        return GestureDetector(
                            child: Stack(
                              children: <Widget>[
                                itemHotNews.thumbUrl != null &&
                                        itemHotNews.thumbUrl.length > 10
                                    ? SizedBox(
                                        width: double.infinity,
                                        child: FadeInImage.assetNetwork(
                                          fit: BoxFit.fill,
                                          placeholder:
                                              'assets/defaultimage.png',
                                          image: itemHotNews.thumbUrl ?? '',
                                        ),
                                      )
                                    : const AssetImage(
                                        'assets/defaultimage.png',
                                      ),
                                Container(
                                    alignment: Alignment.bottomCenter,
                                    child: Stack(
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                            padding: const EdgeInsets.all(15),
                                            width: double.infinity,
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                (itemHotNews?.title != null)
                                                    ? Text(itemHotNews.title,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold))
                                                    : const SizedBox(
                                                        height: 1,
                                                      ),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                (itemHotNews?.shortDesc != null)
                                                    ? Text(
                                                        appUtil.parseHtmlString(
                                                            itemHotNews
                                                                .shortDesc),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal))
                                                    : const SizedBox(
                                                        height: 1,
                                                      ),
                                              ],
                                            ),
                                          ),
//                                  ),
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                            onTap: () {
                              showNewsDetailForWeb(
                                  itemHotNews.id, itemHotNews.title);
                            });
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Indicator(
                      controller: controller,
                      itemCount: arrHotNews.length,
                    ),
                  )
                ],
              ),
            )
          : const SizedBox()
      : const SizedBox(
          width: 70,
          height: 70,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );

  Future<void> showNewsDetailForWeb(String id, String title) async {
    String htmlString = '';
    try {
      final ApiGraphQLControllerQuery apiController =
          ApiGraphQLControllerQuery();

      final QueryResult result =
          await apiController.requestGetNewsArticleDetail(context, id);
      final String response = result.data.toString();
      if (response != null) {
        final responseData = appUtil.processResponse(result);
        final int code = responseData.code;
        final String message = responseData.message;

        if (code == 0) {
          setState(() {
            htmlString =
                '"<h3 style="text-align:center">${responseData.data["title"].toString()}</h3><div>${responseData.data["content"].toString()}</div>';
          });
        } else {
          await AppUtil.showPopup(context, 'Thông báo', message);
        }
      } else {
        await AppUtil.showPopup(context, 'Thông báo',
            'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại');
      }
      await AppUtil.hideLoadingDialog(context);
    } on Exception catch (e) {
      await AppUtil.hideLoadingDialog(context);
      AppUtil.showPrint('requestGetNewsArticles Error: ' + e.toString());
    }
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ScreenWebViewNewsDetailWeb(
                  newsID: id,
                  title: title,
                  htmlString: htmlString,
                )));
  }
}
