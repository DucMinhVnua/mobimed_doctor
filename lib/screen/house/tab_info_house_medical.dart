import 'package:flutter/material.dart';

import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';
import 'house_appoinmrnt_data.dart';

class TabInfoHouseMedical extends StatelessWidget {
  HomePatientBook patientInfo;
  List<HomeBookServiceInfo> services;
  TabInfoHouseMedical({Key key}) : super(key: key);

  int money = 0;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          const Text('THÔNG TIN',
              style: TextStyle(
                  color: Constants.colorMain,
                  fontWeight: FontWeight.w600,
                  fontFamily: Constants.fontName,
                  fontSize: 15)),
          const SizedBox(height: 5),
          viewRow('Tên:', patientInfo?.name),
          divider(),
          viewRow('SĐT:', patientInfo?.phone),
          divider(),
          viewRow('Địa chỉ:', patientInfo?.address),
          divider(),
          Text('Dịch vụ đã đặt', style: styleText),
          services != null && services.isNotEmpty
              ? SizedBox(
                  height: services.length * 55.0,
                  child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(top: 10),
                      shrinkWrap: true,
                      itemCount: services.length,
                      itemBuilder: (BuildContext context, int index) =>
                          viewItem(services[index])))
              : const SizedBox(),
          const SizedBox(height: 15),
          services != null && services.isNotEmpty
              ? totalMoney()
              : const SizedBox()
        ],
      );

  Widget totalMoney() {
    money = 0;
    for (final HomeBookServiceInfo item in services) {
      money += item.price;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Tổng giá:', style: styleText),
        Text(AppUtil.convertMoney(money), style: styleTextColor)
      ],
    );
  }

  Widget viewItem(HomeBookServiceInfo item) => Column(
        children: [
          Container(
              decoration: BoxDecoration(
                  color: const Color(0xFF2D9CDB).withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              padding:
                  const EdgeInsets.only(top: 6, bottom: 6, left: 5, right: 5),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontFamily: Constants.fontName,
                      fontSize: 14,
                      letterSpacing: 0,
                      color: Constants.colorText,
                    ),
                  ))
                ],
              )),
          const SizedBox(height: 3),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const SizedBox(),
            Text(
              AppUtil.convertMoney(item.price),
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontFamily: Constants.fontName,
                fontSize: 13,
                letterSpacing: 0,
                color: Constants.colorText,
              ),
            )
          ]),
        ],
      );

  Widget divider() => const Divider(
        color: Constants.colorTextHint,
      );

  Widget viewRow(String title, String value) => Row(children: [
        SizedBox(width: 80, child: Text(title, style: styleTextHint)),
        Expanded(child: Text(value, style: styleText))
      ]);

  TextStyle styleTextHint = const TextStyle(
      // decoration: TextDecoration.underline,
      // fontStyle: FontStyle.italic,
      color: Constants.colorTextHint,
      fontWeight: FontWeight.normal,
      fontFamily: Constants.fontName,
      fontSize: 14);

  TextStyle styleText = const TextStyle(
      // decoration: TextDecoration.underline,
      // fontStyle: FontStyle.italic,
      color: Constants.colorText,
      fontWeight: FontWeight.w400,
      fontFamily: Constants.fontName,
      fontSize: 14);

  TextStyle styleTextColor = const TextStyle(
      // decoration: TextDecoration.underline,
      // fontStyle: FontStyle.italic,
      color: Constants.colorMain,
      fontWeight: FontWeight.w400,
      fontFamily: Constants.fontName,
      fontSize: 14);
}
