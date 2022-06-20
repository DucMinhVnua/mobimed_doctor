import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:DoctorApp/extension/HexColor.dart';
import 'package:DoctorApp/model/OBWheelData.dart';
import 'package:DoctorApp/utils/AppStyle.dart';
import 'package:DoctorApp/utils/AppUtil.dart';
import 'package:DoctorApp/utils/Constant.dart';

class ScreenOBWheelHistory extends StatefulWidget {
  ScreenOBWheelHistory({
    Key key,
  }) : super(key: key);

  @override
  _ScreenOBWheelHistoryState createState() => _ScreenOBWheelHistoryState();
}

class _ScreenOBWheelHistoryState extends State<ScreenOBWheelHistory> {
  // ignore: unused_field
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var formatter = new DateFormat(DATE_FORMAT);
  int page = 0, pageSize = 18;
  AppUtil appUtil = new AppUtil();
  Constants constants = new Constants();

//  List<int> items = List.generate(10, (i) => i);
  List<OBWheelData> items = [];
  ScrollController _scrollController = new ScrollController();
  bool isPerformingRequest = false;

  @override
  void initState() {
    super.initState();
    _getMoreData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
//        _getMoreData();
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
    items.clear();
    _getMoreData();
  }

  _getMoreData() async {
//    getArticles();
    if (!isPerformingRequest) {
      setState(() => isPerformingRequest = true);
      try {
        List<OBWheelData> tmpArray = await appUtil.getOBWheelHistory();
        setState(() {
          items = tmpArray;
        });
      } on Exception catch (e) {
        AppUtil.showPrint('getOBWheelHistory Error: ' + e.toString());
      }

      if (items.isEmpty) {
//        double edge = 10.0;
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
      setState(() {
//        items.addAll(newEntries);
        isPerformingRequest = false;
        page++;
      });

      //hide loading
//      appUtil.hideDialog(context);
    }
  }

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

//  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
//        appBar: appUtil.getAppBar(new Text("Lịch sử đặt khám")),
        backgroundColor: Color(0xFFF2F2F2),
        body: new Container(
            padding: EdgeInsets.only(top: 10),
            child: new Center(
              child: new RefreshIndicator(
                onRefresh: reloadData,
                child: ListView.builder(
                  itemCount: items.length + 1,
                  itemBuilder: (context, index) {
                    if (index == items.length) {
                      return _buildProgressIndicator();
                    } else {
//                      var tmpItem = items[index];
//                      if(tmpItem.)
                      OBWheelData appointmentData = items[index];
//                      AppointmentData appointmentData = tmpData.appointment;
                      if (appointmentData != null) {
                        return new GestureDetector(
                            onTap: () async {
                              try {} catch (e) {
                                AppUtil.showPrint(e.toString());
                              }
//                  Navigator.pushNamed(context, "myRoute");
                            },
                            child: Container(
//              margin: new EdgeInsets.all(8.0), // Or set whatever you want
//              color: Colors.white,
                                margin: EdgeInsets.only(
                                    left: 10, right: 10, bottom: 10),
                                padding: EdgeInsets.all(8),
                                decoration: new BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    (appointmentData?.dateCalculate != null)
                                        ? Text(
                                            "Lúc: " +
                                                DateFormat(Constants
                                                        .FORMAT_DATETIME)
                                                    .format(appointmentData
                                                        .dateCalculate),
                                            style: TextStyle(
                                                color: HexColor.fromHex(
                                                    Constants.Color_maintext),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w300))
                                        : SizedBox(),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    (appointmentData?.dateLMP != null)
                                        ? Text(
                                            "Ngày kinh cuối: " +
                                                DateFormat(Constants
                                                        .FORMAT_DATEONLY)
                                                    .format(appointmentData
                                                        .dateLMP),
                                            style: TextStyle(
                                                color: HexColor.fromHex(
                                                    Constants.Color_maintext),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal))
                                        : Text("Ngày kinh cuối: ",
                                            style: TextStyle(
                                                color: HexColor.fromHex(
                                                    Constants.Color_maintext),
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold)),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    (appointmentData?.dateLMP != null)
                                        ? Text(
                                            "Ngày thụ thai: " +
                                                DateFormat(Constants
                                                        .FORMAT_DATEONLY)
                                                    .format(appointmentData
                                                        .dateConception),
                                            style: TextStyle(
                                                color: HexColor.fromHex(
                                                    Constants.Color_maintext),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal))
                                        : Text("Ngày thụ thai: ",
                                            style: TextStyle(
                                                color: HexColor.fromHex(
                                                    Constants.Color_maintext),
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold)),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    (appointmentData?.dateDateEDD != null)
                                        ? Text(
                                            "Ngày dự sinh: " +
                                                DateFormat(Constants
                                                        .FORMAT_DATEONLY)
                                                    .format(appointmentData
                                                        .dateDateEDD),
                                            style: TextStyle(
                                                color: HexColor.fromHex(
                                                    Constants.Color_maintext),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal))
                                        : Text("Ngày dự sinh: ",
                                            style: TextStyle(
                                                color: HexColor.fromHex(
                                                    Constants.Color_maintext),
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold)),
                                  ],
                                )));
                      } else {
                        AppUtil.showPrint(
                            "### appointmentData KHÔNG CÓ DỮ LIỆU ");
//              AppUtil.showPrint(appointmentData.fullName + "/" + appointmentData.phoneNumber);
                        return SizedBox(
                          height: 0,
                        );
                      }
//                      AppUtil.showPrint(appointmentData.fullName +
//                          "/" +
//                          appointmentData.phoneNumber);
////            return ListTile(title: new Text("Number $index"));

                    }
                  },
                  controller: _scrollController,
                ),
              ),
            )));
  }
}
