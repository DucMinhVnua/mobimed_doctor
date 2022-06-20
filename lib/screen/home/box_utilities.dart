import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/constant.dart';
import '../hospital/screen_hospital_appoinment.dart';
import '../house/screen_house_appoinment.dart';
import '../house/screen_house_medical.dart';
import '../house/screen_house_my_appointment.dart';
import '../patient/ScreenDSBenhNhan.dart';
import 'ScreenThongKe.dart';

class BoxUtilities extends StatelessWidget {
  BuildContext context;
  final GlobalKey<ScaffoldState> scaffoldKey;

  BoxUtilities({Key key, this.context, this.scaffoldKey}) : super(key: key);

  List<BoxUtilitiesData> iconsList = BoxUtilitiesData.items;

  void onClickHospitalAppointment() {
    Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) => const ScreenHospitalAppoinment()),
    );
  }

  void onClickHouseAppointment() {
    // Navigator.push(
    //   context,
    //   CupertinoPageRoute(builder: (context) => const ScreenHouseAppoinment()),
    // );
  }

  void onClickOnlineAppointment() {
    // Navigator.push(
    //   context,
    //   CupertinoPageRoute(builder: (context) => const ScreenHouseAppoinment()),
    // );
  }
  void onClickMedical() {
    // Navigator.push(
    //   context,
    //   CupertinoPageRoute(builder: (context) =>  ScreenHouseMedical()),
    // );
  }

  void onClickPatient() {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => const ScreenDSBenhNhan()),
    );
  }

  void onClickTicket() {
    Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) => const ScreenHouseMyAppointment()),
    );
  }

  void onClickDoanhThu() {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => const ScreenThongKe()),
    );
  }

  @override
  Widget build(BuildContext context) => Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            rowIconView(),
            rowIconView1(),
            rowIconView2(),
          ]);

  Widget rowIconView() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          iconView(iconsList[0], onClickHospitalAppointment),
          iconView(iconsList[1], onClickHouseAppointment)
        ],
      );
  Widget rowIconView1() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          iconView(iconsList[2], onClickOnlineAppointment),
          iconView(iconsList[3], onClickTicket)
        ],
      );
  Widget rowIconView2() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          iconView(iconsList[4], onClickPatient),
          iconView(iconsList[5], onClickDoanhThu)
        ],
      );

  TextStyle styleText = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w800,
      letterSpacing: 0,
      fontFamily: Constants.fontName,
      fontSize: 30);

  Widget iconView(BoxUtilitiesData item, Function onClick) => Expanded(
      child: InkWell(
          highlightColor: Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          onTap: onClick,
          child: Container(
            color: item.color,
            padding: const EdgeInsets.only(top: 10, bottom: 5, left: 8),
            height: 100,
            width: double.infinity,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(item.imagePath,
                          width: 60, height: 60, color: Colors.white),
                      const SizedBox(width: 15),
                      Text('  ', style: styleText),
                    ],
                  ),
                  Text(
                    item.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0,
                        fontFamily: Constants.fontName,
                        fontSize: 12),
                  )
                ]),
          )));
}

class BoxUtilitiesData {
  BoxUtilitiesData({this.imagePath = '', this.name = '', this.color});

  String imagePath, name;
  Color color;

  static List<BoxUtilitiesData> items = <BoxUtilitiesData>[
    BoxUtilitiesData(
        imagePath: 'assets/images/utilities_hospital.png',
        name: 'QUẢN LÝ KHÁM TẠI BỆNH VIỆN',
        color: const Color(0xFF7FBC00)),
    BoxUtilitiesData(
        imagePath: 'assets/images/utilities_home.png',
        name: 'QUẢN LÝ DỊCH VỤ Y TẾ TẠI NHÀ',
        color: const Color(0xFFEF7E29)),
    BoxUtilitiesData(
        imagePath: 'assets/images/utilities_online.png',
        name: 'QUẢN LÝ KHÁM TRỰC TUYẾN',
        color: const Color(0xFFFEB74B)),
    BoxUtilitiesData(
        imagePath: 'assets/images/utilities_medical.png',
        name: 'QUẢN LÝ PHIẾU KHÁM',
        color: const Color(0xFFA28EEC)),
    BoxUtilitiesData(
        imagePath: 'assets/images/utilities_patient.png',
        name: 'QUẢN LÝ BỆNH NHÂN',
        color: const Color(0xFF69DFBF)),
    BoxUtilitiesData(
        imagePath: 'assets/images/utilities_money.png',
        name: 'QUẢN LÝ DOANH THU',
        color: const Color(0xFFFB80BA))
  ];
}
