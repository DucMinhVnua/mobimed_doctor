import 'package:flutter/material.dart';

import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';
import '../../utils/DialogUtil.dart';
import 'house_appoinmrnt_data.dart';
import 'request_house_appoinment.dart';
import 'request_house_medical.dart';
import 'screen_house_medical.dart';

class ScreenHouseAppoinmentDetail extends StatefulWidget {
  String idAppoinment;
  ScreenHouseAppoinmentDetail({Key key, this.idAppoinment}) : super(key: key);

  @override
  _ScreenHouseAppoinmentDetailState createState() =>
      _ScreenHouseAppoinmentDetailState();
}

class _ScreenHouseAppoinmentDetailState
    extends State<ScreenHouseAppoinmentDetail> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  HomeBookHistoryData data;
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    final RequestHouseAppoinment request = RequestHouseAppoinment();
    final HomeBookHistoryData respone =
        await request.requestGetDetail(context, widget.idAppoinment);
    if (respone != null) {
      setState(() => {data = respone});
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      key: _scaffoldKey,
      appBar: AppUtil.customAppBar(context, 'KHÁM TẠI NHÀ CHI TIẾT'),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Column(
        children: [
          data != null && data.patientInfo != null
              ? viewPatient()
              : const SizedBox(),
          data != null && data.servicesInfo != null
              ? viewServices()
              : const SizedBox()
        ],
      )));

  Widget viewServices() => Column(
        children: [
          const Text('Dịch vụ',
              style: TextStyle(
                  color: Constants.colorText,
                  fontWeight: FontWeight.w800,
                  fontFamily: Constants.fontName,
                  fontSize: Constants.Size_text_title)),
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: data.servicesInfo.length,
              itemBuilder: (BuildContext context, int index) =>
                  containerItem(data.servicesInfo[index]))
        ],
      );

  Widget containerItem(HomeBookServiceInfo itemData) => Container(
      decoration: BoxDecoration(
          // color: Colors.blueAccent,
          color: Colors.white,
          // borderRadius: BorderRadius.all(Radius.circular(8)),
          boxShadow: [
            BoxShadow(
                color: Constants.colorText.withOpacity(0.3),
                offset: const Offset(1.1, 1.1),
                spreadRadius: 0.3,
                blurRadius: 0.3)
          ]),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(top: 5),
      child: Column(children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AppUtil.widgetTime(itemData.servingTime),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(children: [
                    (itemData.name != null)
                        ? Expanded(
                            child: Text(itemData.name,
                                style: Constants.styleTextNormalBlueColorBold))
                        : const SizedBox(),
                    // AppUtil.parseAppoinmentState(itemData.state)
                  ]),
                  itemData.price != null
                      ? Row(
                          children: [
                            Text(
                                'Giá: ${AppUtil.convertMoney(itemData.price) ?? 'Chưa có'}',
                                style: Constants.styleTextNormalSubColor),
                          ],
                        )
                      : const SizedBox(),
                ],
              ),
            )
          ],
        ),
        // viewService(itemData)
      ]));

  Widget viewService(HomeBookServiceDetail itemData) => Column(
        children: [
          const SizedBox(height: 8),
          const Text(
            'Chi tiết dịch vụ trong gói',
            style: TextStyle(
                color: Constants.colorText,
                fontWeight: FontWeight.w800,
                fontFamily: Constants.fontName,
                fontSize: 15),
          ),
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: itemData.details.length,
              itemBuilder: (BuildContext context, int index) =>
                  viewItemService(itemData.details[index]))
        ],
      );

  Widget viewItemService(ServiceBookDetail item) => Container(
      height: 65,
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(children: [
        // const SizedBox(height: 5),
        Row(children: [
          Text(
            item.name,
            style: const TextStyle(
                color: Constants.colorText,
                fontWeight: FontWeight.w500,
                fontFamily: Constants.fontName,
                fontSize: 14),
          )
        ]),
        const SizedBox(height: 5),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          buttonText('Mô tả dịch vụ', () {
            serviceDetail(item);
          }),
          Text(
            'Giá: ${AppUtil.convertMoney(item.price)}',
            style: const TextStyle(
                color: Constants.colorTextHint,
                fontWeight: FontWeight.w200,
                fontFamily: Constants.fontName,
                fontSize: 13),
          )
        ]),
        const Divider(
          color: Constants.colorTextHint,
        ),
      ]));

  Future<void> serviceDetail(ServiceBookDetail item) async {
    await DialogUtil.showDialogWithTitle(_scaffoldKey, context,
        dialogTitle: item.name,
        dialogMessage: item.description,
        okBtnFunction: () {});
  }

  Widget viewPatient() => Column(
        children: [
          const Text('Bệnh nhân',
              style: TextStyle(
                  color: Constants.colorText,
                  fontWeight: FontWeight.w800,
                  fontFamily: Constants.fontName,
                  fontSize: Constants.Size_text_title)),
          data.patientInfo != null && data.patientInfo.isNotEmpty
              ? ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: data.patientInfo.length,
                  itemBuilder: (BuildContext context, int index) =>
                      viewItemPatient(data.patientInfo[index]))
              : const SizedBox()
        ],
      );

  Widget viewItemPatient(HomePatientBook item) => Container(
      decoration: BoxDecoration(
          color: Constants.white,
          // borderRadius: const BorderRadius.all(Radius.circular(15)),
          border: Border.all(color: Constants.colorTextHint)),
      margin: const EdgeInsets.only(top: 8, bottom: 5),
      padding: const EdgeInsets.only(top: 8, bottom: 5, left: 12, right: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Column(
            children: [
              viewRowPatient('Tên:', item.name),
              viewRowPatient('SĐT:', item.phone),
              viewRowPatient('Địa chỉ:', item.address),
              viewRowPatient('Trạng thái:', checkTicketState(item))
            ],
          )),
          checkTicket(item)
              ? viewBtn(() {
                  onClickViewTicket(item);
                }, Colors.green, 'Xem phiếu')
              : viewBtn(() {
                  onClickCreateMedical(item);
                }, Constants.colorMain, 'Tạo phiếu')
        ],
      ));

  void onClickViewTicket(HomePatientBook item) {
    MedicalTicket ticket;
    for (final MedicalTicket itemTicket in data.tickets) {
      if (itemTicket.patientInfo.id == item.id) {
        ticket = itemTicket;
        break;
      }
    }
    final result = Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ScreenHouseMedical(
                ticket: ticket, services: data.servicesInfo)));

    ScaffoldMessenger.of(context).setState(() {
      getData();
    });
  }

  bool checkTicket(HomePatientBook item) {
    if (data?.tickets == null) {
      return false;
    }
    for (final MedicalTicket itemTicket in data.tickets) {
      if (itemTicket.patientInfo.id == item.id) {
        return true;
      }
    }
    return false;
  }

  String checkTicketState(HomePatientBook item) {
    if (data?.tickets == null) {
      return 'chưa có';
    }
    for (final MedicalTicket itemTicket in data.tickets) {
      if (itemTicket.patientInfo.id == item.id) {
        if (itemTicket.state == 0) {
          return 'Đang phục vụ';
        }

        if (itemTicket.state == 1) {
          return 'Đã hoàn thành';
        }

        if (itemTicket.state == 2) {
          return 'Đã huỷ';
        }

        return 'chưa có';
      }
    }
    return 'chưa có';
  }

  Widget viewBtn(Function clickButton, Color color, String name) =>
      GestureDetector(
          onTap: clickButton,
          child: SizedBox(
              height: 35,
              width: 85,
              child: Card(
                color: color,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                elevation: 6,
                child: Center(
                  child: Text(
                    name,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: Constants.fontName,
                      fontSize: 13,
                      letterSpacing: 0,
                      color: Constants.white,
                    ),
                  ),
                ),
              )));

  Future<void> onClickCreateMedical(HomePatientBook item) async {
    final RequesstHouseMedical request = RequesstHouseMedical();

    final MedicalTicket result =
        await request.requestTicketAdd(context, data.id, item.id);
    if (result != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ScreenHouseMedical(
                  ticket: result, services: data.servicesInfo)));
    }
  }

  Widget viewRowPatient(String name, String value) => Row(children: [
        SizedBox(
            width: 75,
            child: Text(name,
                style: const TextStyle(
                    color: Constants.colorTextHint,
                    fontWeight: FontWeight.normal,
                    fontFamily: Constants.fontName,
                    fontSize: 13))),
        Text(value,
            style: const TextStyle(
                color: Constants.colorText,
                fontWeight: FontWeight.normal,
                fontFamily: Constants.fontName,
                fontSize: 13)),
      ]);

  Widget buttonText(String text, Function press) => GestureDetector(
      onTap: press,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Text(
          text,
          style: const TextStyle(
              decoration: TextDecoration.underline,
              fontStyle: FontStyle.italic,
              color: Constants.colorTextHint,
              fontWeight: FontWeight.normal,
              fontFamily: Constants.fontName,
              fontSize: 13),
        ),
      ));
}
