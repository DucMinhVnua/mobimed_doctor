import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

import '../../controller/ApiGraphQLControllerQuery.dart';
import '../../extension/HexColor.dart';
import '../../model/GraphQLModels.dart';
import '../../model/PrescriptionData.dart';
import '../../utils/AppStyle.dart';
import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';
import '../patient/ScreenPatientDetail.dart';
import 'ScreenDonThuocChiTiet.dart';

// ignore: must_be_immutable
class ScreenQLDonThuoc extends StatefulWidget {
  String sessionCode = '';

  ScreenQLDonThuoc({Key key, this.sessionCode}) : super(key: key);

  @override
  _ScreenQLDonThuocState createState() => _ScreenQLDonThuocState();
}

class _ScreenQLDonThuocState extends State<ScreenQLDonThuoc> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var formatter = DateFormat(DATE_FORMAT);
  int page = 0, pageSize = 18, totalPages = 10;
  AppUtil appUtil = AppUtil();

  List<PrescriptionData> items = [];
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
      List<FilteredInput> arrFilterinput = [];
      List<SortedInput> arrSortedinput = [];
      arrFilterinput.add(FilteredInput('textSearch', keySearch, ''));
      arrSortedinput.add(SortedInput('createdTime', true));
      ApiGraphQLControllerQuery apiController = ApiGraphQLControllerQuery();

      QueryResult result = await apiController.requestGetPrescriptions(
          context, page, arrFilterinput, arrSortedinput);
      String response = result.data.toString();
      AppUtil.showPrint('Response requestGetPrescriptions: ' + response);
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
          var tmpItems = List<PrescriptionData>.from(responseData.data
              .map((item) => PrescriptionData.fromJsonMap(item)));
          items.addAll(tmpItems);
        } else {
          totalPages = 0;
          appUtil.showToastWithScaffoldState(_scaffoldKey, message);
        }
      } else {
        await AppUtil.showPopup(context, 'Thông báo',
            'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại');
      }
//      } on Exception catch (e) {
//        AppUtil.showPrint('requestGetMedicalSessions Error: ' + e.toString());
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
      appBar: AppUtil.customAppBar(context, 'QL ĐƠN THUỐC'),
      backgroundColor: Constants.background,
      body: RefreshIndicator(
        onRefresh: reloadData,
        child: ListView.builder(
          shrinkWrap: true,
          // itemCount: items.length + 1,
          itemCount: items == null ? 2 : items.length + 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              // return the header
              return Column(
                children: <Widget>[
                  AppUtil.searchWidget(
                      'Tìm kiếm', _onChangeHandler, editingController),
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
              PrescriptionData itemData = items[index];
              if (itemData != null) {
                return GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ScreenDonThuocChiTiet(
                                    prescriptionData: itemData,
                                  )));
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
                                                            itemData
                                                                .patient.avatar)
                                                ? FadeInImage.assetNetwork(
                                                    placeholder:
                                                        'assets/defaultimage.png',
                                                    image:
                                                        itemData.patient.avatar,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                                    height: 16,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Expanded(
                                                                    child: Text(
                                                                        itemData
                                                                            .patient
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
                                                        (itemData.patient
                                                                    ?.birthDay !=
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
                                                                        'NS: ' +
                                                                            DateFormat(Constants.FORMAT_DATEONLY).format(itemData
                                                                                .patient.birthDay),
                                                                        style: Constants
                                                                            .styleTextNormalSubColor),
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
                                                      Navigator.push(context,
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
                                                      padding: const EdgeInsets
                                                          .fromLTRB(8, 8, 0, 8),
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
                                                'assets/ic_doctor.png',
                                                width: 16,
                                                height: 16,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                    itemData.creator.fullName,
                                                    style: Constants
                                                        .styleTextNormalSubColor),
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
                                                child: Row(
                                                  children: <Widget>[
                                                    Text(
                                                        'Giờ lấy đơn: ' +
                                                            DateFormat(Constants
                                                                    .FORMAT_DATEONLY)
                                                                .format(itemData
                                                                    .createdTime) +
                                                            '  ',
                                                        style: Constants
                                                            .styleTextNormalSubColor),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color:
                                                              HexColor.fromHex(
                                                                  '#F84366'),
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 6,
                                                          vertical: 2),
                                                      child: Text(
                                                          DateFormat(Constants
                                                                  .FORMAT_TIMEONLY)
                                                              .format(itemData
                                                                  .createdTime),
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: Constants
                                                                  .Size_text_normal)),
                                                    )
                                                  ],
                                                ),
                                                /*             Text("Giờ lấy đơn " +
                                                DateFormat(Constants
                                                    .FORMAT_DATETIME)
                                                    .format(itemData
                                                    .createdTime),
                                                style: Constants
                                                    .styleTextNormalSubColor),*/
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
      ));

  TextEditingController editingController = TextEditingController();
  String keySearch = '';
  Timer searchOnStoppedTyping;
  _onChangeHandler(value) {
    setState(() {
      keySearch = value;
    });

    const duration = Duration(
        milliseconds:
            1000); // set the duration that you want call search() after that.
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping.cancel()); // clear timer
    }
    setState(
        () => searchOnStoppedTyping = Timer(duration, () => search(value)));
  }

  search(value) async {
    AppUtil.showPrint('Search key: $value');

    page = 0;
    pageSize = 18;
    totalPages = 10;
    items.clear();

    _getMoreData();
  }
}
