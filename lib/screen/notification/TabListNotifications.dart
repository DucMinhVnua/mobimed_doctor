import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:DoctorApp/controller/ApiGraphQLControllerQuery.dart';
import 'package:DoctorApp/extension/HexColor.dart';
import 'package:DoctorApp/model/GraphQLModels.dart';
import 'package:DoctorApp/model/NotificationData.dart';
import 'package:DoctorApp/utils/AppStyle.dart';
import 'package:DoctorApp/utils/AppUtil.dart';
import 'package:DoctorApp/utils/Constant.dart';

class TabListNotifications extends StatefulWidget {
  TabListNotifications({
    Key key,
  }) : super(key: key);

  @override
  _TabListNotificationsState createState() => _TabListNotificationsState();
}

class _TabListNotificationsState extends State<TabListNotifications> {
  var formatter = new DateFormat(DATE_FORMAT);
  int page = 0, pageSize = 18, totalPages = 10;
  AppUtil appUtil = new AppUtil();

//  List<int> items = List.generate(10, (i) => i);
  List<Map<String, dynamic>> items = [];
  ScrollController _scrollController = new ScrollController();
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
  Future<List<int>> fakeRequest(int from, int to) async {
    return Future.delayed(Duration(seconds: 2), () {
      return List.generate(to - from, (i) => i + from);
    });
  }

  /*Future<Null> refreshData() async {
    page = 0;
    pageSize = 18;
    items.clear();
    _getMoreData();
  }*/

  Future<Null> reloadData() async {
    page = 0;
    pageSize = 18;
    totalPages = 10;
    items.clear();
    _getMoreData();
  }

  _getMoreData() async {
//    getArticles();

    AppUtil.showPrint("_getMoreData page: $page / total: $totalPages");
    if (!isPerformingRequest && page < totalPages) {
      setState(() => isPerformingRequest = true);
//      List<int> newEntries = await fakeRequest(items.length, items.length); //returns empty list
      List<Map<String, dynamic>> newEntries = [];
      //show loading
//      appUtil.showLoadingDialog(context);
      try {
        List<FilteredInput> arrFilterinput = [];
        List<SortedInput> arrSortedinput = [];
        arrSortedinput.add(SortedInput("createdTime", true));
        ApiGraphQLControllerQuery apiController =
            new ApiGraphQLControllerQuery();

        QueryResult result = await apiController.requestGetNotifications(
            context, page, arrFilterinput, arrSortedinput);
        String response = result.data.toString();
        log("Response requestGetNotificationSents: " + response);
        if (response != null) {
          var responseData = appUtil.processResponseWithPage(result);
          int code = responseData.code;
          String message = responseData.message;
//    var json = jsonDecode(result.);

          if (code == 0) {
            String jsonData = json.encode(responseData.data);
            AppUtil.showPrint("### jsonData: " + jsonData);
            if (jsonData == null || jsonData.length == 0) {
              totalPages = 0;
            } else {
              AppUtil.showPrint("### pages: " + responseData.pages.toString());
              totalPages = responseData.pages;
            }
            newEntries = json.decode(jsonData).cast<Map<String, dynamic>>();
          } else {
            totalPages = 0;
            appUtil.showToast(context, message);
          }
        } else {
          AppUtil.showPopup(context, "Thông báo",
              "Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại");
        }
      } on Exception catch (e) {
        AppUtil.showPrint('requestGetNotificationSents Error: ' + e.toString());
      }

      if (newEntries.isEmpty) {
//        double edge = 10.0;
        double edge = 50.0;
        double offsetFromBottom = _scrollController.position.maxScrollExtent -
            _scrollController.position.pixels;
        if (offsetFromBottom < edge) {
          _scrollController.animateTo(
              _scrollController.offset - (edge - offsetFromBottom),
              duration: new Duration(milliseconds: 500),
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

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isPerformingRequest ? 1.0 : 0.0,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
//        appBar: appUtil.getAppBar(new Text("Thông báo")),
        backgroundColor: Color(0xFFFFFFFF),
        body: new Container(
          padding: EdgeInsets.only(top: 10),
//            child: SingleChildScrollView(
          child: new RefreshIndicator(
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
                    return new GestureDetector(
                        onTap: () async {},
                        child: Container(
                            margin: EdgeInsets.all(0),
                            decoration: new BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: HexColor.fromHex(
                                              Constants.Color_primary),
                                          borderRadius:
                                              BorderRadius.circular(23)),
                                      width: 46,
                                      height: 46,
                                      child: Center(
                                        child: Text(
                                          "TB",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        (itemData?.createdTime != null)
                                            ? Text(
                                                "" +
                                                    DateFormat(Constants
                                                            .FORMAT_DATETIME)
                                                        .format(itemData
                                                            .createdTime),
                                                maxLines: 2,
                                                style: TextStyle(
                                                    color: HexColor.fromHex(
                                                        Constants
                                                            .Color_subtext),
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontStyle:
                                                        FontStyle.normal))
                                            : SizedBox(
                                                height: 1,
                                              ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        (itemData?.name != null)
                                            ? Text(itemData.name,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    color: HexColor.fromHex(
                                                        Constants
                                                            .Color_maintext),
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal))
                                            : SizedBox(
                                                height: 1,
                                              ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        (itemData?.description != null)
                                            ? Text(itemData.description,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    color: HexColor.fromHex(
                                                        Constants
                                                            .Color_subtext),
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal))
                                            : SizedBox(
                                                height: 1,
                                              ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Divider(
                                  color:
                                      HexColor.fromHex(Constants.Color_divider),
                                  thickness: 1,
                                )
                              ],
                            )));
                  } else {
                    AppUtil.showPrint("### appointmentData KHÔNG CÓ DỮ LIỆU ");
//              AppUtil.showPrint(appointmentData.fullName + "/" + appointmentData.phoneNumber);
                    return SizedBox(
                      height: 0,
                    );
                  }
//                      AppUtil.showPrint(appointmentData.fullName +
//                          "/" +
//                          appointmentData.phoneNumber);
////            return ListTile(title: new Text("Number $index"));

                }
              },
              controller: _scrollController,
            ),
          ),
        ));
  }
}
