import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

import '../../controller/ApiGraphQLControllerQuery.dart';
import '../../extension/HexColor.dart';
import '../../model/BottomSheetMenuData.dart';
import '../../model/GraphQLModels.dart';
import '../../model/PatientData.dart';
import '../../model/UserActionData.dart';
import '../../utils/AppStyle.dart';
import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';
import 'ScreenAddPatient.dart';

// ignore: must_be_immutable
class ScreenPatientDetail extends StatefulWidget {
  String patientCode = '';

  ScreenPatientDetail({Key key, @required this.patientCode}) : super(key: key);

  @override
  _ScreenPatientDetailState createState() => _ScreenPatientDetailState();
}

class _ScreenPatientDetailState extends State<ScreenPatientDetail> {
  var formatter = DateFormat(DATE_FORMAT);
  int page = 0, pageSize = 18, totalPages = 10;
  AppUtil appUtil = AppUtil();

  List<ShortUserActionData> items = [];
  ScrollController _scrollController = ScrollController();
  bool isPerformingRequest = false;

  // ignore: avoid_init_to_null
  PatientData patientData = null;

  @override
  void initState() {
    super.initState();

    if (widget.patientCode == null || widget.patientCode.isEmpty) {
//      AppUtil.showPopup(context, "Thông báo", "Không thể lấy thông tin bệnh nhân này.");
    } else {
      loadPatientDetail(context);
    }

//    _getMoreData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  loadPatientDetail(BuildContext context) async {
    try {
      AppUtil.showLoadingDialog(context);
      final ApiGraphQLControllerQuery apiController =
          ApiGraphQLControllerQuery();

      final QueryResult result = await apiController.requestGetDetailPatient(
          context, widget.patientCode);
      final String response = result.data.toString();
      AppUtil.showPrint('Response requestGetDetailPatient: $response');
      AppUtil.hideLoadingDialog(context);
      if (response != null) {
        final responseData = appUtil.processResponse(result);
        final int code = responseData.code;
        final String message = responseData.message;

        if (code == 0 && responseData.data != null) {
          final String jsonData = json.encode(responseData.data);
          log('### jsonData: $jsonData');
          setState(() {
            patientData = PatientData.fromJsonMap(jsonDecode(jsonData));
            AppUtil.showPrint(
                '### requestGetDetailPatient: ${jsonEncode(patientData.toString())}');
          });

          _getMoreData();
        } else {
          AppUtil.showPopup(context, 'Thông báo', message);
        }
      } else {
        AppUtil.showPopup(context, 'Thông báo',
            'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại');
      }
      AppUtil.hideLoadingDialog(context);
    } on Exception catch (e) {
      AppUtil.hideLoadingDialog(context);
      AppUtil.showPrint('requestGetNewsArticles Error: $e');
    }
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
    if (patientData != null && !isPerformingRequest && page < totalPages) {
      setState(() => isPerformingRequest = true);
//      try {
      final List<FilteredInput> arrFilterinput = [];
      final List<SortedInput> arrSortedinput = [];
      arrFilterinput.add(FilteredInput(
          'Data.InputPatient.PhoneNumber', "'${patientData.phoneNumber}'", ''));
//      arrFilterinput.add(FilteredInput("Data.PatientCode", patientData.patientCode, ""));
//        arrFilterinput.add(FilteredInput("patientCode", patientData.patientCode, ""));
      arrSortedinput.add(SortedInput('createdTime', true));
      final ApiGraphQLControllerQuery apiController =
          ApiGraphQLControllerQuery();

      final QueryResult result = await apiController.requestGetUserActions(
          context, page, arrFilterinput, arrSortedinput);
      final String response = result.data.toString();
      AppUtil.showLogFull('Response requestGetUserActions: $response');
      if (response != null) {
        final responseData = appUtil.processResponseWithPage(result);
        final int code = responseData.code;
        final String message = responseData.message;

        if (code == 0) {
          final String jsonData = json.encode(responseData.data);
          AppUtil.showPrint('### jsonData: $jsonData');
          if (jsonData == null || jsonData.length == 0) {
            totalPages = 0;
          } else {
            AppUtil.showPrint('### pages: ${responseData.pages}');
            totalPages = responseData.pages;
          }
          final tmpItems = List<ShortUserActionData>.from(responseData.data
              .map((item) => ShortUserActionData.fromJsonMap(item)));
          items.addAll(tmpItems);
        } else {
          AppUtil.showPopup(context, 'Thông báo', message);
        }
      } else {
        AppUtil.showPopup(context, 'Thông báo',
            'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại');
      }
//      } on Exception catch (e) {
//        AppUtil.showPrint('requestGetUserActions Error: ' + e.toString());
//      }

      if (items.isEmpty) {
        final double edge = 50;
        final double offsetFromBottom =
            _scrollController.position.maxScrollExtent -
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
        resizeToAvoidBottomInset: false,
        appBar: AppUtil.customAppBar(context, 'CHI TIẾT BỆNH NHÂN'),
        backgroundColor: Colors.white,
        body:
//        Container(
//          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
////            child: SingleChildScrollView(
//          child:
            widget.patientCode == null || widget.patientCode.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Không có dữ liệu bệnh nhân này.',
                        textAlign: TextAlign.center,
                        style: Constants.styleTextNormalSubColor,
                      ),
                    ),
                  )
                : Stack(
                    children: <Widget>[
                      RefreshIndicator(
                        onRefresh: reloadData,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: items == null ? 2 : items.length + 2,
//              itemCount: items == null ? 1 : items.length + 2,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              // return the header
                              return Column(
                                children: <Widget>[
                                  patientData != null
                                      ? Column(
                                          children: <Widget>[
                                            Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      15, 0, 15, 0),
                                              height: 33,
                                              color: HexColor.fromHex(
                                                  Constants.Color_divider),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: <Widget>[
//                        SizedBox(width: 12,),

                                                  const Expanded(
                                                    child: Text(
                                                      'THÔNG TIN',
                                                      style: Constants
                                                          .styleTextNormalSubColor,
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    child: Center(
                                                      child: Row(
                                                        children: <Widget>[
                                                          const Text(
                                                            'Chi tiết',
                                                            style: Constants
                                                                .styleTextSmallSubColor,
                                                            textAlign:
                                                                TextAlign.right,
                                                          ),
                                                          const SizedBox(
                                                            width: 3,
                                                          ),
                                                          Image.asset(
                                                            'assets/icon_next_function.png',
                                                            width: 30,
                                                            height: 22,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    onTap: () async {
                                                      if (patientData == null) {
                                                        appUtil.showToast(
                                                            context,
                                                            'Không thể lấy chi tiết thông tin người bệnh này');
                                                      } else {
                                                        final String result =
                                                            await Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (_) => ScreenAddPatient(
                                                                          userInfoData:
                                                                              patientData,
                                                                        )));
                                                        if (result != null &&
                                                            result ==
                                                                Constants
                                                                    .SignalSuccess) {
                                                          loadPatientDetail(
                                                              context);
                                                        }
                                                      }
                                                    },
                                                  ),
//                        SizedBox(width: 12,),
                                                ],
                                              ),
                                            ),
                                            Row(
//                  crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                const SizedBox(
                                                  width: 12,
                                                ),
                                                CircleAvatar(
                                                  radius: 40,
                                                  backgroundColor: Colors.white,
//                              backgroundColor: HexColor.fromHex(Constants.Color_primary),
                                                  child: ClipOval(
                                                    child: patientData.avatar !=
                                                                null &&
                                                            !appUtil
                                                                .checkValidLocalPath(
                                                                    patientData
                                                                        .avatar)
                                                        ? FadeInImage
                                                            .assetNetwork(
                                                            placeholder:
                                                                'assets/defaultimage.png',
                                                            image: patientData
                                                                .avatar,
                                                            matchTextDirection:
                                                                true,
                                                            fit: BoxFit.cover,
                                                            width: 80,
                                                            height: 80,
                                                          )
                                                        : Image.asset(
                                                            'assets/defaultimage.png',
                                                            matchTextDirection:
                                                                true,
                                                            fit: BoxFit.cover,
                                                            width: 80,
                                                            height: 80,
                                                          ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 12,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      const SizedBox(
                                                        width: 12,
                                                      ),
                                                      (patientData.fullName !=
                                                              null)
                                                          ? Text(
                                                              patientData
                                                                  .fullName,
                                                              style: Constants
                                                                  .styleTextNormalBlueColorBold)
                                                          : const SizedBox(
                                                              height: 1,
                                                            ),
                                                      const SizedBox(
                                                        height: 6,
                                                      ),
                                                      (patientData.patientCode !=
                                                              null)
                                                          ? Row(
                                                              children: [
                                                                Image.asset(
                                                                  'assets/qrcode_16.png',
                                                                  width: 16,
                                                                  height: 16,
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                      patientData
                                                                          .patientCode,
                                                                      style: Constants
                                                                          .styleTextNormalBlueColor),
                                                                ),
                                                              ],
                                                            )
                                                          : const SizedBox(
                                                              height: 0,
                                                            ),
                                                      const SizedBox(
                                                        height: 6,
                                                      ),
                                                      (patientData.phoneNumber !=
                                                              null)
                                                          ? Row(
                                                              children: [
                                                                Image.asset(
                                                                  'assets/phone_16.png',
                                                                  width: 16,
                                                                  height: 16,
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                      patientData
                                                                          .phoneNumber,
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
                                                      (patientData.birthDay !=
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
                                                                      DateFormat(Constants
                                                                              .FORMAT_DATEONLY)
                                                                          .format(patientData
                                                                              .birthDay),
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
                                                      (patientData.address !=
                                                              null)
                                                          ? Row(
                                                              children: [
                                                                Image.asset(
                                                                  'assets/location_16.png',
                                                                  width: 16,
                                                                  height: 16,
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                      patientData
                                                                          .address,
                                                                      style: Constants
                                                                          .styleTextNormalSubColor),
                                                                ),
                                                              ],
                                                            )
                                                          : const SizedBox(
                                                              height: 1,
                                                            ),
                                                      const SizedBox(
                                                        height: 6,
                                                      ),
                                                      (patientData.gender !=
                                                              null)
                                                          ? Row(
                                                              children: [
                                                                Image.asset(
                                                                  'assets/gender_16.png',
                                                                  width: 16,
                                                                  height: 16,
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                      patientData.gender != null &&
                                                                              patientData.gender ==
                                                                                  '2'
                                                                          ? 'Nữ'
                                                                          : 'Nam',
                                                                      style: Constants
                                                                          .styleTextNormalSubColor),
                                                                ),
                                                              ],
                                                            )
                                                          : const SizedBox(
                                                              height: 1,
                                                            ),
                                                      const SizedBox(
                                                        height: 6,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 12,
                                                ),
                                              ],
                                            )
                                          ],
                                        )
                                      : const SizedBox(),
                                  Container(
                                    width: double.infinity,
                                    alignment: Alignment.centerLeft,
                                    padding:
                                        const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                    height: 33,
                                    color: HexColor.fromHex(
                                        Constants.Color_divider),
                                    child: const Text(
                                      'LỊCH SỬ',
                                      style: Constants.styleTextNormalSubColor,
                                    ),
                                  ),
                                ],
                              );
                            }
                            index -= 1;

                            if (index == items.length) {
                              return _buildProgressIndicator();
                            } else {
                              AppUtil.showLog(
                                  'items size: ${items.length}, index: $index');
                              final ShortUserActionData itemData = items[index];
                              if (itemData != null) {
                                return GestureDetector(
                                    onTap: () async {
                                      /*   Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return ScreenWebViewNewsDetail(newsID: itemData.id, title: itemData.title,);
                    }));*/
                                    },
                                    child: Container(
                                        margin: const EdgeInsets.all(10),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                itemData.createdTime != null
                                                    ? Container(
                                                        height: 55,
                                                        width: 55,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        22.5),
                                                            color: HexColor
                                                                .fromHex(Constants
                                                                    .Color_divider)),
                                                        child: Center(
                                                          child: Text(DateFormat(
                                                                  Constants
                                                                      .FORMAT_TIMEONLY)
                                                              .format(itemData
                                                                  .createdTime)),
                                                        ),
                                                      )
                                                    : const SizedBox(
                                                        width: 0,
                                                      ),
                                                const SizedBox(
                                                  width: 12,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      itemData.createdTime !=
                                                              null
                                                          ? Text(
                                                              DateFormat(Constants
                                                                      .FORMAT_DATEONLY)
                                                                  .format(itemData
                                                                      .createdTime),
                                                              style: Constants
                                                                  .styleTextSmallBlueColor,
                                                            )
                                                          : const SizedBox(),
                                                      itemData.name != null
                                                          ? Column(
                                                              children: <
                                                                  Widget>[
                                                                const SizedBox(
                                                                  height: 6,
                                                                ),
                                                                Text(
                                                                  itemData.name,
                                                                  style: TextStyle(
                                                                      color: HexColor.fromHex(
                                                                          Constants
                                                                              .Color_subtext),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize:
                                                                          Constants
                                                                              .Size_text_normal),
                                                                ),
                                                              ],
                                                            )
                                                          : const SizedBox()
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Divider(
                                              thickness: 1,
                                              indent: 70,
                                              color: HexColor.fromHex(
                                                  Constants.Color_divider),
                                            )
                                          ],
                                        ))
//                              )
                                    );
                              } else {
                                AppUtil.showPrint(
                                    '### appointmentData KHÔNG CÓ DỮ LIỆU ');
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
//              ),
                      /*  Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 25),
                  height: 50,
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
                    color: HexColor.fromHex(Constants.Color_primary),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 40,
                        ),
                        Expanded(
                          child: Text(
                            "CHỈ ĐỊNH",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
//                        SizedBox(width: 15,),
                        Image.asset(
                          "assets/chidinh_32.png",
                          width: 20,
                          height: 20,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  List<BottomSheetMenuData> menuItems = [];
                  menuItems.add(new BottomSheetMenuData("", "Check in", "assets/cd_checkin_32.png", 0));
                  menuItems.add(new BottomSheetMenuData("", "Khám bệnh", "assets/cd_khambenh_32.png", 1));
                  menuItems.add(new BottomSheetMenuData("", "Chỉ định thủ thuật", "assets/cd_thuthuat_32.png", 2));
                  menuItems.add(new BottomSheetMenuData("", "Đặt tái khám", "assets/cd_dattaikham_32.png", 3));
                  menuItems.add(new BottomSheetMenuData("", "Đơn thuốc", "assets/cd_donthuoc_32.png", 4));
                  menuItems.add(new BottomSheetMenuData("", "Kết quả khám", "assets/cd_ketquakham_32.png", 5));
                  showBottomMenu(menuItems);
                },
              )),*/
                    ],
                  ),
//        )
      );

