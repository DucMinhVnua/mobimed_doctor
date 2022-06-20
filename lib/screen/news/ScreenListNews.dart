import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

import '../../controller/ApiGraphQLControllerQuery.dart';
import '../../controller/UserApiGraphQLControllerQuery.dart';
import '../../extension/HexColor.dart';
import '../../model/ArticleNewsData.dart';
import '../../model/GraphQLModels.dart';
import '../../utils/AppStyle.dart';
import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';
import 'ScreenWebViewNewsDetail.dart';

class ScreenListNews extends StatefulWidget {
  const ScreenListNews({
//    @required this.videoPlayerController,
//    this.looping,
    Key key,
  }) : super(key: key);

  @override
  _ScreenListNewsState createState() => _ScreenListNewsState();
}

class _ScreenListNewsState extends State<ScreenListNews> {
//class _ScreenListNewsState extends State<ScreenListNews>  with AutomaticKeepAliveClientMixin<ScreenListNews>  {
  var formatter = DateFormat(DATE_FORMAT);
  int page = 0, pageSize = 18, totalPages = 10;
  AppUtil appUtil = AppUtil();

//  List<int> items = List.generate(10, (i) => i);
  List<Map<String, dynamic>> items = [];
  final ScrollController _scrollController = ScrollController();
  bool isPerformingRequest = false;

