import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

import '../../controller/ApiGraphQLControllerMutation.dart';
import '../../controller/ApiGraphQLControllerQuery.dart';
import '../../extension/HexColor.dart';
import '../../model/GraphQLModels.dart';
import '../../model/MedicalSessionData.dart';
import '../../utils/AppStyle.dart';
import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';
import '../../utils/DefaultSmallRowButtonUI.dart';
import '../../utils/DialogUtil.dart';
import '../manage_indication/ScreenQLChiDinhListIndications.dart';
import '../patient/ScreenPatientDetail.dart';

class ScreenQLKhamBenhChoKham extends StatefulWidget {
  final String keySearch;

  const ScreenQLKhamBenhChoKham({Key key, this.keySearch}) : super(key: key);
/*  ScreenQLKhamBenhChoKham({
    Key key,
  }) : super(key: key);*/

  @override
  ScreenQLKhamBenhChoKhamState createState() => ScreenQLKhamBenhChoKhamState();
}

class ScreenQLKhamBenhChoKhamState extends State<ScreenQLKhamBenhChoKham> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var formatter = DateFormat(DATE_FORMAT);
  int page = 0, pageSize = 18, totalPages = 10;
  AppUtil appUtil = AppUtil();
  String keySearch = '';

  List<MedicalSessionData> items = [];
  final ScrollController _scrollController = ScrollController();
  bool isPerformingRequest = false;

  @override
  void initState() {
    super.initState();
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

  Future<void> reloadData() async {
    page = 0;
    pageSize = 18;
    totalPages = 10;
    items.clear();
    await getMoreData();
  }

  Future<void> getMoreData() async {
    AppUtil.showPrint('_getMoreData page: $page / total: $totalPages');
    if (!isPerformingRequest && page < totalPages) {
      setState(() => isPerformingRequest = true);
      try {
        final List<FilteredInput> arrFilterinput = [];
        arrFilterinput.add(FilteredInput('process', 'IN_QUEUE', ''));
        arrFilterinput.add(FilteredInput('textSearch', widget.keySearch, ''));
        final List<SortedInput> arrSortedinput = [];
        arrSortedinput.add(SortedInput('createdTime', true));
        final ApiGraphQLControllerQuery apiController =
            ApiGraphQLControllerQuery();

        final QueryResult result =
            await apiController.requestGetMedicalSessionsFollowingDoctor(
                context, page, arrFilterinput, arrSortedinput);
        final String response = result.data.toString();
        AppUtil.showPrint('Response requestGetMedicalSessions: $response');
        if (response != null) {
          final responseData = appUtil.processResponseWithPage(result);
          final int code = responseData.code;
          final String message = responseData.message;

          if (code == 0) {
            final String jsonData = json.encode(responseData.data);
            AppUtil.showPrint('### jsonData: $jsonData');
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
          await AppUtil.showPopup(context, 'Th??ng b??o',
              'Kh??ng th??? k???t n???i t???i m??y ch???. Vui l??ng ki???m tra k???t n???i v?? th??? l???i');
        }
      } on Exception catch (e) {
        AppUtil.showPrint('requestGetNewsArticles Error: $e');
      }

      if (items.isEmpty) {
        final double edge = 50;
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
//        appBar: appUtil.getAppBar(new Text("Tin t???c")),
      backgroundColor: Constants.background,
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
                  return Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
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
                                                          itemData
                                                              .patient.fullName,
                                                          style: Constants
                                                              .styleTextNormalBlueColorBold)
                                                      : const SizedBox(
                                                          height: 1,
                                                        ),
                                                ),
                                                const SizedBox(
                                                  width: 12,
                                                ),
                                                Row(
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
                                                        ? Text(itemData.code,
                                                            style: Constants
                                                                .styleTextSmallBlueColor)
                                                        : const Text(
                                                            'Ch??a c?? m?? KCB',
                                                            style: Constants
                                                                .styleTextSmallRedColor)
                                                    // itemData.patientCode != null ? Text(itemData.patientCode, style: Constants.styleTextSmallBlueColor) : SizedBox()
                                                  ],
                                                ),
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
                                                                      'NS: ${DateFormat(Constants.FORMAT_DATEONLY).format(itemData.patient.birthDay)}',
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
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                ScreenPatientDetail(
                                                                  patientCode:
                                                                      itemData
                                                                          .patient
                                                                          .patientCode,
                                                                )));
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
                                                      .format(
                                                          itemData.createdTime),
                                                  style: Constants
                                                      .styleTextNormalSubColor),
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                  itemData.reason != null &&
                                          itemData.reason.isNotEmpty
                                      ? Column(
                                          children: <Widget>[
                                            const SizedBox(
                                              height: 6,
                                            ),
                                            Container(
                                              width: double.infinity,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 15,
                                                      horizontal: 15),
                                              decoration: BoxDecoration(
                                                  color: HexColor.fromHex(
                                                      Constants.Color_divider),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(5))),
                                              child: Text(
                                                'L?? do kh??m: ${itemData.reason}',
                                                style: Constants
                                                    .styleTextNormalBlueColor,
                                              ),
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                  Row(
                                    children: [
                                      DefaultSmallRowButtonUI(
                                          clickButton: () => {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ScreenQLChiDinhListIndications(
                                                              medicalSessionData:
                                                                  itemData)),
                                                )
                                              },
                                          color: Constants.Color_primary,
                                          name: 'Ch??? ?????nh kh??m'),
                                      DefaultSmallRowButtonUI(
                                          clickButton: () =>
                                              {onClickXacNhanKham(itemData)},
                                          color: Constants.Color_green,
                                          name: 'X??c nh???n kh??m')
                                    ],
                                  )
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

  Future<void> onClickXacNhanKham(MedicalSessionData itemData) async {
    await DialogUtil.showDialogConfirmYesNo(_scaffoldKey, context,
        title: 'X??C NH???N KH??M',
        message:
            'BN: ${itemData.patient.fullName}\nPhi???u kh??m: ${itemData.code}',
        nameButton: '?????ng ??', okBtnFunction: () async {
      await requestXacNhanKham(itemData);
    });
  }

  Future<void> requestXacNhanKham(MedicalSessionData itemData) async {
    final ApiGraphQLControllerMutation apiController =
        ApiGraphQLControllerMutation();

    final QueryResult result =
        await apiController.updateMedicalSessionWaiting(context, itemData.code);

    final String response = result.data.toString();
    AppUtil.showPrint('Response requestGetIndications: $response');
    if (response != null) {
      final responseData = appUtil.processResponseWithPage(result);
      final int code = responseData.code;
      final String message = responseData.message;
      if (code == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('X??c nh???n kh??m th??nh c??ng!'),
            duration: const Duration(seconds: 3),
            backgroundColor: HexColor.fromHex(Constants.Color_primary),
          ),
        );
        await getMoreData();
      } else {
        appUtil.showToastWithScaffoldState(_scaffoldKey, message);
      }
    } else {
      await AppUtil.showPopup(context, 'Th??ng b??o',
          'Kh??ng th??? k???t n???i t???i m??y ch???. Vui l??ng ki???m tra k???t n???i v?? th??? l???i');
    }
  }
}
