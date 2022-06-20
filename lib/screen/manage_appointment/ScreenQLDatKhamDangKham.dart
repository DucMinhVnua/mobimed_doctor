import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

import '../../controller/ApiGraphQLControllerQuery.dart';
import '../../extension/HexColor.dart';
import '../../model/GraphQLModels.dart';
import '../../model/MedicalSessionData.dart';
import '../../utils/AppStyle.dart';
import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';
import '../patient/ScreenPatientDetail.dart';

class ScreenQLDatKhamDangKham extends StatefulWidget {
  final String keySearch;

  const ScreenQLDatKhamDangKham({Key key, this.keySearch}) : super(key: key);
  @override
  ScreenQLDatKhamDangKhamState createState() => ScreenQLDatKhamDangKhamState();
}

class ScreenQLDatKhamDangKhamState extends State<ScreenQLDatKhamDangKham> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var formatter = DateFormat(DATE_FORMAT);
  int page = 0, pageSize = 18, totalPages = 10;
  AppUtil appUtil = AppUtil();

  List<MedicalSessionData> items = [];
  ScrollController _scrollController = ScrollController();
  bool isPerformingRequest = false;
  // String keySearch = "";

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

  Future<Null> reloadData() async {
    page = 0;
    pageSize = 18;
    totalPages = 10;
    items.clear();
    _getMoreData();
  }

  _getMoreData() async {
    AppUtil.showPrint("_getMoreData page: $page / total: $totalPages");
    if (!isPerformingRequest && page < totalPages) {
      setState(() => isPerformingRequest = true);
      try {
        final now = DateTime.now();
        final List<FilteredInput> arrFilterinput = [];
        arrFilterinput.add(FilteredInput(
            "process", "[IN_QUEUE,CONCLUSION,WATING_CONCLUSION,CANCEL]", ""));
        arrFilterinput.add(FilteredInput("textSearch", widget.keySearch, ""));
        arrFilterinput.add(FilteredInput(
            "createdTime",
            now.year.toString() +
                "-" +
                now.month.toString() +
                "-" +
                now.day.toString(),
            ">="));
        final List<SortedInput> arrSortedinput = [];
        arrSortedinput.add(SortedInput("createdTime", true));
        final ApiGraphQLControllerQuery apiController =
            ApiGraphQLControllerQuery();

        final QueryResult result =
            await apiController.requestGetMedicalSessions(
                context, page, arrFilterinput, arrSortedinput);
        final String response = result.data.toString();
        AppUtil.showPrint("Response requestGetMedicalSessions: " + response);
        if (response != null) {
          final responseData = appUtil.processResponseWithPage(result);
          final int code = responseData.code;
          final String message = responseData.message;

          if (code == 0) {
            final String jsonData = json.encode(responseData.data);
            AppUtil.showLogFull("### jsonData: " + jsonData);
            if (jsonData == null || jsonData.length == 0) {
              totalPages = 0;
            } else {
              AppUtil.showPrint("### pages: " + responseData.pages.toString());
              totalPages = responseData.pages;
            }
            final tmpItems = List<MedicalSessionData>.from(responseData.data
                .map((item) => MedicalSessionData.fromJsonMap(item)));
            items.addAll(tmpItems);
          } else {
            totalPages = 0;
            appUtil.showToast(context, message);
          }
        } else {
          AppUtil.showPopup(context, "Thông báo",
              "Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại");
        }
      } on Exception catch (e) {
        AppUtil.showPrint('requestGetNewsArticles Error: ' + e.toString());
      }

      if (items.isEmpty) {
        final double edge = 50.0;
        final double offsetFromBottom =
            _scrollController.position.maxScrollExtent -
                _scrollController.position.pixels;
        if (offsetFromBottom < edge) {
          _scrollController.animateTo(
              _scrollController.offset - (edge - offsetFromBottom),
              duration: Duration(milliseconds: 500),
              curve: Curves.easeOut);
        }
      }
      if (!mounted) {
        return;
      }
//      if(newEntries.length > 0) {
      setState(() {
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
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Opacity(
            opacity: isPerformingRequest ? 1.0 : 0.0,
            child: CircularProgressIndicator(),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
      key: _scaffoldKey,
//        appBar: appUtil.getAppBar(new Text("Tin tức")),
      backgroundColor: Colors.white,
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
                final MedicalSessionData itemData = items[index];
                if (itemData != null) {
                  return GestureDetector(
                      onTap: () async {
//                          DialogUtil.showDialogWithTitle(_scaffoldKey, context, dialogTitle: "Nội dung khám", dialogMessage: itemData.reason, okBtnFunction: null);
//                    Navigator.push(context, MaterialPageRoute(builder: (_) {
//                      return ScreenPatientDetail(itemID: itemData.id,);
//                    }));
                      },
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      itemData.patient != null
                                          ? Column(
                                              children: <Widget>[
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: (itemData.patient
                                                                  ?.fullName !=
                                                              null)
                                                          ? Text(
                                                              itemData.patient
                                                                  .fullName,
                                                              style: Constants
                                                                  .styleTextNormalBlueColorBold)
                                                          : const SizedBox(
                                                              height: 1,
                                                            ),
                                                    ),
                                                    const SizedBox(
                                                      width: 12,
                                                    ),
                                                    GestureDetector(
                                                      child: Row(
                                                        children: [
                                                          Image.asset(
                                                            "assets/qrcode_16.png",
                                                            width: 16,
                                                            height: 16,
                                                          ),
                                                          const SizedBox(
                                                            width: 3,
                                                          ),
                                                          itemData.appointment !=
                                                                      null &&
                                                                  itemData.appointment
                                                                          .code !=
                                                                      null
                                                              ? Text(
                                                                  itemData
                                                                      .appointment
                                                                      .code,
                                                                  style: Constants
                                                                      .styleTextSmallBlueColor)
                                                              : const Text(
                                                                  "Chưa có mã KCB",
                                                                  style: Constants
                                                                      .styleTextSmallRedColor)
                                                          /*itemData.patientCode != null ? Text(itemData.patientCode, style: Constants.styleTextSmallBlueColor) : SizedBox()*/
                                                        ],
                                                      ),
                                                      onTap: () {},
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        children: [
                                                          (itemData.patient
                                                                      ?.phoneNumber !=
                                                                  null)
                                                              ? Row(
                                                                  children: [
                                                                    Image.asset(
                                                                      "assets/phone_16.png",
                                                                      width: 16,
                                                                      height:
                                                                          16,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Expanded(
                                                                      child: Text(
                                                                          itemData
                                                                              .patient
                                                                              .phoneNumber,
                                                                          style:
                                                                              Constants.styleTextNormalSubColor),
                                                                    ),
                                                                  ],
                                                                )
                                                              : const SizedBox(
                                                                  height: 0,
                                                                ),
                                                          const SizedBox(
                                                            height: 6,
                                                          ),
                                                          (itemData.patient
                                                                      ?.birthDay !=
                                                                  null)
                                                              ? Row(
                                                                  children: [
                                                                    Image.asset(
                                                                      "assets/icon_select_date.png",
                                                                      width: 16,
                                                                      height:
                                                                          16,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Expanded(
                                                                      child: Text(
                                                                          "NS: " +
                                                                              DateFormat(Constants.FORMAT_DATEONLY).format(itemData
                                                                                  .patient.birthDay),
                                                                          style:
                                                                              Constants.styleTextNormalSubColor),
                                                                    ),
                                                                  ],
                                                                )
                                                              : const SizedBox(
                                                                  height: 0,
                                                                ),
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        if (itemData.patient
                                                                    .patientCode ==
                                                                null ||
                                                            itemData
                                                                .patient
                                                                .patientCode
                                                                .isEmpty) {
                                                          appUtil.showToast(
                                                              context,
                                                              "Không thể lấy thông tin bệnh nhân này");
                                                        } else {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      ScreenPatientDetail(
                                                                        patientCode: itemData
                                                                            .patient
                                                                            .patientCode,
                                                                      )));
                                                        }
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                8, 8, 0, 8),
                                                        child: Image.asset(
                                                          "assets/icon_next_function.png",
                                                          width: 30,
                                                          height: 22,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            )
                                          : const SizedBox(),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      (itemData.userAction?.createdTime != null)
                                          ? Row(
                                              children: [
                                                Image.asset(
                                                  "assets/icon_select_date.png",
                                                  width: 16,
                                                  height: 16,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                      "Ngày đặt: " +
                                                          DateFormat(Constants
                                                                  .FORMAT_DATEONLY)
                                                              .format(itemData
                                                                  .userAction
                                                                  .createdTime),
                                                      style: Constants
                                                          .styleTextNormalSubColor),
                                                ),
                                              ],
                                            )
                                          : const SizedBox(
                                              height: 0,
                                            ),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      (itemData.userAction != null &&
                                              itemData.userAction
                                                      ?.appointment !=
                                                  null)
                                          ? Row(
                                              children: [
                                                Image.asset(
                                                  "assets/icon_select_date.png",
                                                  width: 16,
                                                  height: 16,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                      "Ngày khám: " +
                                                          DateFormat(Constants
                                                                  .FORMAT_DATEONLY)
                                                              .format(itemData
                                                                  .userAction
                                                                  ?.appointment
                                                                  ?.appointmentDate),
                                                      style: Constants
                                                          .styleTextNormalSubColor),
                                                ),
                                              ],
                                            )
                                          : const SizedBox(
                                              height: 0,
                                            ),
                                      itemData.reason != null &&
                                              itemData.reason.length > 0
                                          ? Column(
                                              children: <Widget>[
                                                const SizedBox(
                                                  height: 6,
                                                ),
                                                Container(
                                                  width: double.infinity,
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 15,
                                                      horizontal: 15),
                                                  child: Text(
                                                    "Lý do khám: " +
                                                        itemData.reason,
                                                    style: Constants
                                                        .styleTextNormalBlueColor,
                                                  ),
                                                  decoration: BoxDecoration(
                                                      color: HexColor.fromHex(
                                                          Constants
                                                              .Color_divider),
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              const Radius
                                                                      .circular(
                                                                  5))),
                                                ),
                                              ],
                                            )
                                          : const SizedBox()
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 1,
                            color: HexColor.fromHex(Constants.Color_divider),
                          )
                        ],
                      )
//                              )
                      );
                } else {
                  AppUtil.showPrint("### appointmentData KHÔNG CÓ DỮ LIỆU ");
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