  @override
  void initState() {
    super.initState();
    _getMoreData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// from - inclusive, to - exclusive
  Future<List<int>> fakeRequest(int from, int to) async => Future.delayed(
      const Duration(seconds: 2),
      () => List.generate(to - from, (i) => i + from));

  Future<void> reloadData() async {
    page = 0;
    pageSize = 18;
    totalPages = 10;
    items.clear();
    _getMoreData();
  }

  _getMoreData() async {
//    getArticles();

    AppUtil.showPrint('_getMoreData page: $page / total: $totalPages');
    if (!isPerformingRequest && page < totalPages) {
      setState(() => isPerformingRequest = true);
//      List<int> newEntries = await fakeRequest(items.length, items.length); //returns empty list
      List<Map<String, dynamic>> newEntries = [];
      //show loading
//      appUtil.showLoadingDialog(context);
      try {
        final List<FilteredInput> arrFilterinput = [];
        final List<SortedInput> arrSortedinput = [];
        // ignore: avoid_init_to_null
        String response = null;
        // ignore: avoid_init_to_null
        QueryResult result = null;
        final String inReview =
            await AppUtil.getFromSetting(Constants.PREF_INREVIEW);
        if (inReview == 'true') {
          arrFilterinput.add(FilteredInput('type', 'USER_NEWS', ''));
          arrSortedinput.add(SortedInput('createdTime', true));
          final UserApiGraphQLControllerQuery apiController =
              UserApiGraphQLControllerQuery();

          result = await apiController.requestGetNewsArticles(
              context, page, arrFilterinput, arrSortedinput);
          response = result.data.toString();
        } else {
          arrFilterinput.add(FilteredInput('type', 'INTERNAL_NEWS', ''));
          arrSortedinput.add(SortedInput('createdTime', true));
          final ApiGraphQLControllerQuery apiController =
              ApiGraphQLControllerQuery();

          result = await apiController.requestGetNewsArticles(
              context, page, arrFilterinput, arrSortedinput);
          response = result.data.toString();
        }

        AppUtil.showPrint('Response requestGetNewsArticles: ' + response);
        if (response != null && result != null) {
          final responseData = appUtil.processResponseWithPage(result);
          final int code = responseData.code;
          final String message = responseData.message;
//    var json = jsonDecode(result.);

          if (code == 0) {
            final String jsonData = json.encode(responseData.data);
            AppUtil.showLogFull('### jsonData: ' + jsonData);
            if (jsonData == null || jsonData.length == 0) {
              totalPages = 0;
            } else {
              AppUtil.showPrint('### pages: ' + responseData.pages.toString());
              totalPages = responseData.pages;
            }
            newEntries = json.decode(jsonData).cast<Map<String, dynamic>>();
          } else {
            await AppUtil.showPopup(context, 'Thông báo', message);
          }
        } else {
          await AppUtil.showPopup(context, 'Thông báo',
              'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại');
        }
      } on Exception catch (e) {
        AppUtil.showPrint('requestGetNewsArticles Error: ' + e.toString());
      }

      if (newEntries.isEmpty) {
//        double edge = 10.0;
        const double edge = 50;
        final double offsetFromBottom =
            _scrollController.position.maxScrollExtent -
                _scrollController.position.pixels;
        if (offsetFromBottom < edge) {
          await _scrollController.animateTo(
              _scrollController.offset - (edge - offsetFromBottom),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut);
        }
      }
      if (!mounted) {
        return;
      }
//      if(newEntries.length > 0) {
      setState(() {
        items.addAll(newEntries);
        isPerformingRequest = false;
        page++;
      });
//      }
      //hide loading
//      appUtil.hideDialog(context);
    }
  }

//  @override
//  bool wantKeepAlive = true;

  Widget _buildProgressIndicator() => Padding(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Opacity(
            opacity: isPerformingRequest ? 1.0 : 0.0,
            child: const CircularProgressIndicator(),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppUtil.customAppBar(context, 'Tin tức'),
      backgroundColor: const Color(0xFFFFFFFF),
      body: Container(
        padding: const EdgeInsets.only(top: 10),
//            child: SingleChildScrollView(
        child: RefreshIndicator(
          onRefresh: reloadData,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: items.length + 1,
            itemBuilder: (context, index) {
              if (index == items.length) {
                return _buildProgressIndicator();
              } else {
                final ArticleNewsData itemData =
                    ArticleNewsData.fromJsonMap(items[index]);
                if (itemData != null) {
                  return GestureDetector(
                      onTap: () async {
                        //Chuyển trạng thái tin tức này thành đã đọc
                        try {
                          setState(() {
                            items[index]['is_read'] = true;
                          });
                        } catch (e) {}

                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ScreenWebViewNewsDetail(
                                      newsID: itemData.id,
                                      title: itemData.title,
                                    )));
                      },
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Row(
                              children: <Widget>[
                                const SizedBox(
                                  width: 8,
                                ),
                                Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: FadeInImage(
                                      image:
                                          NetworkImage(itemData.thumbUrl ?? ''),
                                      placeholder: const AssetImage(
                                          'assets/defaultimage.png'),
                                      fit: BoxFit.cover,
                                      width: 85,
                                      height: 70,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      (itemData?.title != null)
                                          ? Text(itemData.title,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: HexColor.fromHex(
                                                      Constants.Color_maintext),
                                                  fontSize: 15,
                                                  fontWeight: itemData.isRead
                                                      ? FontWeight.normal
                                                      : FontWeight.bold))
                                          : const SizedBox(
                                              height: 1,
                                            ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      (itemData?.shortDesc != null)
                                          ?
                                          /* Wrap(
                                    children: <Widget>[HtmlWidget(itemData.shortDesc)],
                                  ) */
                                          Text(
                                              appUtil.parseHtmlString(
                                                  itemData.shortDesc),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: itemData.isRead
                                                      ? Colors.black54
                                                      : HexColor.fromHex(
                                                          Constants
                                                              .Color_subtext),
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.normal))
                                          : const SizedBox(
                                              height: 1,
                                            ),
//                                  SizedBox(height: 5,),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Divider(
                            color: HexColor.fromHex(Constants.Color_divider),
                            thickness: 1,
                            indent: 120,
                          )
                        ],
                      ));
                } else {
                  AppUtil.showPrint('### appointmentData KHÔNG CÓ DỮ LIỆU ');
//              AppUtil.showPrint(appointmentData.fullName + "/" + appointmentData.phoneNumber);
                  return const SizedBox(
                    height: 0,
                  );
                }
              }
            },
            controller: _scrollController,
          ),
        ),
      ));
}
