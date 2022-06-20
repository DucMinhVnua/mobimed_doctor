import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import '../../controller/ApiGraphQLControllerQuery.dart';
import '../../extension/HexColor.dart';
import '../../model/GraphQLModels.dart';
import '../../model/NotificationData.dart';
import '../../utils/AppStyle.dart';
import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';

class ScreenListNotifications extends StatefulWidget {
  const ScreenListNotifications({
    Key key,
  }) : super(key: key);

  @override
  _ScreenListNotificationsState createState() =>
      _ScreenListNotificationsState();
}

class _ScreenListNotificationsState extends State<ScreenListNotifications> {
  var formatter = DateFormat(DATE_FORMAT);
  int page = 0, pageSize = 18, totalPages = 10;
  AppUtil appUtil = AppUtil();

  List<Map<String, dynamic>> items = [];
  ScrollController _scrollController = ScrollController();
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

  Future<Null> reloadData() async {
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
        List<FilteredInput> arrFilterinput = [];
        List<SortedInput> arrSortedinput = [];
        arrSortedinput.add(SortedInput('createdTime', true));
        ApiGraphQLControllerQuery apiController = ApiGraphQLControllerQuery();

        QueryResult result = await apiController.requestGetNotifications(
            context, page, arrFilterinput, arrSortedinput);
        String response = result.data.toString();
        log('Response requestGetNotificationSents: $response');
        if (response != null) {
          var responseData = appUtil.processResponseWithPage(result);
          int code = responseData.code;
          String message = responseData.message;
//    var json = jsonDecode(result.);

          if (code == 0) {
            String jsonData = json.encode(responseData.data);
            AppUtil.showPrint('### jsonData: $jsonData');
            if (jsonData == null || jsonData.length == 0) {
              totalPages = 0;
            } else {
              AppUtil.showPrint('### pages: ${responseData.pages}');
              totalPages = responseData.pages;
            }
            newEntries = json.decode(jsonData).cast<Map<String, dynamic>>();
          } else {
            totalPages = 0;
            appUtil.showToast(context, message);
          }
        } else {
          AppUtil.showPopup(context, 'Thông báo',
              'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại');
        }
      } on Exception catch (e) {
        AppUtil.showPrint('requestGetNotificationSents Error: $e');
      }

      if (newEntries.isEmpty) {
//        double edge = 10.0;
        double edge = 50.0;
        double offsetFromBottom = _scrollController.position.maxScrollExtent -
            _scrollController.position.pixels;
        if (offsetFromBottom < edge) {
          _scrollController.animateTo(
              _scrollController.offset - (edge - offsetFromBottom),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut);
        }
      }
      if (!mounted) {
        return;
      }
      setState(() {
        items.addAll(newEntries);
        isPerformingRequest = false;
        page++;
      });
    }
  }

  Widget _buildProgressIndicator() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Opacity(
            opacity: isPerformingRequest ? 1.0 : 0.0,
            child: const CircularProgressIndicator(),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppUtil.customAppBar(context, 'Thông báo'),
      backgroundColor: const Color(0xFFF2F2F2),
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
                NotificationData itemData =
                    NotificationData.fromJsonMap(items[index]);
                if (itemData != null) {
                  return GestureDetector(
                      onTap: () async {},
                      child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 10),
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                (itemData?.createdTime != null)
                                    ? Text(
                                        'Lúc: ${DateFormat(Constants.FORMAT_DATETIME).format(itemData.createdTime)}',
                                        maxLines: 2,
                                        style: TextStyle(
                                            color: HexColor.fromHex(
                                                Constants.Color_subtext),
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal,
                                            fontStyle: FontStyle.italic))
                                    : const SizedBox(
                                        height: 1,
                                      ),
                                const SizedBox(
                                  height: 4,
                                ),
                                (itemData?.name != null)
                                    ? Text(itemData.name,
                                        maxLines: 2,
                                        style: TextStyle(
                                            color: HexColor.fromHex(
                                                Constants.Color_maintext),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold))
                                    : const SizedBox(
                                        height: 1,
                                      ),
                                const SizedBox(
                                  height: 4,
                                ),
                                (itemData?.description != null)
                                    ? Text(itemData.description,
                                        maxLines: 2,
                                        style: TextStyle(
                                            color: HexColor.fromHex(
                                                Constants.Color_maintext),
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal))
                                    : const SizedBox(
                                        height: 1,
                                      ),
                              ],
                            ),
                          )));
                } else {
                  AppUtil.showPrint('### appointmentData KHÔNG CÓ DỮ LIỆU ');
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
