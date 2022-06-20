import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:DoctorApp/extension/HexColor.dart';
import 'package:DoctorApp/model/OBWheelData.dart';
import 'package:DoctorApp/utils/AppUtil.dart';
import 'package:DoctorApp/utils/Constant.dart';

class ScreenOBWheel extends StatefulWidget {
  @override
  _ScreenOBWheelState createState() => _ScreenOBWheelState();
}

class _ScreenOBWheelState extends State<ScreenOBWheel> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AppUtil appUtil = new AppUtil();

  String strHintDateToday = "Chọn ngày hôm nay";
  DateTime selectedDateToday = DateTime.now();
  String strHintDateLMP = "Chọn ngày kinh cuối";
  // ignore: avoid_init_to_null
  DateTime selectedDateLMP = null;
  String strHintDateConception = "Chọn ngày thụ thai";
  // ignore: avoid_init_to_null
  DateTime selectedDateConception = null;
  String strHintDateEndTri1 = "End of 1st Trimester";
  // ignore: avoid_init_to_null
  DateTime selectedDateEndTri1 = null;
  String strHintDateEndTri2 = "End of 2nd Trimester";
  // ignore: avoid_init_to_null
  DateTime selectedDateEndTri2 = null;
  String strHintDateEDD = "Chọn ngày dự sinh";
  // ignore: avoid_init_to_null
  DateTime selectedDateEDD = null;
  String strHintDateEDDBySA = "Nhập ngày Siêu âm";
  // ignore: avoid_init_to_null
  DateTime selectedDateEDDBySA = null;
  int ageByWeeks = 0;
  int ageByDays = 0;
  int ageByWeeksSA = 0;
  int ageByDaysSA = 0;

  Timer searchOnStoppedTyping;
  Future _selectBirthDate(
      String strHintSelectDate, DateTime _selectedDate) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
              height: MediaQuery.of(context).copyWith().size.height / 3,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: DateTime.now(),
                onDateTimeChanged: (DateTime date) {
                  const duration = Duration(
                      milliseconds:
                          400); // set the duration that you want call search() after that.
                  if (searchOnStoppedTyping != null) {
                    setState(
                        () => searchOnStoppedTyping.cancel()); // clear timer
                  }
                  setState(() => searchOnStoppedTyping = new Timer(
                      duration,
                      () => setState(() {
                            _selectedDate = date;
                            if (strHintSelectDate == strHintDateToday) {
                              selectedDateToday = date;
                            } else if (strHintSelectDate == strHintDateLMP) {
                              selectedDateLMP = date;
                              calculateFromDateLMP();
                            } else if (strHintSelectDate ==
                                strHintDateConception) {
                              selectedDateConception = date;
                              calculateFromDateConception();
                            } else if (strHintSelectDate ==
                                strHintDateEndTri1) {
                              selectedDateEndTri1 = date;
                              calculateFromDateEndTri1();
                            } else if (strHintSelectDate ==
                                strHintDateEndTri2) {
                              selectedDateEndTri2 = date;
                              calculateFromDateEndTri2();
                            } else if (strHintSelectDate == strHintDateEDD) {
                              selectedDateEDD = date;
                              calculateFromDateEDD();
                            } else if (strHintSelectDate ==
                                strHintDateEDDBySA) {
                              selectedDateEDDBySA = date;
                              calculateFromEDDSA();
                            }
//              String formattedDate =  DateFormat(Constants.FORMAT_DATEONLY).format(date);
//              strHintSelectDate = formattedDate;
                          })));
                },
                use24hFormat: false,
                minuteInterval: 1,
              ));
        });
  }

  Widget inputWithDate(
      String inputTitle, String strHintDateDisplay, DateTime _selectedDate) {
    return Padding(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 124,
              child: Text(
                inputTitle,
                style: TextStyle(
                    color: HexColor.fromHex(Constants.Color_maintext),
                    fontSize: Constants.Size_text_normal),
              ),
            ),
            Expanded(
                child: GestureDetector(
              onTap: () {
//                _selectBirthDateToday(strHintDateDisplay, _selectedDate);
                _selectBirthDate(strHintDateDisplay, _selectedDate);
              },
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: _selectedDate != null
                              ? Text(
//                              strHintDateDisplay,
                                  DateFormat(Constants.FORMAT_DATEONLY)
                                      .format(_selectedDate),
                                  style: TextStyle(
                                      color: HexColor.fromHex(
                                          Constants.Color_maintext),
                                      fontSize: Constants.Size_text_normal),
                                )
                              : Text(
                                  strHintDateDisplay,
                                  style: TextStyle(
                                      color: HexColor.fromHex(
                                          Constants.Color_subtext),
                                      fontSize: Constants.Size_text_normal),
                                ),
                        ),
                        Image.asset(
                          "assets/icon_select_date.png",
                          width: 22,
                          height: 22,
                          fit: BoxFit.fill,
                        ),
                        SizedBox(
                          width: 5,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 1,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 3, 0, 0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: HexColor.fromHex(
                                  Constants.Color_input_underline),
                              width: 1.0),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )),
          ],
