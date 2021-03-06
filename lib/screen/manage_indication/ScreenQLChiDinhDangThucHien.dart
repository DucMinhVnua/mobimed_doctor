import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

import '../../controller/ApiGraphQLControllerQuery.dart';
import '../../custom/DrawTriangleShape.dart';
import '../../extension/HexColor.dart';
import '../../model/GraphQLModels.dart';
import '../../model/IndicationData.dart';
import '../../utils/AppStyle.dart';
import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';
import '../../utils/DefaultSmallRowButtonUI.dart';
import '../patient/ScreenPatientDetail.dart';
import 'ScreenQLChiDinhResultIndication.dart';

class ScreenQLChiDinhDangThucHien extends StatefulWidget {
  final String keySearch;

  const ScreenQLChiDinhDangThucHien({Key key, this.keySearch})
      : super(key: key);

  @override
  ScreenQLChiDinhDangThucHienState createState() =>
      ScreenQLChiDinhDangThucHienState();
}

class ScreenQLChiDinhDangThucHienState
    extends State<ScreenQLChiDinhDangThucHien> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var formatter = DateFormat(DATE_FORMAT);
  int page = 0, pageSize = 18, totalPages = 10;
  AppUtil appUtil = AppUtil();

  List<IndicationData> items = [];
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

  Future<Null> reloadData() async {
    page = 0;
    pageSize = 18;
    totalPages = 10;
    items.clear();
    _getMoreData();
  }

  _getMoreData() async {
    AppUtil.showPrint('_getMoreData page: $page / total: $totalPages');
    if (!isPerformingRequest && page < totalPages) {
      setState(() => isPerformingRequest = true);
      try {
        List<FilteredInput> arrFilterinput = [];
        arrFilterinput.add(FilteredInput('state', 'CONFIRM', ''));
        arrFilterinput.add(FilteredInput('textSearch', widget.keySearch, ''));

        List<SortedInput> arrSortedinput = [];
        arrSortedinput.add(SortedInput('_id', true));
        ApiGraphQLControllerQuery apiController = ApiGraphQLControllerQuery();

        QueryResult result = await apiController.requestGetIndications(
            context, page, arrFilterinput, arrSortedinput);
        String response = result.data.toString();
        AppUtil.showPrint('Response requestGetIndications: ' + response);
        if (response != null) {
          var responseData = appUtil.processResponseWithPage(result);
          int code = responseData.code;
          String message = responseData.message;

          if (code == 0) {
            String jsonData = json.encode(responseData.data);
            AppUtil.showLogFull('### jsonData: ' + jsonData);
            if (jsonData == null || jsonData.length == 0) {
              totalPages = 0;
            } else {
              AppUtil.showPrint('### pages: ' + responseData.pages.toString());
              totalPages = responseData.pages;
            }
            var tmpItems = List<IndicationData>.from(responseData.data
                .map((item) => IndicationData.fromJsonMap(item)));
            items.addAll(tmpItems);
          } else {
            totalPages = 0;
            appUtil.showToast(context, message);
          }
        } else {
          AppUtil.showPopup(context, 'Th??ng b??o',
              'Kh??ng th??? k???t n???i t???i m??y ch???. Vui l??ng ki???m tra k???t n???i v?? th??? l???i');
        }
      } on Exception catch (e) {
        AppUtil.showPrint('requestGetNewsArticles Error: ' + e.toString());
      }

      if (items.isEmpty) {
        double edge = 50;
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
        isPerformingRequest = false;
        page++;
      });
    }
  }

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
//        appBar: appUtil.getAppBar(new Text("Tin t???c")),
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
                IndicationData itemData = items[index];
                if (itemData != null) {
                  return GestureDetector(
                      onTap: () async {},
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
                                                          itemData.sessionCode !=
                                                                  null
                                                              ? Text(
                                                                  itemData
                                                                      .sessionCode,
                                                                  style: Constants
                                                                      .styleTextSmallBlueColor)
                                                              : const Text(
                                                                  'Ch??a c?? m?? KCB',
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
                                                                          'NS: ' +
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
                                                      DateFormat(Constants
                                                              .FORMAT_DATETIME)
                                                          .format(itemData
                                                              .createdTime),
                                                      style: Constants
                                                          .styleTextNormalSubColor),
                                                ),
                                              ],
                                            )
                                          : const SizedBox(),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      (itemData.doctor != null)
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
                                                      itemData.doctor.fullName,
                                                      style: Constants
                                                          .styleTextNormalSubColor),
                                                ),
                                              ],
                                            )
                                          : const SizedBox(),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      (itemData.service != null)
                                          ? Column(
                                              children: <Widget>[
                                                CustomPaint(
                                                    size: const Size(8, 8),
                                                    painter:
                                                        DrawTriangleShape()),
                                                Container(
                                                  width: double.infinity,
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 15,
                                                      horizontal: 15),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Text(
                                                        'N???i dung ch??? ?????nh: ' +
                                                            itemData
                                                                .service.name,
                                                        style: Constants
                                                            .styleTextNormalBlueColor,
                                                      ),
                                                      const SizedBox(
                                                        height: 3,
                                                      ),
                                                      itemData.note != null &&
                                                              itemData.note
                                                                  .isNotEmpty
                                                          ? Text(
                                                              'Ghi ch??: ' +
                                                                  itemData.note,
                                                              style: Constants
                                                                  .styleTextNormalBlueColor,
                                                            )
                                                          : const SizedBox()
                                                    ],
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: HexColor.fromHex(
                                                        Constants
                                                            .Color_divider),
                                                  ),
                                                )
                                              ],
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                            )
                                          : const SizedBox(),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      DefaultSmallRowButtonUI(
                                          clickButton: () =>
                                              {clickTaoKQ(itemData)},
                                          color: Constants.Color_primary,
                                          name: 'T???o k???t qu??? ch??? ?????nh')
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
                  AppUtil.showPrint('### appointmentData KH??NG C?? D??? LI???U ');
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

  clickTaoKQ(IndicationData indication) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ScreenQLChiDinhResultIndication(indication: indication)),
    );
  }
}
