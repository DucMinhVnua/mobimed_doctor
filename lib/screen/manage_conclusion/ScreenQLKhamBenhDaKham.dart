import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

import '../../controller/ApiGraphQLControllerQuery.dart';
import '../../custom/DrawTriangleShape.dart';
import '../../extension/HexColor.dart';
import '../../model/GraphQLModels.dart';
import '../../model/MedicalSessionData.dart';
import '../../model/PrescriptionData.dart';
import '../../utils/AppStyle.dart';
import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';
import '../../utils/DefaultSmallRowButtonUI.dart';
import '../manage_indication/ScreenQLChiDinhListIndications.dart';
import '../manage_prescription/ScreenDonThuocChiTiet.dart';
import '../patient/ScreenPatientDetail.dart';
import 'ScreenQLKhamBenhListConclusion.dart';

class ScreenQLKhamBenhDaKham extends StatefulWidget {
  final String keySearch;

  const ScreenQLKhamBenhDaKham({Key key, this.keySearch}) : super(key: key);

  @override
  ScreenQLKhamBenhDaKhamState createState() => ScreenQLKhamBenhDaKhamState();
}

class ScreenQLKhamBenhDaKhamState extends State<ScreenQLKhamBenhDaKham> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateFormat formatter = DateFormat(DATE_FORMAT);
  int page = 0, pageSize = 18, totalPages = 10;
  AppUtil appUtil = AppUtil();

  List<MedicalSessionData> items = [];
  final ScrollController _scrollController = ScrollController();
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

  Future<void> _getMoreData() async {
    AppUtil.showPrint('_getMoreData page: $page / total: $totalPages');
    if (!isPerformingRequest && page < totalPages) {
      setState(() => isPerformingRequest = true);
      try {
        final List<FilteredInput> arrFilterinput = [];
        final FilteredInput filteredInput0 =
            FilteredInput('process', 'CONCLUSION', '');
        final FilteredInput filteredInput1 =
            FilteredInput('textSearch', widget.keySearch, '');
        arrFilterinput
          ..add(filteredInput0)
          ..add(filteredInput1);

        final List<SortedInput> arrSortedinput = [];
        final SortedInput sortedInput = SortedInput('createdTime', true);
        arrSortedinput.add(sortedInput);
        final ApiGraphQLControllerQuery apiController =
            ApiGraphQLControllerQuery();

        final QueryResult result =
            await apiController.requestGetMedicalSessionsFollowingDoctor(
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
            if (jsonData == null || jsonData.isEmpty) {
              totalPages = 0;
            } else {
              AppUtil.showPrint('### pages: ${responseData.pages}');
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
          await AppUtil.showPopup(context, 'Thông báo',
              'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại');
        }
      } on Exception catch (e) {
        AppUtil.showPrint('requestGetNewsArticles Error: $e');
      }

      if (items.isEmpty) {
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
                                                          itemData.code != null
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
                                                          const SizedBox(
                                                            height: 6,
                                                          ),
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
                                      (itemData.creator != null)
                                          ? Row(
                                              children: [
                                                Image.asset(
                                                  'assets/btmn_canhan_gray.png',
                                                  width: 16,
                                                  height: 16,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                      'Người tạo: ${itemData.creator.fullName}',
                                                      style: Constants
                                                          .styleTextNormalSubColor),
                                                ),
                                              ],
                                            )
                                          : const SizedBox(),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          DefaultSmallRowButtonUI(
                                              clickButton: () => {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ScreenQLChiDinhListIndications(
                                                                    medicalSessionData:
                                                                        itemData)))
                                                  },
                                              color: Constants.Color_primary,
                                              name: 'KQ Chỉ định'),
                                          DefaultSmallRowButtonUI(
                                              clickButton: () => {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ScreenQLKhamBenhListConclusion(
                                                                    medicalSessionData:
                                                                        itemData)))
                                                  },
                                              color: Constants.Color_green,
                                              name: 'KQ Khám'),
                                          DefaultSmallRowButtonUI(
                                              clickButton: () => {
                                                    loadMedicalSessionDetail(
                                                        context, itemData.id)
                                                  },
                                              color: Constants.Color_primary,
                                              name: 'Đơn thuốc'),
                                        ],
                                      ),
                                      (itemData.indications != null &&
                                              itemData.indications.isNotEmpty)
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                CustomPaint(
                                                    size: const Size(8, 8),
                                                    painter:
                                                        DrawTriangleShape()),
                                                Container(
                                                  width: double.infinity,
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 8,
                                                      horizontal: 12),
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
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      for (var indication
                                                          in itemData
                                                              .indications)
                                                        Column(
                                                          children: <Widget>[
                                                            Row(
                                                              children: <
                                                                  Widget>[
                                                                indication.service !=
                                                                        null
                                                                    ? Expanded(
                                                                        child:
//                                                            Align(
////                                                              alignment: Alignment.centerRight,
//                                                              child:
                                                                            Text(
                                                                          indication
                                                                              .service
                                                                              .name,
                                                                          style:
                                                                              Constants.styleTextSmallMainColor,
                                                                        ),
//                                                            ),
                                                                      )
                                                                    : const SizedBox(),
                                                                const SizedBox(
                                                                  width: 15,
                                                                ),
                                                                indication.doctor !=
                                                                        null
                                                                    ? Text(
                                                                        indication
                                                                            .doctor
                                                                            .fullName,
                                                                        textAlign:
                                                                            TextAlign.right,
                                                                        style: Constants
                                                                            .styleTextSmallMainColor,
                                                                      )
                                                                    : const SizedBox(),
//        ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 4,
                                                            ),
                                                            /*  Divider(
                                                            height: 1,
                                                            color: HexColor.fromHex(Constants.Color_divider),
                                                          ),*/
                                                          ],
                                                        )
                                                    ],
                                                  ),
                                                )
                                              ],
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

  Future<void> loadMedicalSessionDetail(
      BuildContext context, String itemID) async {
    try {
      AppUtil.showLoadingDialog(context);
      final ApiGraphQLControllerQuery apiController =
          ApiGraphQLControllerQuery();

      final QueryResult result =
          await apiController.requestGetMedicalSession(context, itemID);
      final String response = result.data.toString();
      AppUtil.showPrint('Response requestGetMedicalSession: $response');
      await AppUtil.hideLoadingDialog(context);
      if (response != null) {
        final responseData = appUtil.processResponse(result);
        final int code = responseData.code;
        final String message = responseData.message;

        if (code == 0) {
          final String jsonData = json.encode(responseData.data);
          AppUtil.showPrint('### jsonData: $jsonData');
//          setState(() {
          final Map itemSession = jsonDecode(jsonData);

          if (itemSession.containsKey('prescriptions') &&
              itemSession['prescriptions'] != null) {
            final List<PrescriptionData> arrPrescription =
                List<PrescriptionData>.from(itemSession['prescriptions']
                    .map((item) => PrescriptionData.fromJsonMap(item)));
            if (arrPrescription != null &&
                arrPrescription.isNotEmpty &&
                arrPrescription[0] != null &&
                arrPrescription[0].drugs != null) {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ScreenDonThuocChiTiet(
                            prescriptionData: arrPrescription[0],
                          )));
            } else {
              appUtil.showToastWithScaffoldState(
                  _scaffoldKey, 'Chưa có thông tin đơn thuốc');
            }
          } else {
            appUtil.showToastWithScaffoldState(
                _scaffoldKey, 'Chưa có thông tin đơn thuốc');
          }
//          });
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
      AppUtil.showPrint('requestGetNewsArticles Error: $e');
    }
  }
}