//      ),
        ));
  }

  Widget inputWithToday(
      String inputTitle, String strHintDateDisplay, DateTime _selectedDate) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 124,
            child: Text(
              inputTitle,
              style: TextStyle(
                  color: HexColor.fromHex(Constants.Color_maintext),
                  fontSize: Constants.Size_text_normal),
            ),
          ),
          Expanded(
              child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(5),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: _selectedDate != null
                          ? Text(
//                              strHintDateDisplay,
                              DateFormat(Constants.FORMAT_DATEONLY)
                                  .format(_selectedDate),
                              style: TextStyle(
                                  color:
                                      HexColor.fromHex(Constants.Color_subtext),
                                  fontSize: Constants.Size_text_normal),
                            )
                          : Text(
                              strHintDateDisplay,
                              style: TextStyle(
                                  color:
                                      HexColor.fromHex(Constants.Color_subtext),
                                  fontSize: Constants.Size_text_normal),
                            ),
                    ),
                    SizedBox(
                      width: 5,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 1,
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 3, 0, 0),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color:
                              HexColor.fromHex(Constants.Color_input_underline),
                          width: 1.0),
                    ),
                  ),
                ),
              )
            ],
          )),
        ],
//      ),
      ),
    );
  }

  Widget inputWithText(String inputTitle, String strText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 124,
          child: Text(
            inputTitle,
            style: TextStyle(
                color: HexColor.fromHex(Constants.Color_maintext),
                fontSize: Constants.Size_text_normal),
          ),
        ),
        Expanded(
            child: Padding(
          padding: EdgeInsets.all(5),
          child: Row(
            children: <Widget>[
              Expanded(
                child: strText != null
                    ? Text(
                        strText,
                        style: TextStyle(
                            color: HexColor.fromHex(Constants.Color_maintext),
                            fontSize: Constants.Size_text_normal),
                      )
                    : Text(
                        "",
                        style: TextStyle(
                            color: HexColor.fromHex(Constants.Color_subtext),
                            fontSize: Constants.Size_text_normal),
                      ),
              ),
              SizedBox(
                width: 5,
              )
            ],
          ),
        )),
      ],
//      ),
    );
  }

  Widget inputWithTextAndBackground(String inputTitle, String strText) {
    return Container(
      color: HexColor.fromHex("#EDEDED"),
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 120,
            child: Text(
              inputTitle,
              style: TextStyle(
                  color: HexColor.fromHex(Constants.Color_maintext),
                  fontSize: Constants.Size_text_normal,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.all(5),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: strText != null
                      ? Text(
                          strText,
                          style: TextStyle(
                              color: HexColor.fromHex(Constants.Color_maintext),
                              fontSize: Constants.Size_text_normal,
                              fontWeight: FontWeight.bold),
                        )
                      : Text(
                          "",
                          style: TextStyle(
                              color: HexColor.fromHex(Constants.Color_subtext),
                              fontSize: Constants.Size_text_normal),
                        ),
                ),
                SizedBox(
                  width: 5,
                )
              ],
            ),
          )),
        ],
