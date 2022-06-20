import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

import '../../controller/ApiGraphQLControllerQuery.dart';
import '../../extension/HexColor.dart';
import '../../model/AppointmentData.dart';
import '../../model/GraphQLModels.dart';
import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';
import '../patient/ScreenPatientDetail.dart';

class ScreenQLTaiKhamTatCa extends StatefulWidget {
  final String keySearch;

  const ScreenQLTaiKhamTatCa({Key key, this.keySearch}) : super(key: key);

  @override
  ScreenQLTaiKhamTatCaState createState() => ScreenQLTaiKhamTatCaState();
}

class ScreenQLTaiKhamTatCaState extends State<ScreenQLTaiKhamTatCa> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//  var formatter = DateFormat(DATE_FORMAT);
  int page = 0, pageSize = 18, totalPages = 10;
  AppUtil appUtil = AppUtil();

  List<AppointmentData> items = [];
  final ScrollController _scrollController = ScrollController();
  bool isPerformingRequest = false;

  var now = DateTime.now();
  var formatter = DateFormat(Constants.FORMAT_DATEONLY);
  DateTime requestFromDate; // = "";
  DateTime requestToDate; // = "";

  @override
  void initState() {
    super.initState();

    setState(() {
      requestFromDate = now.subtract(const Duration(days: 7));
      requestToDate = now;
    });

    getMoreData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getMoreData();
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
    await getMoreData();
  }

  Future<void> getMoreData() async {
    AppUtil.showPrint(' getMoreData page: $page / total: $totalPages');
    if (!isPerformingRequest && page < totalPages) {
      setState(() => isPerformingRequest = true);
//      try {
      List<FilteredInput> arrFilterinput = [];
      List<SortedInput> arrSortedinput = [];
      final fromDate = DateTime(
          requestFromDate.year, requestFromDate.month, requestFromDate.day);
      final toDate = DateTime(
          requestToDate.year, requestToDate.month, requestToDate.day + 1);
      arrFilterinput.add(FilteredInput(
          'appointmentDate',
          '${fromDate.toIso8601String()},${toDate.toIso8601String()}',
          'between'));
      arrFilterinput.add(FilteredInput('followByDoctor', 'true', ''));
      arrFilterinput.add(FilteredInput(
          'code,inputPatient.fullName,inputPatient.phoneNumber',
          widget.keySearch,
          ''));
      arrSortedinput.add(SortedInput('createdTime', true));
      ApiGraphQLControllerQuery apiController = ApiGraphQLControllerQuery();

      QueryResult result = await apiController.requestGetAppointments(
          context, page, arrFilterinput, arrSortedinput);
      String response = result.data.toString();
//        log("Response requestGetAppointments: " + response);
      if (response != null) {
        var responseData = appUtil.processResponseWithPage(result);
        int code = responseData.code;
        String message = responseData.message;

        if (code == 0) {
          String jsonData = json.encode(responseData.data);
          log('### jsonData: $jsonData');
          if (jsonData == null || jsonData.length == 0) {
            totalPages = 0;
          } else {
            AppUtil.showPrint('### pages: ${responseData.pages}');
            totalPages = responseData.pages;
          }
          var tmpItems = List<AppointmentData>.from(responseData.data
              .map((item) => AppointmentData.fromJsonMap(item)));
          items.addAll(tmpItems);
//            setState(() {
//              items.addAll(tmpItems);
//            });
        } else {
          totalPages = 0;
          appUtil.showToast(context, message);
        }
      } else {
        await AppUtil.showPopup(context, 'Thông báo',
            'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại');
      }
//      } on Exception catch (e) {
//        AppUtil.showPrint('requestGetAppointments Error: ' + e.toString());
//      }

      if (items.isEmpty) {
        double edge = 50;
        double offsetFromBottom = _scrollController.position.maxScrollExtent -
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
      key: _scaffoldKey,
//        appBar: appUtil.getAppBar(new Text("Tin tức")),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.only(bottom: 10),
//            child: SingleChildScrollView(
        child: RefreshIndicator(
          onRefresh: reloadData,
          child: ListView.builder(
            shrinkWrap: true,
//              itemCount: items.length + 1,
            itemCount: items == null ? 2 : items.length + 2,
            itemBuilder: (context, index) {
              if (index == 0) {
                // return the header
                return Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(15),
//                                height: 40,
                      color: HexColor.fromHex(Constants.Color_divider),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
//                                          showPickerDateFromDate(context);
                              selectDate('from');
                            },
                            child: Center(
                              child: Row(
                                children: <Widget>[
                                  const Text('Từ ngày: ',
                                      style:
                                          Constants.styleTextNormalBlueColor),
                                  Container(
                                    padding: const EdgeInsets.only(bottom: 2),
                                    decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 1,
                                              color: HexColor.fromHex(
                                                  Constants.Color_bluetext))),
                                    ),
                                    child: Text(
                                      formatter.format(requestFromDate),
                                      style: Constants.styleTextNormalBlueColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              selectDate('to');
//                                        showPickerDateToDate(context);
                              //                                        showPicker(context);
                            },
                            child: Row(
                              children: <Widget>[
                                const Text('Đến ngày: ',
                                    style: Constants.styleTextNormalBlueColor),
                                Container(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 1,
                                            color: HexColor.fromHex(
                                                Constants.Color_bluetext))),
                                  ),
                                  child: Text(formatter.format(requestToDate),
                                      style:
                                          Constants.styleTextNormalBlueColor),
                                ),
                              ],
                            ),
                          ),
//                                    ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                );
              }

              index -= 1;

              if (index == items.length) {
                return _buildProgressIndicator();
              } else {
                AppointmentData itemData = items[index];
                if (itemData != null) {
                  itemData.patient ??= itemData.inputPatient;
                  return GestureDetector(
                      onTap: () async {
//                          DialogUtil.showDialogWithTitle(_scaffoldKey, context, titleSuccess: "Nội dung khám", messageSuccess: itemData.reason, okBtnFunction: null);
//                    Navigator.push(context, MaterialPageRoute(builder: (_) {
//                      return ScreenPatientDetail(itemID: itemData.id,);
//                    }));
                      },
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: const BoxDecoration(
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
                                                            'assets/qrcode_16.png',
                                                            width: 16,
                                                            height: 16,
                                                          ),
                                                          const SizedBox(
                                                            width: 3,
                                                          ),
                                                          itemData != null &&
                                                                  itemData.code !=
                                                                      null
                                                              ? Text(
                                                                  itemData.code,
                                                                  style: Constants
                                                                      .styleTextSmallBlueColor)
                                                              : const Text(
                                                                  'Chưa có mã KCB',
                                                                  style: Constants
                                                                      .styleTextSmallRedColor)
                                                          // itemData.patientCode != null ? Text(itemData.patientCode, style: Constants.styleTextSmallBlueColor) : SizedBox()
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
                                                                      'assets/phone_16.png',
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
                                                                      'assets/icon_select_date.png',
                                                                      width: 16,
                                                                      height:
                                                                          16,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Expanded(
                                                                      child: Text(
                                                                          'NS: ${DateFormat(Constants.FORMAT_DATEONLY).format(itemData.patient.birthDay)}',
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
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (_) =>
                                                                    ScreenPatientDetail(
                                                                      patientCode: itemData
                                                                          .patient
                                                                          .patientCode,
                                                                    )));
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                8, 8, 0, 8),
                                                        child: Image.asset(
                                                          'assets/icon_next_function.png',
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
                                      (itemData.createdTime != null)
                                          ? Row(
                                              children: [
                                                Image.asset(
                                                  'assets/ic_clock.png',
                                                  width: 16,
                                                  height: 16,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                      'Ngày đặt: ${DateFormat(Constants.FORMAT_DATETIME).format(itemData.createdTime)}',
                                                      style: Constants
                                                          .styleTextNormalSubColor),
                                                ),
                                              ],
                                            )
                                          : const SizedBox(),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      (itemData.doctor != null &&
                                              itemData.doctor.base != null &&
                                              itemData.doctor.base.fullName !=
                                                  null)
                                          ? Row(
                                              children: [
                                                Image.asset(
                                                  'assets/ic_doctor.png',
                                                  width: 16,
                                                  height: 16,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                      itemData
                                                          .doctor.base.fullName,
                                                      style: Constants
                                                          .styleTextNormalSubColor),
                                                ),
                                              ],
                                            )
                                          : const SizedBox(),
                                      /*   SizedBox(
                                          height: 6,
                                        ),*/
                                      (itemData.appointmentDate != null)
                                          ? Row(
                                              children: [
                                                Image.asset(
                                                  'assets/ic_clock.png',
                                                  width: 16,
                                                  height: 16,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text(
                                                          'Ngày khám: ${DateFormat(Constants.FORMAT_DATEONLY).format(itemData.appointmentDate)}  ',
                                                          style: Constants
                                                              .styleTextNormalSubColor),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            color: HexColor
                                                                .fromHex(
                                                                    '#F84366'),
                                                            borderRadius:
                                                                const BorderRadius
                                                                        .all(
                                                                    const Radius
                                                                            .circular(
                                                                        5))),
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 6,
                                                                vertical: 2),
                                                        child: Text(
                                                            itemData
                                                                .appointmentTime,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: Constants
                                                                    .Size_text_normal)),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                          : const SizedBox(),
                                      const SizedBox(
                                        height: 6,
                                      ),
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

  Future selectDate(String type) async {
    await showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) => Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: type == 'from' ? requestFromDate : requestToDate,
              onDateTimeChanged: (DateTime date) {
                setState(() {
                  switch (type) {
                    case 'from':
                      requestFromDate = date;
                      break;
                    case 'to':
                      requestToDate = date;
                      break;
                  }
                });
              },
              use24hFormat: false,
              minuteInterval: 1,
            ))).then((value) {
      AppUtil.showLog(
          'selectDate From: ${requestFromDate.toIso8601String()}, To: ${requestToDate.toIso8601String()}');
      //Call request statistic
//      loadReportAppointmentIndex(context);
      reloadData();
    });
  }
}
