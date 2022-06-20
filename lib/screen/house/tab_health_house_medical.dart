import 'package:flutter/material.dart';

import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';
import '../../utils/DialogUtil.dart';
import 'house_appoinmrnt_data.dart';
import 'request_house_medical.dart';
import 'widget_button_house_medical.dart';

class TabHealthHouseMedical extends StatefulWidget {
  String idTicket;
  GlobalKey<ScaffoldState> scaffoldKey;
  BuildContext context;
  TabHealthHouseMedical(
      {Key key, this.idTicket, this.scaffoldKey, this.context})
      : super(key: key);
  @override
  TabHealthHouseMedicalState createState() => TabHealthHouseMedicalState();
}

class TabHealthHouseMedicalState extends State<TabHealthHouseMedical> {
  HealthData healthData = HealthData();
  TextEditingController controllerEditHeight = TextEditingController();
  TextEditingController controllerEditWeight = TextEditingController();
  TextEditingController controllerBodyTemperature =
      TextEditingController(); // nhiệt độ
  TextEditingController controllerPulseRate =
      TextEditingController(); // nhịp tim
  TextEditingController controllerRespirationRate =
      TextEditingController(); // nhịp thở
  TextEditingController controllerBloodPressure =
      TextEditingController(); // huyết áp

  AppUtil appUtil = AppUtil();
  @override
  void initState() {
    super.initState();
    getTicketInfo();
  }

  Future<void> getTicketInfo() async {
    final RequesstHouseMedical request = RequesstHouseMedical();
    final MedicalTicket respone =
        await request.requestTicketInfo(context, widget.idTicket);
    if (respone != null) {
      setState(() {
        healthData = respone.healthData;

        controllerEditHeight.text = healthData?.height?.toString();
        controllerEditWeight.text = healthData?.weight?.toString();
        controllerBodyTemperature.text =
            healthData?.bodyTemperature?.toString();
        controllerPulseRate.text = healthData?.pulseRate?.toString();
        controllerRespirationRate.text =
            healthData?.respirationRate?.toString();
        controllerBloodPressure.text = healthData?.bloodPressure;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          const Text('CHỈ SỐ CƠ BẢN',
              style: TextStyle(
                  color: Constants.colorMain,
                  fontWeight: FontWeight.w600,
                  fontFamily: Constants.fontName,
                  fontSize: 15)),
          const SizedBox(height: 5),
          rowInput('Chiều cao (cm):',
              viewEditText(controllerEditHeight, 'Chiều cao')),
          divider(),
          rowInput(
              'Cân nặng (kg):', viewEditText(controllerEditWeight, 'Cân nặng')),
          divider(),
          rowInput('Nhiệt độ (°C):',
              viewEditText(controllerBodyTemperature, 'Nhiệt độ')),
          divider(),
          rowInput('Nhịp tim (/phút):',
              viewEditText(controllerPulseRate, 'Nhịp tim')),
          divider(),
          rowInput('Nhịp thở (/phút):',
              viewEditText(controllerRespirationRate, 'Nhịp thở')),
          divider(),
          rowInput('Huyết áp (mmHg):',
              viewEditText(controllerBloodPressure, 'Huyết áp')),
          divider(),
          Align(
              child: WidgetButtonHouseMedical()
                ..name = 'CẬP NHẬT'
                ..onClick = onClickUpdate)
        ],
      );

  Future<void> onClickUpdate() async {
    final RequesstHouseMedical request = RequesstHouseMedical();
    final HealthData healthData = HealthData()
      ..height = int.parse(controllerEditHeight.text)
      ..weight = int.parse(controllerEditWeight.text)
      ..pulseRate = int.parse(controllerPulseRate.text)
      ..bodyTemperature = int.parse(controllerBodyTemperature.text)
      ..respirationRate = int.parse(controllerRespirationRate.text)
      ..bloodPressure = controllerBloodPressure.text.trim();
    final int respone = await request.requestTicketUpdateHealth(
        context, widget.idTicket, healthData);
    if (respone == 0) {
      // appUtil.showToastWithScaffoldState(
      //     widget.scaffoldKey, 'Cập nhật chỉ số sức khoẻ thành công!');
      await DialogUtil.showDialogCreateSuccess(
          widget.scaffoldKey, widget.context,
          messageSuccess: 'Cập nhật kết quả thành công', okBtnFunction: () {});
    }
  }

  Widget viewBtn(Function clickButton) => GestureDetector(
      onTap: clickButton, child: WidgetButtonHouseMedical()..name = 'CẬP NHẬT');

  Widget viewEditText(
          TextEditingController editingController, String hintText) =>
      TextField(
        style: styleText,
        controller: editingController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          border: InputBorder.none,
        ),
      );

  Widget divider() => const Divider(
        color: Constants.colorTextHint,
      );
  Widget rowInput(String title, Widget input) => Row(children: <Widget>[
        SizedBox(
            width: 130,
            height: 35,
            child: Padding(
                padding: const EdgeInsets.only(top: 8, left: 5, right: 5),
                child: Text(
                  title,
                  style: styleTextHint,
                ))),
        SizedBox(
          width: 130,
          height: 35,
          child: input,
        ),
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
      fontWeight: FontWeight.w500,
      fontFamily: Constants.fontName,
      fontSize: 15);
}