//      ),
      ),
    );
  }

  Widget inputDuSinhTheoSieuAm() {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            border: Border.all(
                width: 1, color: Colors.green, style: BorderStyle.solid)),
        padding: EdgeInsets.fromLTRB(15, 12, 15, 12),
        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Text(
                "Dự sinh theo Siêu âm",
                style: TextStyle(
                    color: HexColor.fromHex(Constants.Color_subtext),
                    fontWeight: FontWeight.bold,
                    fontSize: Constants.Size_text_normal),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                    width: 190,
                    child: GestureDetector(
                      onTap: () {
//                _selectBirthDateToday(strHintDateDisplay, _selectedDate);
                        _selectBirthDate(
                                strHintDateEDDBySA, selectedDateEDDBySA)
                            .then((value) {
                          AppUtil.showLog("_selectBirthDate then value $value");
                        });
                      },
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: selectedDateEDDBySA != null
                                      ? Text(
//                              strHintDateEDDBySA,
                                          DateFormat(Constants.FORMAT_DATEONLY)
                                              .format(selectedDateEDDBySA),
                                          style: TextStyle(
                                              color: HexColor.fromHex(
                                                  Constants.Color_maintext),
                                              fontSize:
                                                  Constants.Size_text_normal),
                                        )
                                      : Text(
                                          strHintDateEDDBySA,
                                          style: TextStyle(
                                              color: HexColor.fromHex(
                                                  Constants.Color_subtext),
                                              fontSize:
                                                  Constants.Size_text_normal),
                                        ),
                                ),
                                Image.asset(
                                  "assets/icon_select_date.png",
                                  width: 22,
                                  height: 22,
                                  fit: BoxFit.fill,
                                ),
                                SizedBox(
                                  width: 5,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 1,
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 3, 0, 0),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      color: HexColor.fromHex(
                                          Constants.Color_input_underline),
                                      width: 1.0),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "$ageByWeeksSA tuần, $ageByDaysSA ngày",
                      style: TextStyle(
                          color: HexColor.fromHex(Constants.Color_maintext),
                          fontSize: Constants.Size_text_normal,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
//      ),
            )
          ],
        ));
  }

  calculateFromEDDSA() {
    DateTime newLMPBySA = selectedDateEDDBySA.subtract(new Duration(days: 280));
    AppUtil.showLog("calculateFromEDDSA newLMPBySA: $newLMPBySA");
    setState(() {
      int differenceDays = DateTime.now().difference(newLMPBySA).inDays;
      AppUtil.showLog("differenceDays: $differenceDays");
      ageByWeeksSA = differenceDays ~/ 7;
      ageByDaysSA = differenceDays % 7;
    });
  }

  calculateFromDateLMP() async {
    AppUtil.showLog("calculateFromDateLMP selectedDateLMP: $selectedDateLMP");
    if (selectedDateLMP != null) {
      setState(() {
        selectedDateConception = selectedDateLMP.add(new Duration(days: 14));
//        selectedDateEndTri1 = selectedDateLMP.add(new Duration(days: 84));
//        selectedDateEndTri2 = selectedDateLMP.add(new Duration(days: 182));
//        selectedDateEDD = selectedDateLMP.add(new Duration(days: 280));
//        selectedDateEDD = selectedDateLMP.add(new Duration(days: 280));
        selectedDateEndTri1 = selectedDateLMP.add(new Duration(days: 83));
        selectedDateEndTri2 = selectedDateLMP.add(new Duration(days: 188));
        selectedDateEDD = selectedDateLMP.add(new Duration(days: 280));
        int differenceDays = DateTime.now().difference(selectedDateLMP).inDays;
        AppUtil.showLog("differenceDays: $differenceDays");
        ageByWeeks = differenceDays ~/ 7;
        ageByDays = differenceDays % 7;
//        int tuoiThaiDays = DateTime.now() - selectedDateLMP;
      });

      try {
        OBWheelData obWheelData = new OBWheelData();
        obWheelData.dateCalculate = DateTime.now();
        obWheelData.dateLMP = selectedDateLMP;
        obWheelData.dateConception = selectedDateConception;
        obWheelData.dateEndTri1 = selectedDateEndTri1;
        obWheelData.dateEndTri2 = selectedDateEndTri2;
        obWheelData.dateDateEDD = selectedDateEDD;

        List<OBWheelData> arrOBWheel = await appUtil.getOBWheelHistory();
        arrOBWheel.insert(0, obWheelData);
        appUtil.saveOBWheel(arrOBWheel);
      } catch (e) {
        AppUtil.showPrint(e.toString());
      }
    }
  }

  calculateFromDateConception() {
    if (selectedDateConception != null) {
      setState(() {
        selectedDateLMP =
            selectedDateConception.subtract(new Duration(days: 14));
      });
      calculateFromDateLMP();
    }
  }

  calculateFromDateEndTri1() {
    if (selectedDateEndTri1 != null) {
      setState(() {
        selectedDateLMP = selectedDateEndTri1.subtract(new Duration(days: 83));
      });
      calculateFromDateLMP();
    }
  }

  calculateFromDateEndTri2() {
    if (selectedDateEndTri2 != null) {
      setState(() {
        selectedDateLMP = selectedDateEndTri2.subtract(new Duration(days: 188));
      });
      calculateFromDateLMP();
    }
  }

  calculateFromDateEDD() {
    if (selectedDateEDD != null) {
      setState(() {
        selectedDateLMP = selectedDateEDD.subtract(new Duration(days: 280));
      });
      calculateFromDateLMP();
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputLMPToday =
        inputWithToday("Ngày hôm nay:", strHintDateToday, selectedDateToday);
    final inputLMPDate =
        inputWithDate("Ngày kinh cuối:", strHintDateLMP, selectedDateLMP);
    final inputConceptionDate = inputWithDate(
        "Ngày thụ thai:", strHintDateConception, selectedDateConception);
    final inputEndTri1Date =
        inputWithDate("End Tri 1:", strHintDateEndTri1, selectedDateEndTri1);
    final inputEndTri2Date =
        inputWithDate("End Tri 2:", strHintDateEndTri2, selectedDateEndTri2);
    final inputEDDDate =
        inputWithDate("Ngày dự sinh:", strHintDateEDD, selectedDateEDD);
    final inputWGA = inputWithTextAndBackground(
        "Tuổi thai", "$ageByWeeks tuần, $ageByDays ngày");

    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          key: _scaffoldKey,
//          appBar: appUtil.getAppBar(new Text("Tính tuổi thai")),
          backgroundColor: Colors.white,
          body: Stack(
            children: <Widget>[
//              Image.asset(
//                "assets/bg_blur.png",
//                height: MediaQuery.of(context).size.height,
//                width: MediaQuery.of(context).size.width,
//                fit: BoxFit.fill,
//              ),
              SingleChildScrollView(
                child: Column(
//                shrinkWrap: true,
//            padding: EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 15),
                  children: <Widget>[
                    SizedBox(
                      height: 15,
                    ),
                    inputLMPToday,
                    SizedBox(
                      height: 10,
                    ),
                    inputLMPDate,
                    SizedBox(
                      height: 10,
                    ),
                    inputConceptionDate,
                    SizedBox(
                      height: 10,
                    ),
                    inputEndTri1Date,
                    SizedBox(
                      height: 10,
                    ),
                    inputEndTri2Date,
                    SizedBox(
                      height: 10,
                    ),
                    inputEDDDate,
                    SizedBox(
                      height: 10,
                    ),
                    inputWGA,
                    SizedBox(
                      height: 10,
                    ),
                    inputDuSinhTheoSieuAm(),
                    SizedBox(
                      height: 10,
                    ),
//            btnRegister,
                    /*      RaisedGradientButton(
                  child: Text(
                    'Đăng ký',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color(Constants.Color_gradient_green_start),
                      Color(Constants.Color_gradient_green_end)
                    ],
                  ),
                  onPressed: () {
                    _onRegisterButtonPressed(context);
                  }),
              SizedBox(
                height: 18,
              ),*/
                  ],
                ),
              ),
//          ),
            ],
          ),
        ));
