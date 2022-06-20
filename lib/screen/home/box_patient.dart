import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/AppUtil.dart';
import '../../utils/constant.dart';

class BoxPatient extends StatefulWidget {
  const BoxPatient({Key key}) : super(key: key);

  @override
  _BoxPatientState createState() => _BoxPatientState();
}

class _BoxPatientState extends State<BoxPatient> {
  List<PatientData> items = PatientData.item;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 100,
        width: double.infinity,
        child: items.isNotEmpty
            ? ListView.builder(
                padding:
                    const EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 5),
                itemCount: items.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) =>
                    iconView(index),
              )
            : const SizedBox(),
      );
  Widget iconView(int index) {
    if (index >= items.length) {
      return const SizedBox();
    }
    final PatientData item = items[index];
    return InkWell(
        highlightColor: Colors.transparent,
        onTap: () {
          onClickDetail(item);
        },
        child: Container(
            margin: const EdgeInsets.only(top: 3, bottom: 3, right: 20),
            decoration: BoxDecoration(
              color: Constants.colorShadow,
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              border: Border.all(color: Constants.colorShadow),
            ),
            height: 95,
            width: 222,
            child: Row(
              children: [
                AppUtil.widgetTimeClock(item?.createDay),
                const SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(item?.name, style: textStyle),
                    Text(
                        '${getYear(item.birthday)} tuổi - ${getSex(item?.sex)}',
                        style: textStyle),
                    Text(item?.phone, style: textStyle),
                  ],
                )
              ],
            )));
  }

  TextStyle textStyle = const TextStyle(
      color: Constants.colorTextHint,
      fontWeight: FontWeight.w600,
      fontFamily: Constants.fontName,
      fontSize: 14);
  String getYear(DateTime birthday) =>
      (DateTime.now().year - birthday.year).toString();
  String getSex(int sex) => sex == 0 ? 'Nữ' : 'Nam';

  void onClickDetail(PatientData item) {
    // Navigator.push(
    //   context,
    //   CupertinoPageRoute(
    //       builder: (context) => ScreenHomePackDetail(homeMedicalPacks: item)),
    // );
  }
}

class PatientData {
  String name, phone;
  DateTime createDay, birthday;
  int sex;

  PatientData();

  static String dateStart = '22-04-2002 05:57:58 PM';

  static List<PatientData> item = <PatientData>[
    PatientData()
      ..name = 'Nguyễn Minh Hằng'
      ..phone = '1234567890'
      ..birthday = DateFormat('dd-MM-yyyy hh:mm:ss a').parse(dateStart)
      ..createDay = DateFormat('dd-MM-yyyy hh:mm:ss a').parse(dateStart)
      ..sex = 1,
    PatientData()
      ..name = 'bn2'
      ..phone = '1234567890'
      ..birthday = DateFormat('dd-MM-yyyy hh:mm:ss a').parse(dateStart)
      ..createDay = DateFormat('dd-MM-yyyy hh:mm:ss a').parse(dateStart)
      ..sex = 1,
    PatientData()
      ..name = 'bn3'
      ..phone = '1234567890'
      ..birthday = DateFormat('dd-MM-yyyy hh:mm:ss a').parse(dateStart)
      ..createDay = DateFormat('dd-MM-yyyy hh:mm:ss a').parse(dateStart)
      ..sex = 1,
    PatientData()
      ..name = 'bn4'
      ..phone = '1234567890'
      ..birthday = DateFormat('dd-MM-yyyy hh:mm:ss a').parse(dateStart)
      ..createDay = DateFormat('dd-MM-yyyy hh:mm:ss a').parse(dateStart)
      ..sex = 1,
    PatientData()
      ..name = 'bn5'
      ..phone = '1234567890'
      ..birthday = DateFormat('dd-MM-yyyy hh:mm:ss a').parse(dateStart)
      ..createDay = DateFormat('dd-MM-yyyy hh:mm:ss a').parse(dateStart)
      ..sex = 1,
  ];
}
