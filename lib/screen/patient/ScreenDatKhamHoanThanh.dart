import 'dart:convert';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:search_choices/search_choices.dart';

import '../../controller/ApiGraphQLControllerMutation.dart';
import '../../controller/ApiGraphQLControllerQuery.dart';
import '../../design_widget/widget_button_align.dart';
import '../../extension/HexColor.dart';
import '../../model/AppointmentInput.dart';
import '../../model/CommonTypeData.dart';
import '../../model/PatientData.dart';
import '../../model/WorkTimeData.dart';
import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';
import '../../utils/DialogUtil.dart';

// ignore: must_be_immutable
class ScreenDatKhamHoanThanh extends StatefulWidget {
  PatientData patientInput;

  ScreenDatKhamHoanThanh({Key key, this.patientInput}) : super(key: key);

  @override
  _ScreenDatKhamHoanThanhState createState() => _ScreenDatKhamHoanThanhState();
}

class _ScreenDatKhamHoanThanhState extends State<ScreenDatKhamHoanThanh> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AppUtil appUtil = AppUtil();

  DateTime selectedAppointmentDate = null;

//  TextEditingController textControllerReason = TextEditingController();
  TextEditingController textControllerNote = TextEditingController();

//  final FocusNode focusNodeReason = FocusNode();
  final FocusNode focusNodeNote = FocusNode();

  bool isLoadingDataDeparment = false,
      isLoadingDataWorkTime = false,
      isLoadingDataDeparmentChildren = true,
      enableTimeFrame = true;
  List<ServiceData> listServicesData = [];
  List<ServiceParent> listServicesSelect = [];
  Departments selectDepartment = null;
  DepartmentInfo departmentInfo = null;

  List<WorkTimeServeTimeData> arrWorkTimes = [];
  WorkTimeServeTimeData selectedWorkTime = null;

  TextEditingController _controllerTime =
      TextEditingController(text: DateTime.now().toString());

  @override
  void initState() {
    super.initState();

    setState(() {
      selectedAppointmentDate = DateTime.now();
    });
    listServicesSelect
        .add(new ServiceParent(ServiceData('', '', '', '', [], true, 0), []));
    requestGetServices();
  }

  int selectedWorkTimeIndex = -1;

  @override
  Widget build(BuildContext context) => mainView();

  Widget mainView() => GestureDetector(
        onTap: () {
          final FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            key: _scaffoldKey,
            appBar: AppUtil.customAppBar(context, 'ĐẶT LỊCH KHÁM'),
            body: Stack(
              children: <Widget>[
                SingleChildScrollView(
                  child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
//                      child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              const SizedBox(
                                height: 12,
                              ),
                              Container(
                                  height: heightContainer(),
                                  margin: const EdgeInsets.symmetric(),
                                  child: ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: listServicesSelect.length,
                                      itemBuilder: (itemValue, int index) =>
                                          rowSelectServiceChildByIndex(
                                              itemValue, index))),
                              const SizedBox(
                                height: 12,
                              ),
                              rowSelectDepartment(),
                              const SizedBox(
                                height: 12,
                              ),
                              viewSelectDay(),
                              // SizedBox(
                              //   height: enableTimeFrame ? 15 : 0,
                              // ),
                              // enableTimeFrame
                              //     ? rowTimeFrameText()
                              //     : const SizedBox(),
                              // SizedBox(
                              //   height: enableTimeFrame ? 6 : 0,
                              // ),
                              // enableTimeFrame
                              //     ? rowTimeFrame()
                              //     : const SizedBox(),
                              const SizedBox(
                                height: 30,
                              ),
                              Row(
                                children: const <Widget>[
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Triệu chứng cần khám:',
                                    style: Constants.styleTextNormalMainColor,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                textInputAction: TextInputAction.done,
                                minLines: 3,
                                maxLines: 5,
                                controller: textControllerNote,
                                focusNode: focusNodeNote,
                                style: Constants.styleTextNormalBlueColor,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: HexColor.fromHex(
                                        Constants.Color_divider),
                                    hintText: 'Triệu chứng',
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                      borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      ),
                                    )),
                              ),
                              const SizedBox(
                                height: 115,
                              ),
                            ],
                          )
