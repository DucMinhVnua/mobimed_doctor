import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:DoctorApp/controller/ApiGraphQLControllerQuery.dart';
import 'package:DoctorApp/custom/DrawTriangleShape.dart';
import 'package:DoctorApp/extension/HexColor.dart';
import 'package:DoctorApp/model/GraphQLModels.dart';
import 'package:DoctorApp/model/IndicationData.dart';
import 'package:DoctorApp/utils/AppStyle.dart';
import 'package:DoctorApp/utils/AppUtil.dart';
import 'package:DoctorApp/utils/Constant.dart';

// ignore: must_be_immutable
class ScreenKetQuaChiDinh extends StatefulWidget {
  String sessionCode = '';

  ScreenKetQuaChiDinh({Key key, this.sessionCode}) : super(key: key);

  @override
  _ScreenKetQuaChiDinhState createState() => _ScreenKetQuaChiDinhState();
}

class _ScreenKetQuaChiDinhState extends State<ScreenKetQuaChiDinh> {
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
//      try {
      final List<FilteredInput> arrFilterinput = [];
      final List<SortedInput> arrSortedinput = [];
//        arrFilterinput.add(FilteredInput("process", "CONCLUSION", ""));
      if (widget.sessionCode != null && widget.sessionCode != '') {
        arrFilterinput
            .add(FilteredInput('sessionCode', widget.sessionCode, ''));
      }
//        arrFilterinput.add(FilteredInput("state", "cancel,served", "in"));
      arrSortedinput.add(SortedInput('createdTime', true));
      final ApiGraphQLControllerQuery apiController =
          ApiGraphQLControllerQuery();

      final QueryResult result = await apiController.requestGetIndications(
          context, page, arrFilterinput, arrSortedinput);
      final String response = result.data.toString();
      AppUtil.showPrint('Response requestGetIndications: $response');
      if (response != null) {
        final responseData = appUtil.processResponseWithPage(result);
        final int code = responseData.code;
        final String message = responseData.message;

        if (code == 0) {
          final String jsonData = json.encode(responseData.data);
          AppUtil.showLogFull('### jsonData: $jsonData');
          if (jsonData == null || jsonData.length == 0) {
            totalPages = 0;
          } else {
            AppUtil.showPrint('### pages: ${responseData.pages}');
            totalPages = responseData.pages;
          }
          final tmpItems = List<IndicationData>.from(responseData.data
              .map((item) => IndicationData.fromJsonMap(item)));
          items.addAll(tmpItems);
        } else {
          totalPages = 0;
          AppUtil.showPopup(context, 'Thông báo', message);
        }
      } else {
        AppUtil.showPopup(context, 'Thông báo',
            'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại');
      }

      if (items.isEmpty) {
        final double edge = 50;
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
        padding: const EdgeInsets.all(8),
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
      appBar: AppUtil.customAppBar(context, 'KẾT QUẢ CHỈ ĐỊNH'),
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
                final IndicationData itemData = items[index];
//                  MedicalSessionData subitemMedicalSession = MedicalSessionData.fromJsonMap(jsonDecode(jsonEncode(itemData.data)));
//                  AppUtil.showLog("Code: " + itemData.data["Code"]);
                if (itemData != null) {
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
                                itemData.patient != null
                                    ? Row(
                                        children: <Widget>[
                                          CircleAvatar(
                                            radius: 25,
                                            backgroundColor: Colors.white,
//                              backgroundColor: HexColor.fromHex(Constants.Color_primary),
                                            child: ClipOval(
                                              child: itemData.patient.avatar !=
                                                          null &&
                                                      !appUtil
                                                          .checkValidLocalPath(
                                                              itemData.patient
                                                                  .avatar)
                                                  ? FadeInImage.assetNetwork(
                                                      placeholder:
                                                          'assets/defaultimage.png',
                                                      image: itemData
                                                          .patient.avatar,
                                                      matchTextDirection: true,
                                                      fit: BoxFit.cover,
                                                      width: 50,
                                                      height: 50,
                                                    )
                                                  : Image.asset(
                                                      'assets/defaultimage.png',
                                                      matchTextDirection: true,
                                                      fit: BoxFit.cover,
                                                      width: 50,
                                                      height: 50,
                                                    ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 12,
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          itemData.patient != null
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    (itemData.patient
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
                                                    const SizedBox(
                                                      height: 8,
                                                    ),
                                                    (itemData.createdTime !=
                                                            null)
                                                        ? Row(
                                                            children: [
                                                              Image.asset(
                                                                'assets/icon_select_date.png',
                                                                width: 16,
                                                                height: 16,
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                    'Ngày đặt: ${DateFormat(Constants.FORMAT_DATETIME_TIMEFIRST).format(itemData.createdTime)}',
                                                                    style: Constants
                                                                        .styleTextNormalSubColor),
                                                              ),
                                                            ],
                                                          )
                                                        : const SizedBox(
                                                            height: 0,
                                                          ),
                                                  ],
                                                )
                                              : const SizedBox(),
                                        ],
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                      ),
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
                                                      'Bác sĩ: ${itemData.doctor.fullName}',
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
                                                        'Nội dung chỉ định: ${itemData.service.name}',
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
                                                              'Ghi chú: ${itemData.note}',
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

  TextEditingController editingController = TextEditingController();
  String keySearch = '';
  Timer searchOnStoppedTyping;

  search(value) async {
    AppUtil.showPrint('Search key: $value');

    page = 0;
    pageSize = 18;
    totalPages = 10;
    items.clear();

    setState(() {
      keySearch = value;
    });

    _getMoreData();
  }
}
