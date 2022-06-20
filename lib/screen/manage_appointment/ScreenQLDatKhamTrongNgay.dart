import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

import '../../controller/ApiGraphQLControllerMutation.dart';
import '../../controller/ApiGraphQLControllerQuery.dart';
import '../../extension/HexColor.dart';
import '../../model/AppointmentData.dart';
import '../../model/GraphQLModels.dart';
import '../../model/ResultCallBackData.dart';
import '../../utils/AppStyle.dart';
import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';
import '../../utils/DialogUtil.dart';
import '../patient/ScreenConfirmPatient.dart';
import '../patient/ScreenPatientDetail.dart';

class ScreenQLDatKhamTrongNgay extends StatefulWidget {
  final String keySearch;

  const ScreenQLDatKhamTrongNgay({Key key, this.keySearch}) : super(key: key);
/*  ScreenQLDatKhamTrongNgay({
    Key key,
  }) : super(key: key);*/

  @override
  ScreenQLDatKhamTrongNgayState createState() =>
      ScreenQLDatKhamTrongNgayState();
}

class ScreenQLDatKhamTrongNgayState extends State<ScreenQLDatKhamTrongNgay> {
//class _ScreenQLDKTrongNgayState extends State<ScreenQLDKTrongNgay>  with AutomaticKeepAliveClientMixin<ScreenQLDKTrongNgay>  {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var formatter = DateFormat(DATE_FORMAT);
  int page = 0, pageSize = 18, totalPages = 10;
  AppUtil appUtil = AppUtil();

  List<AppointmentData> items = [];
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

  Future<Null> reloadData() async {
    page = 0;
    pageSize = 18;
    totalPages = 10;
    items.clear();
    getMoreData();
  }