//                      ),
                          )
                    ],
                  ),
                ),
                WidgetButtonAlign(
                    name: 'HOÀN THÀNH',
                    clickButton: () async {
                      onClickSavePatient();
                    })
              ],
            )),
      );

  Widget rowTimeFrameText() => Row(
        children: const <Widget>[
          SizedBox(
            width: 10,
          ),
          Text(
            'Khung giờ khám',
            style: Constants.styleTextNormalMainColor,
          ),
        ],
      );

  Widget rowTimeFrame() => arrWorkTimes != null && arrWorkTimes.isNotEmpty
      ? Container(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          color: Colors.white,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: arrWorkTimes.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final WorkTimeServeTimeData itemData =
                  arrWorkTimes.elementAt(index);
              return itemData.remain > 0
                  ? GestureDetector(
                      child: Container(
                        color: selectedWorkTimeIndex == index
                            ? Colors.green
                            : HexColor.fromHex(Constants.Color_divider),
                        margin: const EdgeInsets.all(2.5),
                        child: Column(
                          children: <Widget>[
                            Expanded(
                                child: Center(
                              child: Text(
                                itemData.time,
                                style: Constants.styleTextNormalMainColor,
                              ),
                            )),
                            Expanded(
                              child: Container(
                                color:
                                    HexColor.fromHex(Constants.Color_primary),
                                child: Center(
                                  child: Text(
                                    itemData.remain.toString(),
                                    style: const TextStyle(
                                        color: Color(0xFFFFFFFF),
                                        fontWeight: FontWeight.normal,
                                        fontSize: Constants.Size_text_normal),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          selectedWorkTime = itemData;
                          selectedWorkTimeIndex = index;
                        });
                      },
                    )
                  : const SizedBox();
            },
          ))
      : Center(
          child: Text(
            'Không có khung giờ khám nào',
            style: TextStyle(
                color: HexColor.fromHex(Constants.Color_hinttext),
                fontWeight: FontWeight.normal,
                fontSize: Constants.Size_text_normal),
          ),
        );

  double heightContainer() {
    if (listServicesSelect.isEmpty) {
      return 65;
    } else if (listServicesSelect[listServicesSelect.length - 1].children !=
            null &&
        listServicesSelect[listServicesSelect.length - 1].children.isNotEmpty)
      return 65 * double.parse(listServicesSelect.length.toString());
    else
      return 65 * double.parse((listServicesSelect.length - 1).toString());
  }

  Future selectDate() async {
    await showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) => SizedBox(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: DateTime.now(),
              onDateTimeChanged: (DateTime date) {
                setState(() {
                  selectedAppointmentDate = date;
                });
              },
            )));
  }

  Widget viewSelectDay() => GestureDetector(
        onTap: () {
          selectDate();
        },
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: selectedAppointmentDate != null
                        ? Text(
//                              strHintDateDisplay,
                            DateFormat(Constants.FORMAT_DATEONLY)
                                .format(selectedAppointmentDate),
                            style: selectedAppointmentDate != null
                                ? Constants.styleTextNormalBlueColor
                                : Constants.styleTextNormalHintColor,
                          )
                        : Text(
                            'Chọn ngày sinh',
                            style: TextStyle(
                                color:
                                    HexColor.fromHex(Constants.Color_subtext),
                                fontSize: Constants.Size_text_normal),
                          ),
                  ),
                  Image.asset(
                    'assets/icon_select_date.png',
                    width: 22,
                    height: 22,
                    fit: BoxFit.fill,
                  ),
                  const SizedBox(
                    width: 5,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 1,
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color:
                            HexColor.fromHex(Constants.Color_input_underline)),
                  ),
                ),
              ),
            )
          ],
        ),
      );

  onSaveDay(String val) {
    AppUtil.showPrint(val);
    selectedAppointmentDate = DateTime.parse(val);
    getTimeWork();
  }

  Future<void> onClickSavePatient() async {
    try {
      if (listServicesSelect[listServicesSelect.length - 1].children.length >
          1) {
        appUtil.showToastWithScaffoldState(_scaffoldKey,
            'Vui lòng chọn dịch vụ tại ${listServicesSelect[listServicesSelect.length - 1].info.name}');
        return;
      }
      if (listServicesSelect[listServicesSelect.length - 1]
                  .info
                  .departments
                  .length >
              1 &&
          selectDepartment == null) {
        appUtil.showToastWithScaffoldState(
            _scaffoldKey, 'Vui lòng chọn phòng khám');
        return;
      }
      if (selectedAppointmentDate == null) {
        appUtil.showToastWithScaffoldState(
            _scaffoldKey, 'Vui lòng chọn ngày khám');
        return;
      }
      // if (enableTimeFrame && selectedWorkTime == null) {
      //   appUtil.showToastWithScaffoldState(
      //       _scaffoldKey, 'Vui lòng chọn khung giờ khám');
      //   return;
      // }

      // if (textControllerNote.text.trim().length == 0) {
      //   appUtil.showToastWithScaffoldState(
      //       _scaffoldKey, "Vui lòng nhập lý do khám");
      //   return;
      // }

      final AppointmentInput appointmentInput = AppointmentInput()
        ..inputPatient = widget.patientInput
        ..appointmentDate = selectedAppointmentDate
        ..appointmentTime =
            selectedWorkTime != null ? selectedWorkTime.time : ''
        ..patientCode = widget.patientInput.patientCode;
      if (selectDepartment != null) {
        appointmentInput.departmentId = selectDepartment.id;
      } else {
        appointmentInput.departmentId =
            listServicesSelect[listServicesSelect.length - 1]
                .info
                .departments[0]
                .id;
      }

      appointmentInput
        ..serviceDemandId =
            listServicesSelect[listServicesSelect.length - 1].info.id
        ..channel = 'APP'
        ..note = textControllerNote.text;

      try {
        AppUtil.showLoadingDialog(context);
        final ApiGraphQLControllerMutation apiController =
            ApiGraphQLControllerMutation();

        final QueryResult result = await apiController.requestCreateAppointment(
            context, appointmentInput);
        final String response = result.data.toString();
        AppUtil.showPrint('Response requestCreateAppointment: $response');
        AppUtil.hideLoadingDialog(context);
        if (response != null) {
          final responseData = appUtil.processResponse(result);
          final int code = responseData.code;
          final String message = responseData.message;

          if (code == 0) {
            final String jsonData = json.encode(responseData.data);
            AppUtil.showLogFull(
                '### jsonData requestCreateAppointment: $jsonData');

            final String messageSuccess = 'Bạn đã đặt khám thành công!';
            await DialogUtil.showDialogCreateSuccess(_scaffoldKey, context,
                messageSuccess: messageSuccess, okBtnFunction: () {});

            Navigator.pop(context, Constants.SignalSuccess);
          } else {
            await AppUtil.showPopup(context, 'Thông báo', message);
            AppUtil.hideLoadingDialog(context);
          }
        } else {
          await AppUtil.showPopup(context, 'Thông báo',
              'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại');
          AppUtil.hideLoadingDialog(context);
        }
        AppUtil.hideLoadingDialog(context);
      } on Exception catch (e) {
        AppUtil.hideLoadingDialog(context);
        AppUtil.showPrint('requestGetNewsArticles Error: $e');
      }
    } catch (e) {
      AppUtil.showPrint(e);
    }
  }

  Future<void> requestGetServices() async {
    String parentId = '';
    if (listServicesSelect.length > 1) {
      parentId = listServicesSelect[listServicesSelect.length - 1].info.id;
    }
    final ApiGraphQLControllerQuery apiController = ApiGraphQLControllerQuery();
    final QueryResult result =
        await apiController.requestqueryGetServiceParentId(context, parentId);
    if (result == null) return;
    final String response = result.data.toString();
    if (response != null) {
      final responseData = appUtil.processResponse(result);
      final int code = responseData.code;
      final String message = responseData.message;

      if (code == 0) {
        listServicesData = List<ServiceData>.from(
            responseData.data.map((it) => ServiceData.fromJsonMap(it)));
        setState(() {
          listServicesSelect[listServicesSelect.length - 1].children =
              listServicesData;
        });
      } else {
        AppUtil.showPopup(context, 'Thông báo', message);
      }
    } else {
      AppUtil.showPopup(context, 'Thông báo',
          'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại');
    }
  }

  requestGetDepartmentById(String departmentID, DateTime date) async {
    try {
      setState(() {
        selectedWorkTime = null;
        arrWorkTimes.clear();
      });
      final ApiGraphQLControllerQuery apiController =
          ApiGraphQLControllerQuery();

      final QueryResult result = await apiController
          .requestqueryGetDepartmentId(context, departmentID);
      final String response = result.data.toString();
      AppUtil.showPrint('Response requestGetDepartmentById: $response');
      if (response != null) {
        final responseData = appUtil.processResponse(result);
        final int code = responseData.code;
        final String message = responseData.message;
        if (code == 0) {
          final String jsonData = json.encode(responseData.data);
          departmentInfo = DepartmentInfo.fromJsonMap(jsonDecode(jsonData));
          setState(() {
            enableTimeFrame = departmentInfo.enableTimeFrame;
          });
          if (departmentInfo.enableTimeFrame) getTimeOfWork(departmentID, date);
        } else {
          AppUtil.showPopup(context, 'Thông báo', message);
        }
      } else {
        AppUtil.showPopup(context, 'Thông báo',
            'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại');
      }
    } on Exception catch (e) {
      AppUtil.showPrint('requestGetNewsArticles Error: $e');
    }
  }

  Future<void> requestGetDepartmentWorkTimes(
      String departmentID, DateTime date) async {
    requestGetDepartmentById(departmentID, date);
  }

  getTimeOfWork(String departmentID, DateTime date) async {
    try {
      setState(() {
        selectedWorkTime = null;
        arrWorkTimes.clear();
      });
      final ApiGraphQLControllerQuery apiController =
          ApiGraphQLControllerQuery();

      final QueryResult result = await apiController
          .requestGetDepartmentWorkTimes(context, departmentID, date);
      final String response = result.data.toString();
      AppUtil.showPrint('Response requestGetDepartmentWorkTimes: $response');
      if (response != null) {
        final responseData = appUtil.processResponse(result);
        final int code = responseData.code;
        final String message = responseData.message;

        if (code == 0) {
          final String jsonData = json.encode(responseData.data);
          AppUtil.showLogFull(
              '### jsonData requestGetDepartmentWorkTimes: $jsonData');
//          setState(() {
          final WorkTimeData deparmentWorkTimData =
              WorkTimeData.fromJsonMap(jsonDecode(jsonData));
          if (deparmentWorkTimData != null) {
            setState(() {
              arrWorkTimes = deparmentWorkTimData.servtimeOnDate;
            });
          }
        } else {
          AppUtil.showPopup(context, 'Thông báo', message);
        }
      } else {
        AppUtil.showPopup(context, 'Thông báo',
            'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại');
      }
    } on Exception catch (e) {
      AppUtil.showPrint('requestGetNewsArticles Error: $e');
    }
  }

  RenderObjectWidget rowSelectDepartment() => (listServicesSelect.isNotEmpty &&
          listServicesSelect[listServicesSelect.length - 1]
                  .info
                  .departments
                  .length >
              1)
      ? Row(
          children: <Widget>[
            Expanded(
                child:
                    // DropdownButton<Departments>(
                    //   isExpanded: true,
                    //   hint: Row(
                    //     children: const <Widget>[
                    //       SizedBox(
                    //         width: 12,
                    //       ),
                    //       Expanded(
                    //         child: Text(
                    //           'Chọn phòng khám',
                    //           style: Constants.styleTextNormalHintColor,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    //   value: selectDepartment,
                    //   onChanged: (Departments value) {
                    //     setState(() {
                    //       selectDepartment = value;
                    //     });
                    //     if (selectDepartment != null &&
                    //         selectedAppointmentDate != null) {
                    //       requestGetDepartmentWorkTimes(
                    //           selectDepartment.id, selectedAppointmentDate);
                    //     }
                    //   },
                    //   items: listServicesSelect[listServicesSelect.length - 1]
                    //       .info
                    //       .departments
                    //       .map((Departments user) => DropdownMenuItem<Departments>(
                    //           value: user,
                    //           child: Row(
                    //             children: <Widget>[
                    //               const SizedBox(
                    //                 width: 12,
                    //               ),
                    //               Expanded(
                    //                   child: Text(
                    //                 user.name,
                    //                 style: Constants.styleTextNormalBlueColor,
                    //               )),
                    //             ],
                    //           )))
                    //       .toList(),
                    // ),
                    SearchChoices.single(
                        items: listServicesSelect[listServicesSelect.length - 1]
                            .info
                            .departments
                            .map((Departments item) => DropdownMenuItem(
                                  value: item.name,
                                  onTap: () {
                                    setState(() {
                                      selectDepartment = item;
                                    });
                                  },
                                  child: Text(
                                    item.name,
                                    style: Constants.styleTextNormalBlueColor,
                                  ),
                                ))
                            .toList(),
                        style: Constants.styleTextNormalBlueColor,
                        value: selectDepartment?.name,
                        hint: 'Chọn phòng khám',
                        searchHint: 'Chọn phòng khám',
                        onChanged: (Departments value) {
                          setState(() {
                            selectDepartment = value;
                          });
                        },
                        isExpanded: true,
                        closeButton: 'Đóng'))
          ],
        )
      : const SizedBox();

  String getNameHintSelect() {
    String textHint = '   ';
    if (listServicesSelect.length > 1) {
      for (var i = 1; i < listServicesSelect.length; i++) {
        if (listServicesSelect.length == i + 1)
          textHint += listServicesSelect[i].info.name;
        else
          textHint += '${listServicesSelect[i].info.name} => ';
      }
    } else
      textHint += 'Chọn dịch vụ';
    return textHint;
  }

  Widget rowSelectServiceChildByIndex(value, int index) =>
      (listServicesSelect.isNotEmpty &&
              listServicesSelect[index] != null &&
              listServicesSelect[index].children != null &&
              listServicesSelect[index].children.isNotEmpty)
          ? Row(
              children: <Widget>[
                Expanded(
                    child: SearchChoices.single(
                        items: listServicesSelect[index]
                            .children
                            .map((ServiceData item) => DropdownMenuItem(
                                  value: item.name,
                                  onTap: () {
                                    selectItemServie(index, item);
                                  },
                                  child: Text(
                                    item.name,
                                    style: Constants.styleTextNormalBlueColor,
                                  ),
                                ))
                            .toList(),
                        style: Constants.styleTextNormalBlueColor,
                        value: (listServicesSelect.length - 1 > index &&
                                listServicesSelect[index + 1] != null)
                            ? listServicesSelect[index + 1].info.name
                            : null,
                        hint: getNameHintSelect(),
                        searchHint: Expanded(
                            child: Text(
                          getNameHintSelect(),
                          style: Constants.styleTextNormalBlueColor,
                        )),
                        onChanged: (ServiceData value) {
                          selectItemServie(index, value);
                        },
                        isExpanded: true,
                        closeButton: 'Đóng')
                    // DropdownButton<ServiceData>(
                    //   isExpanded: true,
                    //   hint: Row(
                    //     children: <Widget>[
                    //       Expanded(
                    //         child: Text(
                    //           getNameHintSelect(),
                    //           style: Constants.styleTextNormalHintColor,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    //   value: (listServicesSelect.length - 1 > index &&
                    //           listServicesSelect[index + 1] != null)
                    //       ? listServicesSelect[index + 1].info
                    //       : null,
                    //   onChanged: (ServiceData value) {
                    //     selectItemServie(index, value);
                    //   },
                    //   items: listServicesSelect[index]
                    //       .children
                    //       .map((ServiceData user) => DropdownMenuItem<ServiceData>(
                    //           value: user,
                    //           child: Row(
                    //             children: <Widget>[
                    //               const SizedBox(
                    //                 width: 12,
                    //               ),
                    //               Expanded(
                    //                   child: Text(
                    //                 user.name,
                    //                 style: Constants.styleTextNormalBlueColor,
                    //               )),
                    //             ],
                    //           )))
                    //       .toList(),
                    // ),
                    ),
                showNote(index),
              ],
            )
          : const SizedBox();

  Widget showNote(int index) => listServicesSelect.length - 1 > index &&
          listServicesSelect[index + 1] != null &&
          listServicesSelect[index + 1].info.note != null &&
          listServicesSelect[index + 1].info.note != ''
      ? TextButton(
          onPressed: () {
            onClickShowNote(listServicesSelect[index + 1].info.name,
                listServicesSelect[index + 1].info.note);
          },
          child: Text(
            'Lưu ý',
            style: TextStyle(color: Colors.red[600]),
          ),
        )
      : const SizedBox();

  onClickShowNote(String name, String note) {
    // String mess = note.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ');
    final String mess = note
        .replaceAll('/\\n/g', '\n')
        .replaceAll('/<br\s?\/?>/gi', '\n')
        .replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ');
    DialogUtil.showDialogWithTitle(_scaffoldKey, context,
        dialogTitle: name,
        dialogMessage: 'Chi tiết: $mess',
        okBtnFunction: null);
  }

  selectItemServie(int index, ServiceData value) {
    if (index == listServicesSelect.length - 1) {
      listServicesSelect.add(ServiceParent(value, []));
    } else {
      final List<ServiceParent> listNew = [];
      for (var i = 0; i <= index; i++) {
        listNew.add(listServicesSelect[i]);
      }
      listNew.add(ServiceParent(value, []));
      listServicesSelect.clear();
      listServicesSelect = listNew;
    }
    if (value.haveChildren == true) {
      setState(() {
        arrWorkTimes = [];
        selectedWorkTimeIndex = -1;
      });
      requestGetServices();
    } else {
      getTimeWork();
    }
  }

  getTimeWork() {
    if (listServicesSelect.length > 1 && selectedAppointmentDate != null) {
      setState(() {
        arrWorkTimes = [];
        selectedWorkTimeIndex = -1;
      });
      if (listServicesSelect[listServicesSelect.length - 1].children.length <
          2) {
        if (listServicesSelect[listServicesSelect.length - 1]
                .info
                .departments
                .length ==
            1)
          requestGetDepartmentWorkTimes(
              listServicesSelect[listServicesSelect.length - 1]
                  .info
                  .departments[0]
                  .id,
              selectedAppointmentDate);

        if (listServicesSelect[listServicesSelect.length - 1]
                    .info
                    .departments
                    .length >
                1 &&
            selectDepartment != null)
          requestGetDepartmentWorkTimes(
              selectDepartment.id, selectedAppointmentDate);
      }
    }
  }
}
