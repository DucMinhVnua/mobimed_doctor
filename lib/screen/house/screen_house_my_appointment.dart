import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';
import 'house_appoinmrnt_data.dart';
import 'request_house_appoinment.dart';
import 'screen_house_appoinment_detail.dart';

class ScreenHouseMyAppointment extends StatefulWidget {
  const ScreenHouseMyAppointment({Key key}) : super(key: key);

  @override
  _ScreenHouseMyAppointmentState createState() =>
      _ScreenHouseMyAppointmentState();
}

class _ScreenHouseMyAppointmentState extends State<ScreenHouseMyAppointment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<HomeBookHistoryData> items = [];
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    final RequestHouseAppoinment request = RequestHouseAppoinment();
    final List<HomeBookHistoryData> result =
        await request.requestGetMyAppointment(context);
    if (result != null) {
      setState(() {
        items = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        key: _scaffoldKey,
        appBar: AppUtil.customAppBar(context, 'PHIẾU KHÁM'),
        body: SingleChildScrollView(
          child: items != null && items.isNotEmpty
              ? ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) =>
                      viewItem(items[index]))
              : const SizedBox(),
        ),
      );

  Widget viewItem(HomeBookHistoryData item) => GestureDetector(
      onTap: () {
        onClickDetail(item.id);
      },
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              item?.servingTime != null
                  ? AppUtil.widgetTimeClock(item?.servingTime)
                  : const SizedBox(),
              const SizedBox(width: 8),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  viewRowPatient('BN:', getName(item?.patientInfo)),
                  const SizedBox(height: 3),
                  viewRowPatient('SĐT:', item?.patientInfo[0]?.phone),
                  const SizedBox(height: 3),
                  viewRowPatient('Địa chỉ:', item?.patientInfo[0]?.address)
                ],
              ))
              // item.patientInfo != null && item.patientInfo.isNotEmpty
              //     ? ListView.builder(
              //         physics: const NeverScrollableScrollPhysics(),
              //         shrinkWrap: true,
              //         itemCount: item.patientInfo.length,
              //         itemBuilder: (BuildContext context, int index) =>
              //             viewItemPatient(item.patientInfo[index], item))
              //     : const SizedBox(),
            ],
          ),
          const Divider(
            color: Constants.colorTextHint,
          ),
        ],
      ));

  String getName(List<HomePatientBook> items) {
    if (items.isNotEmpty) {
      String name = items[0].name;
      for (int i = 1; i < items.length; i++) {
        name += ', ' + items[i].name;
      }
      return name;
    } else {
      return '';
    }
  }

  Widget viewItemPatient(HomePatientBook item, HomeBookHistoryData book) =>
      Container(
          // decoration: BoxDecoration(
          //     color: Constants.white,
          //     borderRadius: const BorderRadius.all(Radius.circular(15)),
          //     border: Border.all(color: Constants.colorTextHint)),
          // margin: const EdgeInsets.only(top: 5, bottom: 3, left: 5, right: 5),
          padding:
              const EdgeInsets.only(top: 8, bottom: 5, left: 12, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  viewRowPatient('Tên:', item.name),
                  viewRowPatient('SĐT:', item.phone),
                  viewRowPatient('Dịa chỉ:', item.address)
                ],
              ),
            ],
          ));

  Widget viewRowPatient(String name, String value) => Row(children: [
        SizedBox(
            width: 55,
            child: Text(name,
                style: const TextStyle(
                    color: Constants.colorTextHint,
                    fontWeight: FontWeight.normal,
                    fontFamily: Constants.fontName,
                    fontSize: 13))),
        Expanded(
            child: Text(value,
                style: const TextStyle(
                    color: Constants.colorText,
                    fontWeight: FontWeight.w500,
                    fontFamily: Constants.fontName,
                    fontSize: 13)))
      ]);

  Future<void> onClickDetail(String idAppoinment) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) =>
                ScreenHouseAppoinmentDetail(idAppoinment: idAppoinment)));
  }
}