  getMoreData() async {
    AppUtil.showPrint(' getMoreData page: $page / total: $totalPages');
    if (!isPerformingRequest && page < totalPages) {
      setState(() => isPerformingRequest = true);
      try {
        final now = DateTime.now();
        final List<FilteredInput> arrFilterinput = [];
        arrFilterinput.add(FilteredInput(
            'inputPatient.fullName,inputPatient.address,inputPatient.phoneNumber',
            widget.keySearch,
            ''));
        arrFilterinput.add(FilteredInput(
            'appointmentDate', '${now.year}-${now.month}-${now.day}', '=='));
        arrFilterinput.add(FilteredInput('state', '[APPROVE,WAITING]', ''));

        final List<SortedInput> arrSortedinput = [];
        arrSortedinput.add(SortedInput('appointmentTime', false));
        final ApiGraphQLControllerQuery apiController =
            ApiGraphQLControllerQuery();

        final QueryResult result = await apiController.requestGetAppointments(
            context, page, arrFilterinput, arrSortedinput);
//        QueryResult result = await apiController.requestGetMedicalSessions(context, page, arrFilterinput, arrSortedinput);
        final String response = result.data.toString();
        AppUtil.showPrint('Response requestGetMedicalSessions: $response');
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
            final tmpItems = List<AppointmentData>.from(responseData.data
                .map((item) => AppointmentData.fromJsonMap(item)));
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
//      if(items.length > 0) {
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
                final AppointmentData itemData = items[index];
                if (itemData != null) {
                  itemData.patient ??= itemData.inputPatient;
                  return GestureDetector(
                      onTap: () async {
                        if (itemData.patient.patientCode == null ||
                            itemData.patient.patientCode.isEmpty) {
                          //Trường hợp chưa có mã bệnh nhân ==> tạo bệnh nhân để lấy mã và tạo đặt khám cho BN này
                          final ConfirmAction action =
                              await appUtil.asyncConfirmDialog(
                                  context,
                                  'Thông báo',
                                  'Vui lòng tạo mã cho bệnh nhân này để tiếp tục.');
                          if (action == ConfirmAction.ACCEPT) {
                            final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ScreenConfirmPatient(
                                          appoinmentData: itemData,
                                        )));

                            if (result != null) {
                              AppUtil.showLog(
                                  'Back from creean ConfirmPatient => result: ${jsonEncode(result)}');
                              setState(() {
                                items[index] = result;
                              });
                            }
                          } else {
//                              Navigator.pop(context, Constants.SignalSuccess);
                          }
                        } else {
                          final ResultCallBackData result =
                              await DialogUtil.showDialogChangeAppointmentState(
                                  _scaffoldKey, context,
                                  dialogTitle: 'Thông tin đặt khám',
                                  dialogMessage: 'Chọn trạng thái đặt khám',
                                  currentAppointmentState: itemData.state,
                                  okBtnFunction: null);
                          result != null
                              ? AppUtil.showLog('AppointmentState: $result')
                              : AppUtil.showLog('AppointmentState: NULL');
                          if (result != null) {
                            // ignore: avoid_init_to_null
                            String reason = null;
                            if (result.data2 != null) {
                              reason = result.data2;
                            }
                            changeAppointmentState(
                                itemData.id, reason, result.data1);
                          }
                        }
                        /*      ResultCallBackData result = await DialogUtil.showDialogChangeAppointmentState(_scaffoldKey, context,
                              dialogTitle: "Thông tin đặt khám", dialogMessage: "Chọn trạng thái đặt khám", currentAppointmentState: itemData.state, okBtnFunction: null);
                          result != null ? AppUtil.showLog("AppointmentState: " + result.toString()) : AppUtil.showLog("AppointmentState: NULL");
                          if (result != null) {
                            String reason = null;
                            if (result.data2 != null) {
                              reason = result.data2;
                            }
                            changeAppointmentState(itemData.id, reason, result.data1);
                          }*/
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
                                      itemData != null &&
                                              itemData.state != null &&
                                              itemData.state.isNotEmpty
                                          ? appUtil.parseAppoinmentStateWidget(
                                              itemData.state)
                                          : const SizedBox(),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      itemData.patient != null
                                          ? Row(
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
                                                      : const SizedBox(),
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
                                                          ? Text(itemData.code,
                                                              style: Constants
                                                                  .styleTextSmallBlueColor)
                                                          : const Text(
                                                              'Chưa có mã KCB',
                                                              style: Constants
                                                                  .styleTextSmallRedColor)
                                                      /*       itemData.patientCode != null
                                                            ? Text(itemData.patientCode, style: Constants.styleTextSmallBlueColor)
                                                            : Text("Chưa có mã BN", style: Constants.styleTextSmallRedColor)*/
//                                                        itemData.patientCode != null ? Text(itemData.patientCode, style: Constants.styleTextSmallBlueColor) : SizedBox()
                                                    ],
                                                  ),
                                                  onTap: () {},
                                                )
                                              ],
                                            )
                                          : const SizedBox(),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      itemData.patient != null
                                          ? Row(
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
                                            )
                                          : const SizedBox(),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      (itemData.createdTime != null)
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
                                                      'Ngày đặt: ${DateFormat(Constants.FORMAT_DATETIME).format(itemData.createdTime)}',
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
                                      (itemData.appointmentDate != null)
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
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text(
                                                          'Ngày khám: ${DateFormat(Constants.FORMAT_DATEONLY).format(itemData.appointmentDate)}  ',
                                                          style: Constants
                                                              .styleTextNormalSubColor),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                          : const SizedBox(),
                                      /*  (itemData.appointmentDate != null)
                                            ? Row(
                                                children: [
                                                  Image.asset(
                                                    "assets/icon_select_date.png",
                                                    width: 16,
                                                    height: 16,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: Text("Ngày khám: " + DateFormat(Constants.FORMAT_DATEONLY).format(itemData.appointmentDate), style: Constants.styleTextNormalSubColor),
                                                  ),
                                                ],
                                              )
                                            : SizedBox(
                                                height: 0,
                                              ),*/
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

  changeAppointmentState(
      String _id, String terminateReason, String state) async {
    try {
      AppUtil.showLoadingDialog(context);
      final ApiGraphQLControllerMutation apiController =
          ApiGraphQLControllerMutation();

      final QueryResult result = await apiController
          .requestChangeAppointmentState(context, _id, terminateReason, state);
      final String response = result.data.toString();
      AppUtil.showPrint('Response changeAppointmentState: $response');
      await AppUtil.hideLoadingDialog(context);
      if (response != null) {
        final responseData = appUtil.processResponse(result);
        final int code = responseData.code;
        final String message = responseData.message;

        if (code == 0) {
          final String jsonData = json.encode(responseData.data);
          AppUtil.showLogFull('### jsonData changeAppointmentState: $jsonData');

          final String messageSuccess =
              'Bạn đã thay đổi trạng thái \nthành công';
          await DialogUtil.showDialogCreateSuccess(_scaffoldKey, context,
              messageSuccess: messageSuccess, okBtnFunction: () {});

          await reloadData();
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
      AppUtil.showPrint('changeAppointmentState Error: $e');
    }
  }
}