  String parseProcessMedicalSession(String processENUM) {
    String strOut = '';
    switch (processENUM.toUpperCase()) {
      case 'IN_QUEUE':
        strOut = 'Đang chờ khám';
        break;
      case 'WATING_CONCLUSION':
        strOut = 'Đang chỉ định';
        break;
      case 'CONCLUSION':
        strOut = 'Đã khám';
        break;
      case 'CANCEL':
        strOut = 'Hủy';
        break;
    }
    return strOut;
  }

  // ignore: avoid_init_to_null, unused_field
  BottomSheetMenuData _selectedItem = null;
  showBottomMenu(List<BottomSheetMenuData> menuItems) async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => Container(
              color: const Color(0xFF737373),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
//              child: _buildBottomNavigationMenu(menuItems),
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(
                      height: 14,
                    ),
                    Text(
                      'CHỈ ĐỊNH',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          color: HexColor.fromHex(Constants.Color_bluetext)),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Divider(
                      color: HexColor.fromHex(Constants.Color_divider),
                      indent: 70,
                      height: 1,
                    ),
//        for (var i = 0; i < menuItems.length; ++i)
                    for (var menuItem in menuItems)
                      Column(
                        children: <Widget>[
                          /*   ListTile(
                          leading: Image.asset(menuItem.image),
                          title: Text(menuItem.title),
                          onTap: () => _selectItem(menuItem),
                        ),*/
                          const SizedBox(
                            height: 14,
                          ),
                          Row(
                            children: <Widget>[
                              const SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                width: 20,
                                child: Image.asset(
                                  menuItem.image,
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                menuItem.title,
                                style: Constants.styleTextNormalBlueColor,
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          Divider(
                            color: HexColor.fromHex(Constants.Color_divider),
                            indent: 70,
                            height: 1,
                          ),
                        ],
                      )
                  ],
                ),
              ),
            ));
  }
