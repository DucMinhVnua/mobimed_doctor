import 'dart:convert';
import 'dart:math';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../controller/ApiGraphQLControllerQuery.dart';
import '../../extension/HexColor.dart';
import '../../model/StatisticAppointmentByIndex.dart';
import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';

class ScreenThongKe extends StatefulWidget {
  const ScreenThongKe({Key key}) : super(key: key);

  @override
  _ScreenThongKeState createState() => _ScreenThongKeState();
}

class _ScreenThongKeState extends State<ScreenThongKe> {
//  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AppUtil appUtil = AppUtil();

  int countDangKyKham = 0;
  int countDaKham = 0;
  int countKhongKham = 0;

  var now = DateTime.now();
  var formatter = DateFormat(Constants.FORMAT_DATEONLY);
  DateTime requestFromDate; // = "";
  DateTime requestToDate; // = "";

  bool toggle = false;
  List<Color> colorList = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
  ];

  Map<String, double> seriesListChannel = Map();
  Map<String, double> seriesListTiLeDatKham = Map();
  Map<String, double> seriesListTiLeDenKham = Map();
  // ignore: avoid_init_to_null
  StatisticAppointmentByIndex statisticAppointmentByIndex = null;

  @override
  void initState() {
    super.initState();
    setState(() {
      requestFromDate = now.subtract(const Duration(days: 7));
      _controllerTimeFrom.text =
          now.subtract(const Duration(days: 7)).toString();
      requestToDate = now;
      _controllerTimeTo.text = now.toString();
    });

    loadReportAppointmentIndex(context);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppUtil.customAppBar(context, 'THỐNG KÊ'),
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(12),
            color: HexColor.fromHex(Constants.Color_divider),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                viewSelectDayFrom(),
                const SizedBox(
                  height: 20,
                ),
                viewSelectDayTo(),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: <Widget>[
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Center(
                      child: Container(
                width: 200,
                margin: const EdgeInsets.all(6),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: HexColor.fromHex(Constants.Color_primary),
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      countDangKyKham.toString(),
                      style: const TextStyle(fontSize: 28, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      'Đăng ký khám',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ],
                ),
              ))),
              Expanded(
                  child: Center(
                      child: Container(
                width: 200,
                margin: const EdgeInsets.all(6),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: HexColor.fromHex('#00AA4F'),
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      countDaKham.toString(),
                      style: const TextStyle(fontSize: 28, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      'Đã khám',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ],
                ),
              ))),
              Expanded(
                  child: Center(
                      child: Container(
                width: 200,
                margin: const EdgeInsets.all(6),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: HexColor.fromHex('#F84366'),
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      countKhongKham.toString(),
                      style: const TextStyle(fontSize: 28, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      'Không khám',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ],
                ),
              ))),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Divider(
            color: HexColor.fromHex(Constants.Color_divider),
            thickness: 10,
          ),
          const SizedBox(
            height: 15,
          ),
          seriesListTiLeDatKham != null && seriesListTiLeDenKham != null
              ? Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: const <Widget>[
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'TL bệnh nhân đặt khám',
                                      style: Constants.styleTextTitleBlueColor,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              SizedBox(
                                  width: 200,
                                  height: 250,
                                  child: seriesListTiLeDatKham != null &&
                                          seriesListTiLeDatKham.isNotEmpty
                                      ? PieChart(
                                          dataMap: seriesListTiLeDatKham,
                                          animationDuration:
                                              const Duration(milliseconds: 800),
                                          chartLegendSpacing: 32.0,
                                          chartRadius: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.7,
                                          chartValuesOptions:
                                              ChartValuesOptions(
                                            showChartValues: true,
                                            showChartValuesInPercentage: true,
                                            chartValueBackgroundColor:
                                                Colors.grey[200],
                                            chartValueStyle:
                                                defaultChartValueStyle.copyWith(
                                              color: Colors.blueGrey[900]
                                                  .withOpacity(0.9),
                                            ),
                                          ),
                                          colorList: colorList,
                                          legendOptions: const LegendOptions(
                                            legendPosition:
                                                LegendPosition.bottom,
                                          ),
                                        )
                                      /*charts.PieChart(
                                            seriesListTiLeDatKham,
                                            animate: true,
                                            behaviors: [
                                              charts.InitialSelection(
                                                selectedDataConfig: [
                                                  charts.SeriesDatumConfig('Sales', 0),
                                                ],
                                              ),
                                              charts.DatumLegend(
//                                        position: charts.BehaviorPosition.top,
                                                horizontalFirst: false,
                                                cellPadding: EdgeInsets.only(right: 4.0, bottom: 4.0),
                                                showMeasures: true,
//                                                  legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
                                                measureFormatter: (num value) {
                                                  return value == null ? '-' : '${value}';
                                                },
                                              ),
                                            ],
                                          )*/
                                      : const SizedBox(
                                          width: 50,
                                          height: 50,
                                        ))
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: const <Widget>[
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'TL bệnh nhân đến khám',
                                      style: Constants.styleTextTitleBlueColor,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                  width: 200,
                                  height: 250,
                                  child: seriesListTiLeDenKham != null &&
                                          seriesListTiLeDenKham.isNotEmpty
                                      ? PieChart(
                                          dataMap: seriesListTiLeDenKham,
                                          animationDuration:
                                              const Duration(milliseconds: 800),
                                          chartLegendSpacing: 32.0,
                                          chartRadius: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.7,
                                          chartValuesOptions:
                                              ChartValuesOptions(
                                            showChartValuesInPercentage: true,
                                            chartValueBackgroundColor:
                                                Colors.grey[200],
                                            chartValueStyle:
                                                defaultChartValueStyle.copyWith(
                                              color: Colors.blueGrey[900]
                                                  .withOpacity(0.9),
                                            ),
                                          ),
                                          colorList: colorList,
                                          legendOptions: const LegendOptions(
                                            legendPosition:
                                                LegendPosition.bottom,
                                          ),
                                        )
                                      /*charts.PieChart(
                                            seriesListChannel,
                                            animate: true,
                                            behaviors: [
                                              charts.InitialSelection(
                                                selectedDataConfig: [
                                                  charts.SeriesDatumConfig('Sales', 0),
                                                ],
                                              ),
                                              charts.DatumLegend(
//                                  position: charts.BehaviorPosition.top,
                                                horizontalFirst: false,
                                                cellPadding: EdgeInsets.only(right: 4.0, bottom: 4.0),
                                                showMeasures: true,
                                                legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
                                                measureFormatter: (num value) {
                                                  return value == null ? '-' : '${value}';
                                                },
                                              ),
                                            ],
                                          )*/
                                      : const SizedBox(
                                          width: 50,
                                          height: 50,
                                        ))
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Divider(
                      color: HexColor.fromHex(Constants.Color_divider),
                      thickness: 10,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                )
              : const SizedBox(),

          seriesListChannel != null
              ? Column(
                  children: <Widget>[
                    Row(
                      children: const <Widget>[
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Text(
                            'Tỷ lệ đặt khám qua các kênh',
                            style: Constants.styleTextTitleBlueColor,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                        width: double.infinity,
                        height: 350,
                        child: seriesListChannel != null &&
                                seriesListChannel.isNotEmpty
                            ? PieChart(
                                dataMap: seriesListChannel,
                                animationDuration:
                                    const Duration(milliseconds: 800),
                                chartLegendSpacing: 32.0,
                                chartRadius:
                                    MediaQuery.of(context).size.width / 2.7,
                                chartValuesOptions: ChartValuesOptions(
                                  showChartValuesInPercentage: true,
                                  chartValueBackgroundColor: Colors.grey[200],
                                  chartValueStyle:
                                      defaultChartValueStyle.copyWith(
                                    color:
                                        Colors.blueGrey[900].withOpacity(0.9),
                                  ),
                                ),
                                colorList: colorList,
                                legendOptions: const LegendOptions(
                                  legendPosition: LegendPosition.bottom,
                                ),
                              )
                            : const SizedBox(
                                width: 50,
                                height: 50,
                              ))
                  ],
                )
              : const SizedBox()
//            Expanded(child: SizedBox())
        ],
      ));

  static Random random = Random();
  // ignore: unused_element
  static Color getColor() => Color.fromARGB(
      255, random.nextInt(255), random.nextInt(255), random.nextInt(255));

  loadReportAppointmentIndex(BuildContext context) async {
    try {
      setState(() {
        seriesListChannel = null;
        seriesListTiLeDatKham = null;
        seriesListTiLeDenKham = null;
      });
      AppUtil.showLoadingDialog(context);
      ApiGraphQLControllerQuery apiController = ApiGraphQLControllerQuery();

      QueryResult result = await apiController.requestReportAppointmentIndex(
          context, requestFromDate, requestToDate, null);
      String response = result.data.toString();
      AppUtil.showPrint('Response requestGetDetailPatient: ' + response);
      AppUtil.hideLoadingDialog(context);
      if (response != null) {
        var responseData = appUtil.processResponse(result);
        int code = responseData.code;
        String message = responseData.message;

        if (code == 0 && responseData.data != null) {
          String jsonData = json.encode(responseData.data);
          AppUtil.showLogFull('### jsonData: ' + jsonData);
          statisticAppointmentByIndex =
              StatisticAppointmentByIndex.fromJsonMap(jsonDecode(jsonData));

          if (statisticAppointmentByIndex != null) {
            seriesListChannel = Map();
            seriesListTiLeDatKham = Map();
            seriesListTiLeDenKham = Map();
//            seriesListChannel = [];
//            seriesListTiLeDatKham = [];
//            seriesListTiLeDenKham = [];
            setState(() {
              countDangKyKham = statisticAppointmentByIndex.total;
              countDaKham = statisticAppointmentByIndex.serves;
              countKhongKham = statisticAppointmentByIndex.cancels;

              seriesListChannel.putIfAbsent(
                  'App',
                  () => statisticAppointmentByIndex.apps != null
                      ? statisticAppointmentByIndex.apps.toDouble()
                      : 0);
              seriesListChannel.putIfAbsent(
                  'Website',
                  () => statisticAppointmentByIndex.webs != null
                      ? statisticAppointmentByIndex.webs.toDouble()
                      : 0);
              seriesListChannel.putIfAbsent(
                  'CRM',
                  () => statisticAppointmentByIndex.crms != null
                      ? statisticAppointmentByIndex.crms.toDouble()
                      : 0);
              seriesListChannel.putIfAbsent(
                  'FB Chat',
                  () => statisticAppointmentByIndex.fbchats != null
                      ? statisticAppointmentByIndex.fbchats.toDouble()
                      : 0);
              seriesListChannel.putIfAbsent(
                  'Zalo Chat',
                  () => statisticAppointmentByIndex.zalochats != null
                      ? statisticAppointmentByIndex.zalochats.toDouble()
                      : 0);
            });
            setState(() {
              //Ti le benh nhan dat kham
              seriesListTiLeDatKham.putIfAbsent(
                  'Đặt online',
                  () => statisticAppointmentByIndex.onlines != null
                      ? statisticAppointmentByIndex.onlines.toDouble()
                      : 0);
              seriesListTiLeDatKham.putIfAbsent(
                  'Đặt offline',
                  () => statisticAppointmentByIndex.onlines != null &&
                          statisticAppointmentByIndex.total != null
                      ? (statisticAppointmentByIndex.total.toDouble() -
                          statisticAppointmentByIndex.onlines.toDouble())
                      : 0);
            });
            setState(() {
              //Ti le benh nhan đến kham
              seriesListTiLeDenKham.putIfAbsent(
                  'Đến khám',
                  () => statisticAppointmentByIndex.online_approves != null
                      ? statisticAppointmentByIndex.online_approves.toDouble()
                      : 0);
              seriesListTiLeDenKham.putIfAbsent(
                  'Không khám',
                  () => statisticAppointmentByIndex.onlines != null &&
                          statisticAppointmentByIndex.online_approves != null
                      ? (statisticAppointmentByIndex.onlines -
                              statisticAppointmentByIndex.online_approves)
                          .toDouble()
                      : 0);
            });
          }
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
      AppUtil.showPrint('requestGetNewsArticles Error: ' + e.toString());
    }
  }

  TextEditingController _controllerTimeTo =
      TextEditingController(text: DateTime.now().toString());
  Widget viewSelectDayTo() => DateTimePicker(
        dateMask: 'dd/MM/yyyy',
        controller: _controllerTimeTo,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(1919),
        lastDate: DateTime.now(),
        dateLabelText: 'Đến ngày',
        calendarTitle: 'Chọn ngày Kết thúc thống kê',
        cancelText: 'Huỷ bỏ',
        confirmText: 'Xong',
        onChanged: (val) => onSaveDayTo(val),
        validator: (val) {
          onSaveDayTo(val);
          return null;
        },
        onSaved: (val) => {onSaveDayTo(val)},
      );

  onSaveDayTo(String val) {
    setState(() {
      requestToDate = DateTime.parse(val);
    });
  }

  TextEditingController _controllerTimeFrom =
      TextEditingController(text: DateTime.now().toString());
  Widget viewSelectDayFrom() => DateTimePicker(
        dateMask: 'dd/MM/yyyy',
        controller: _controllerTimeFrom,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(1919),
        lastDate: DateTime.now(),
        dateLabelText: 'Từ ngày',
        calendarTitle: 'Chọn ngày bắt đầu thống kê',
        cancelText: 'Huỷ bỏ',
        confirmText: 'Xong',
        onChanged: (val) => onSaveDayFrom(val),
        validator: (val) {
          onSaveDayFrom(val);
          return null;
        },
        onSaved: (val) => {onSaveDayFrom(val)},
      );

  onSaveDayFrom(String val) {
    setState(() {
      requestFromDate = DateTime.parse(val);
    });
  }
}

class StatisticData {
  final String title;
  final int value;
  final String colorVal;

  StatisticData(this.title, this.value, this.colorVal);
}
