import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/AppUtil.dart';
import '../../utils/constant.dart';
import '../manage_appointment/ScreenQLDatKhamContainer.dart';
import '../manage_conclusion/ScreenQLKhamBenhContainer.dart';
import '../manage_indication/ScreenQLChiDinhContainer.dart';
import '../manage_prescription/ScreenQLDonThuoc.dart';

class ScreenHospitalAppoinment extends StatefulWidget {
  const ScreenHospitalAppoinment({Key key}) : super(key: key);

  @override
  _ScreenHospitalAppoinmentState createState() =>
      _ScreenHospitalAppoinmentState();
}

class _ScreenHospitalAppoinmentState extends State<ScreenHospitalAppoinment>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<IconHospitalData> items = IconHospitalData.items;

  @override
  void initState() {
    super.initState();
  }

  Widget viewIcon(int index, Function onClick) {
    final IconHospitalData item = items[index];
    return GestureDetector(
        onTap: onClick,
        child: Container(
            height: 85,
            width: double.infinity,
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 12, bottom: 12),
            color: item.color,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(item.name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0,
                            fontFamily: Constants.fontName,
                            fontSize: 16)),
                    const Padding(
                        padding: EdgeInsets.only(left: 50),
                        child: Text(' ',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0,
                                fontFamily: Constants.fontName,
                                fontSize: 30)))
                  ],
                ),
                Image.asset(item.imagePath, color: Colors.white),
              ],
            )));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      key: _scaffoldKey,
      appBar: AppUtil.customAppBar(context, 'KHÁM TẠI BỆNH VIỆN'),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Column(
        children: [
          viewIcon(0, onClickAppoinment),
          viewIcon(1, onClickConclusion),
          viewIcon(2, onClickIndication),
          viewIcon(3, () {}),
          viewIcon(4, onClickPrescription),
          viewIcon(5, () {}),
        ],
      )));

  void onClickAppoinment() {
    Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) => const ScreenQLDatKhamContainer()),
    );
  }

  void onClickConclusion() {
    Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) => const ScreenQLKhamBenhContainer()),
    );
  }

  void onClickIndication() {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => ScreenQLChiDinhContainer()),
    );
  }

  void onClickPrescription() {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => ScreenQLDonThuoc()),
    );
  }
}

class IconHospitalData {
  IconHospitalData();
  String imagePath, name;
  Color color;

  static List<IconHospitalData> items = <IconHospitalData>[
    IconHospitalData()
      ..imagePath = 'assets/icons/icn_booking.png'
      ..name = 'QUẢN LÝ ĐẶT KHÁM'
      ..color = const Color(0xFF7FBC00),
    IconHospitalData()
      ..imagePath = 'assets/icons/icn_kham_benh.png'
      ..name = 'QUẢN LÝ KHÁM BỆNH'
      ..color = const Color(0xFF54C1FB),
    IconHospitalData()
      ..imagePath = 'assets/icons/icn_xet_nghiem.png'
      ..name = 'QUẢN LÝ XÉT NGHIỆM'
      ..color = const Color(0xFFFEB74B),
    IconHospitalData()
      ..imagePath = 'assets/icons/icn_cd_img.png'
      ..name = 'QUẢN LÝ CĐ HÌNH ẢNH'
      ..color = const Color(0xFFA28EEC),
    IconHospitalData()
      ..imagePath = 'assets/icons/icn_don_thuoc.png'
      ..name = 'QUẢN LÝ ĐƠN THUỐC'
      ..color = const Color(0xFF69DFBF),
    IconHospitalData()
      ..imagePath = 'assets/icons/icn_kl_kham.png'
      ..name = 'QUẢN LÝ KẾT LUẬN KHÁM'
      ..color = const Color(0xFFFB80BA)
  ];
}
