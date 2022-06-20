import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/constant.dart';

class BoxMedical extends StatefulWidget {
  const BoxMedical({Key key}) : super(key: key);

  @override
  _BoxMedicalState createState() => _BoxMedicalState();
}

class _BoxMedicalState extends State<BoxMedical> {
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
        height: 138,
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
            // padding:
            //     const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
            decoration: BoxDecoration(
              color: Constants.white,
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              border: Border.all(color: Constants.colorTextHint),
            ),
            height: 138,
            width: 245,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  padding: const EdgeInsets.only(
                      left: 5, right: 5, top: 5, bottom: 5),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(item?.avatar),
                                const SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item?.name,
                                        style: const TextStyle(
                                            color: Constants.colorText,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: Constants.fontName,
                                            fontSize: 13)),
                                    Text(
                                        '${getYear(item.birthday)} tuổi - ${getSex(item?.sex)}',
                                        style: textStyle),
                                  ],
                                )
                              ],
                            ),
                            Image.asset(item?.imgType)
                          ],
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            const Icon(Icons.calendar_month,
                                color: Constants.colorTextHint, size: 12),
                            const SizedBox(width: 3),
                            Text(
                                'Ngày khám: ${DateFormat('dd/MM/yyyy HH:mm').format(item?.createDay)}',
                                style: textStyle),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined,
                                color: Constants.colorTextHint, size: 12),
                            const SizedBox(width: 3),
                            Text(item?.address, style: textStyle),
                          ],
                        ),
                      ])),
              InkWell(
                  highlightColor: Colors.transparent,
                  onTap: () {
                    onClickDetail(item);
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        color: Constants.colorMain,
                        borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(5)),
                        border: Border.all(color: Constants.colorMain),
                      ),
                      height: 35,
                      width: double.infinity,
                      child: const Center(
                          child: Text('TIẾP NHẬN',
                              style: TextStyle(
                                  color: Constants.white,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: Constants.fontName,
                                  fontSize: 16)))))
            ])));
  }

  TextStyle textStyle = const TextStyle(
      color: Constants.colorTextHint,
      fontWeight: FontWeight.w300,
      fontFamily: Constants.fontName,
      fontSize: 11);
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
  String name, address, avatar, imgType;
  DateTime createDay, birthday;
  int sex;

  PatientData();

  static String dateStart = '22-04-2002 05:57:58 PM';

  static List<PatientData> item = <PatientData>[
    PatientData()
      ..imgType = 'assets/images/icn_home.png'
      ..avatar = 'assets/images/icon_avatar.png'
      ..name = 'Nguyễn Minh Hằng'
      ..address = '1234567890'
      ..birthday = DateFormat('dd-MM-yyyy hh:mm:ss a').parse(dateStart)
      ..createDay = DateFormat('dd-MM-yyyy hh:mm:ss a').parse(dateStart)
      ..sex = 1,
    PatientData()
      ..imgType = 'assets/images/icn_home.png'
      ..avatar = 'assets/images/icon_avatar.png'
      ..name = 'Nguyễn Minh Hằng'
      ..address = '1234567890'
      ..birthday = DateFormat('dd-MM-yyyy hh:mm:ss a').parse(dateStart)
      ..createDay = DateFormat('dd-MM-yyyy hh:mm:ss a').parse(dateStart)
      ..sex = 1,
    PatientData()
      ..imgType = 'assets/images/icn_home.png'
      ..avatar = 'assets/images/icon_avatar.png'
      ..name = 'Nguyễn Minh Hằng'
      ..address = '1234567890'
      ..birthday = DateFormat('dd-MM-yyyy hh:mm:ss a').parse(dateStart)
      ..createDay = DateFormat('dd-MM-yyyy hh:mm:ss a').parse(dateStart)
      ..sex = 1,
    PatientData()
      ..imgType = 'assets/images/icn_home.png'
      ..avatar = 'assets/images/icon_avatar.png'
      ..name = 'Nguyễn Minh Hằng'
      ..address = '1234567890'
      ..birthday = DateFormat('dd-MM-yyyy hh:mm:ss a').parse(dateStart)
      ..createDay = DateFormat('dd-MM-yyyy hh:mm:ss a').parse(dateStart)
      ..sex = 1,
    PatientData()
      ..imgType = 'assets/images/icn_home.png'
      ..avatar = 'assets/images/icon_avatar.png'
      ..name = 'Nguyễn Minh Hằng'
      ..address = '1234567890'
      ..birthday = DateFormat('dd-MM-yyyy hh:mm:ss a').parse(dateStart)
      ..createDay = DateFormat('dd-MM-yyyy hh:mm:ss a').parse(dateStart)
      ..sex = 1,
  ];
}
