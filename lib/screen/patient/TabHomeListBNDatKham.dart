import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

import '../../controller/ApiGraphQLControllerMutation.dart';
import '../../controller/ApiGraphQLControllerQuery.dart';
import '../../extension/HexColor.dart';
import '../../model/AppointmentData.dart';
import '../../model/GraphQLModels.dart';
import '../../model/ResultCallBackData.dart';
import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';
import '../../utils/DialogUtil.dart';
import 'ScreenAddPatient.dart';
import 'ScreenConfirmPatient.dart';
import 'ScreenPatientDetail.dart';

class TabHomeListBNDatKham extends StatefulWidget {
  const TabHomeListBNDatKham({
    Key key,
  }) : super(key: key);

  @override
  _TabHomeListBNDatKhamState createState() => _TabHomeListBNDatKhamState();
}

class _TabHomeListBNDatKhamState extends State<TabHomeListBNDatKham> {
//class _TabHomeListBNDatKhamState extends State<TabHomeListBNDatKham>  with AutomaticKeepAliveClientMixin<TabHomeListBNDatKham>  {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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

  Future<void> reloadData() async {
    page = 0;
    pageSize = 18;
    totalPages = 10;
    items.clear();
    await getMoreData();
  }

  Future<void> getMoreData() async {
    AppUtil.showPrint('getMoreData page: $page / total: $totalPages');
    if (!isPerformingRequest && page < totalPages) {
      setState(() => isPerformingRequest = true);
//      try {
      final List<FilteredInput> arrFilterinput = [];
      final List<SortedInput> arrSortedinput = [];
      final fromDate = DateTime(
          requestFromDate.year, requestFromDate.month, requestFromDate.day);
      final toDate = DateTime(
          requestToDate.year, requestToDate.month, requestToDate.day + 1);
      // arrFilterinput.add(FilteredInput("appointmentDate", fromDate.toIso8601String() + "," + toDate.toIso8601String(), "between"));
      arrFilterinput.add(FilteredInput(
          'createdTime',
          '${fromDate.toIso8601String()},${toDate.toIso8601String()}',
          'between'));
      arrFilterinput.add(FilteredInput(
          'code,inputPatient.fullName,inputPatient.phoneNumber',
          keySearch,
          ''));
//      arrFilterinput.add(FilteredInput("followByDoctor", "true", ""));
      arrSortedinput.add(SortedInput('createdTime', true));
      final ApiGraphQLControllerQuery apiController =
          ApiGraphQLControllerQuery();

      final QueryResult result = await apiController.requestGetAppointments(
          context, page, arrFilterinput, arrSortedinput);
      final String response = result.data.toString();
//        log("Response requestGetAppointments: " + response);
      if (response != null) {
        final responseData = appUtil.processResponseWithPage(result);
        final int code = responseData.code;
        final String message = responseData.message;

        if (code == 0) {
          final String jsonData = json.encode(responseData.data);
          log('### jsonData: $jsonData');
          if (jsonData == null || jsonData.isEmpty) {
            totalPages = 0;
          } else {
            AppUtil.showPrint('### pages: ${responseData.pages}');
            totalPages = responseData.pages;
          }
          final tmpItems = List<AppointmentData>.from(responseData.data
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
//        appBar: appUtil.getAppBar(new Text("DS BỆNH NHÂN ĐẶT KHÁM")),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Add your onPressed code here!
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ScreenAddPatient()),
          );
          if (result != null && result == Constants.SignalSuccess) {
            await reloadData();
          }
        },
        backgroundColor: Constants.colorMain,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Image.asset(
            'assets/add_more.png',
          ),
        ),
      ),
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
                    AppUtil.searchWidget(
                        'Tìm kiếm', _onChangeHandler, editingController),
                  ],
                );
              }

              index -= 1;

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
                            await changeAppointmentState(
                                itemData.id, reason, result.data1);
                          }
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                            color: Constants.white,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Constants.colorShadow,
                                  offset: Offset(1.1, 1.1),
                                  blurRadius: 1),
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            itemData.patient != null
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
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
                                              itemData != null &&
                                                      itemData.code != null
                                                  ? Text(itemData.code,
                                                      style: Constants
                                                          .styleTextSmallBlueColor)
                                                  : const Text('Chưa có mã KCB',
                                                      style: Constants
                                                          .styleTextSmallRedColor)
                                            ],
                                          ),
                                          itemData != null &&
                                                  itemData.state != null &&
                                                  itemData.state.isNotEmpty
                                              ? appUtil
                                                  .parseAppoinmentStateWidget(
                                                      itemData.state)
                                              : const SizedBox(),
                                        ],
                                      ),
                                      (itemData.patient?.fullName != null)
                                          ? Text(itemData.patient.fullName,
                                              style: Constants
                                                  .styleTextNormalBlueColorBold)
                                          : const SizedBox(),
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
                                                                itemData.patient
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
                                                (itemData.patient?.birthDay !=
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
                                                            patientCode: itemData
                                                                .patient
                                                                .patientCode,
                                                          )));
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
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
                            (itemData.doctor != null &&
                                    itemData.doctor.base != null &&
                                    itemData.doctor.base.fullName != null)
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
                                            itemData.doctor.base.fullName,
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
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                          ],
                        ),
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

  Future<void> changeAppointmentState(
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

          const String messageSuccess =
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

    await getMoreData();
  }
}