//  Column _buildBottomNavigationMenu(List<BottomSheetMenuData> menuItems) {
//    return Column(
//      mainAxisSize: MainAxisSize.min,
//      children: <Widget>[
//        SizedBox(height: 15,),
//        Text(
//          "CHỈ ĐỊNH", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: HexColor.fromHex(Constants.Color_bluetext)),
//        ),
//        SizedBox(height: 15,),
//        Divider(color: HexColor.fromHex(Constants.Color_divider), indent: 70, height: 1,),
////        for (var i = 0; i < menuItems.length; ++i)
//          for (var menuItem in menuItems)
//          Column(
//            children: <Widget>[
//              ListTile(
//                leading: Image.asset(menuItem.image),
//                title: Text(menuItem.title),
//                onTap: () => _selectItem(menuItem),
//              ),
//              Divider(color: HexColor.fromHex(Constants.Color_divider), indent: 70, height: 1,),
//            ],
//          )
////        var menuItem = menuItems[i];
//
//
//   /*     ListTile(
//          leading: Icon(Icons.ac_unit),
//          title: Text('Cooling'),
//          onTap: () => _selectItem('Cooling'),
//        ),
//        ListTile(
//          leading: Icon(Icons.accessibility_new),
//          title: Text('People'),
//          onTap: () => _selectItem('People'),
//        ),
//        ListTile(
//          leading: Icon(Icons.assessment),
//          title: Text('Stats'),
//          onTap: () => _selectItem('Stats'),
//        ),*/
//      ],
//    );
//  }

  // ignore: unused_element
  void _selectItem(BottomSheetMenuData menuItem) {
    Navigator.pop(context);
    setState(() {
      _selectedItem = menuItem;
    });
  }
}
