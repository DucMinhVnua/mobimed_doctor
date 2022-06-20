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
import '../patient/ScreenPatientDetail.dart';

class ScreenQLChiDinhChiDinh extends StatefulWidget {
  final String keySearch;

  const ScreenQLChiDinhChiDinh({Key key, this.keySearch}) : super(key: key);
  // ScreenQLChiDinhChiDinh({
  //   Key key,
  // }) : super(key: key);

  @override
  ScreenQLChiDinhChiDinhState createState() => ScreenQLChiDinhChiDinhState();
}

class ScreenQLChiDinhChiDinhState extends State<ScreenQLChiDinhChiDinh> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var formatter = new DateFormat(DATE_FORMAT);
  int page = 0, pageSize = 18, totalPages = 10;
  AppUtil appUtil = new AppUtil();

  List<IndicationData> items = [];
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
        List<FilteredInput> arrFilterinput = [];
        List<SortedInput> arrSortedinput = [];
        arrFilterinput
            .add(FilteredInput("state", "['pending','confirm']", "in"));
        arrFilterinput.add(
            FilteredInput("appointment.sessionCode", widget.keySearch, ""));
//        arrFilterinput.add(FilteredInput("state", "PENDING,CONFIRM", "in"));
        arrSortedinput.add(SortedInput("createdTime", true));
        ApiGraphQLControllerQuery apiController =
            new ApiGraphQLControllerQuery();

        QueryResult result = await apiController.requestGetIndications(
            context, page, arrFilterinput, arrSortedinput);
        String response = result.data.toString();
        AppUtil.showPrint("Response requestGetIndications: " + response);
        if (response != null) {
          var responseData = appUtil.processResponseWithPage(result);
          int code = responseData.code;
          String message = responseData.message;

          if (code == 0) {
            String jsonData = json.encode(responseData.data);
            AppUtil.showLogFull("### jsonData: " + jsonData);
            if (jsonData == null || jsonData.length == 0) {
              totalPages = 0;
            } else {
              AppUtil.showPrint("### pages: " + responseData.pages.toString());
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
          AppUtil.showPopup(context, "Thông báo",
              "Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại");
        }
      } on Exception catch (e) {
        AppUtil.showPrint('requestGetNewsArticles Error: ' + e.toString());
      }

      if (items.isEmpty) {
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
        key: _scaffoldKey,
//        appBar: appUtil.getAppBar(new Text("Tin tức")),
        backgroundColor: Colors.white,
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
                  IndicationData itemData = items[index];
                  if (itemData != null) {
                    return new GestureDetector(
                        onTap: () async {
//                          DialogUtil.showDialogWithTitle(_scaffoldKey, context, titleSuccess: "Nội dung khám", messageSuccess: itemData.reason, okBtnFunction: null);
//                    Navigator.push(context, MaterialPageRoute(builder: (_) {
//                      return ScreenPatientDetail(itemID: itemData.id,);
//                    }));
                        },
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: new BoxDecoration(
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
                                                child: itemData.patient
                                                                .avatar !=
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
                                                        matchTextDirection:
                                                            true,
                                                        fit: BoxFit.cover,
                                                        width: 50.0,
                                                        height: 50.0,
                                                      )
                                                    : Image.asset(
                                                        'assets/defaultimage.png',
                                                        matchTextDirection:
                                                            true,
                                                        fit: BoxFit.cover,
                                                        width: 50.0,
                                                        height: 50.0,
                                                      ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 12,
                                            ),
                                          ],
                                        )
                                      : SizedBox(),
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
                                                            : SizedBox(
                                                                height: 1,
                                                              ),
                                                      ),
                                                      SizedBox(
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
                                                            SizedBox(
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
                                                                : Text(
                                                                    "Chưa có mã KCB",
                                                                    style: Constants
                                                                        .styleTextSmallRedColor)
                                                            // itemData.patientCode != null ? Text(itemData.patientCode, style: Constants.styleTextSmallBlueColor) : SizedBox()
                                                          ],
                                                        ),
                                                        onTap: () {},
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
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
                                                                      Image
                                                                          .asset(
                                                                        "assets/phone_16.png",
                                                                        width:
                                                                            16,
                                                                        height:
                                                                            16,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Expanded(
                                                                        child: Text(
                                                                            itemData
                                                                                .patient.phoneNumber,
                                                                            style:
                                                                                Constants.styleTextNormalSubColor),
                                                                      ),
                                                                    ],
                                                                  )
                                                                : SizedBox(
                                                                    height: 0,
                                                                  ),
                                                            SizedBox(
                                                              height: 6,
                                                            ),
                                                            (itemData.patient
                                                                        ?.birthDay !=
                                                                    null)
                                                                ? Row(
                                                                    children: [
                                                                      Image
                                                                          .asset(
                                                                        "assets/icon_select_date.png",
                                                                        width:
                                                                            16,
                                                                        height:
                                                                            16,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Expanded(
                                                                        child: Text(
                                                                            "NS: " +
                                                                                DateFormat(Constants.FORMAT_DATEONLY).format(itemData.patient.birthDay),
                                                                            style: Constants.styleTextNormalSubColor),
                                                                      ),
                                                                    ],
                                                                  )
                                                                : SizedBox(
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
                                                                  builder: (_) {
                                                            return ScreenPatientDetail(
                                                              patientCode: itemData
                                                                  .patient
                                                                  .patientCode,
                                                            );
                                                          }));
                                                        },
                                                        child: Padding(
                                                          padding: EdgeInsets
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
                                            : SizedBox(),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        (itemData.createdTime != null)
                                            ? Row(
                                                children: [
                                                  Image.asset(
                                                    "assets/ic_clock.png",
                                                    width: 16,
                                                    height: 16,
                                                  ),
                                                  SizedBox(
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
                                            : SizedBox(),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        (itemData.doctor != null)
                                            ? Row(
                                                children: [
                                                  Image.asset(
                                                    "assets/ic_doctor.png",
                                                    width: 16,
                                                    height: 16,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                        itemData
                                                            .doctor.fullName,
                                                        style: Constants
                                                            .styleTextNormalSubColor),
                                                  ),
                                                ],
                                              )
                                            : SizedBox(),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        (itemData.service != null)
                                            ? Column(
                                                children: <Widget>[
                                                  CustomPaint(
                                                      size: Size(8, 8),
                                                      painter:
                                                          DrawTriangleShape()),
                                                  Container(
                                                    width: double.infinity,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 15,
                                                            horizontal: 15),
                                                    child: Column(
                                                      children: <Widget>[
                                                        Text(
                                                          "Nội dung chỉ định: " +
                                                              itemData
                                                                  .service.name,
                                                          style: Constants
                                                              .styleTextNormalBlueColor,
                                                        ),
                                                        SizedBox(
                                                          height: 3,
                                                        ),
                                                        itemData.note != null &&
                                                                itemData.note
                                                                    .isNotEmpty
                                                            ? Text(
                                                                "Ghi chú: " +
                                                                    itemData
                                                                        .note,
                                                                style: Constants
                                                                    .styleTextNormalBlueColor,
                                                              )
                                                            : SizedBox()
                                                      ],
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: HexColor.fromHex(
                                                          Constants
                                                              .Color_divider),
                                                      /* borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(0),
                                                      bottomLeft:
                                                          Radius.circular(5),
                                                      topRight:
                                                          Radius.circular(5),
                                                      bottomRight:
                                                          Radius.circular(5),
                                                    )*/
                                                    ),
                                                  )
                                                ],
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                              )
                                            : SizedBox(),
                                        SizedBox(
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
                    AppUtil.showPrint("### appointmentData KHÔNG CÓ DỮ LIỆU ");
//              AppUtil.showPrint(appointmentData.fullName + "/" + appointmentData.phoneNumber);
                    return SizedBox(
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
}