//      Scaffold(
//      key: _scaffoldKey,
//      appBar: appUtil.getAppBar(new Text("Tính tuổi thai")),
//      backgroundColor: Colors.white,
//      body: Stack(
//        children: <Widget>[
//          Image.asset(
//            "assets/bg_blur.png",
//            height: MediaQuery.of(context).size.height,
//            width: MediaQuery.of(context).size.width,
//            fit: BoxFit.fill,
//          ),
//          ListView(
//            shrinkWrap: true,
////            padding: EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 15),
//            children: <Widget>[
//              SizedBox(
//                height: 18,
//              ),
//              inputLMPToday,
//              SizedBox(
//                height: 15,
//              ),
//              inputLMPDate,
//              SizedBox(
//                height: 15,
//              ),
//              inputConceptionDate,
//              SizedBox(
//                height: 15,
//              ),
//              inputEndTri1Date,
//              SizedBox(
//                height: 15,
//              ),
//              inputEndTri2Date,
//              SizedBox(
//                height: 15,
//              ),
//              inputEDDDate,
//              SizedBox(
//                height: 15,
//              ),
//              inputWGA,
//              SizedBox(
//                height: 15,
//              ),
//              inputDuSinhTheoSieuAm(),
//              SizedBox(
//                height: 15,
//              ),
////            btnRegister,
//              /*      RaisedGradientButton(
//                  child: Text(
//                    'Đăng ký',
//                    style: TextStyle(
//                        color: Colors.white, fontWeight: FontWeight.bold),
//                  ),
//                  gradient: LinearGradient(
//                    colors: <Color>[
//                      Color(Constants.Color_gradient_green_start),
//                      Color(Constants.Color_gradient_green_end)
//                    ],
//                  ),
//                  onPressed: () {
//                    _onRegisterButtonPressed(context);
//                  }),
//              SizedBox(
//                height: 18,
//              ),*/
//            ],
//          ),
////          ),
//        ],
//      ),
//    );
  }
}
