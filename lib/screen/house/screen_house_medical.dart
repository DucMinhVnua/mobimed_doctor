import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';
import '../../utils/DialogUtil.dart';
import 'house_appoinmrnt_data.dart';
import 'request_house_medical.dart';
import 'screen_add_indication_house_medical.dart';
import 'screen_add_service_house_medical.dart';
import 'screen_result_ticket_service.dart';
import 'tab_health_house_medical.dart';
import 'tab_img_house_medical.dart';
import 'tab_info_house_medical.dart';
import 'tab_none_house_medical.dart';
import 'widget_button_house_medical.dart';

class ScreenHouseMedical extends StatefulWidget {
  List<HomeBookServiceInfo> services;
  MedicalTicket ticket;
  ScreenHouseMedical({Key key, this.services, this.ticket}) : super(key: key);

  @override
  _ScreenHouseMedicalState createState() => _ScreenHouseMedicalState();
}

class _ScreenHouseMedicalState extends State<ScreenHouseMedical> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget tabPatientInfo;
  MedicalTicket ticketNow;
  List<IconHouseMedical> items = IconHouseMedical.items;
  TabHealthHouseMedical tabHealth = TabHealthHouseMedical();
  TabImgHouseMedical tabImg = TabImgHouseMedical();
  TextEditingController controllerEditNote = TextEditingController();
  int index = 0;
  Widget viewMain;
  @override
  void initState() {
    tabPatientInfo = TabInfoHouseMedical()
      ..patientInfo = widget.ticket.patientInfo
      ..services = widget.services;

    viewMain = tabPatientInfo;

    ticketNow = widget.ticket;

    tabHealth = TabHealthHouseMedical()
      ..idTicket = widget.ticket.id
      ..scaffoldKey = _scaffoldKey
      ..context = context;

    tabImg = TabImgHouseMedical()
      ..idTicket = widget.ticket.id
      ..scaffoldKey = _scaffoldKey
      ..context = context;

    controllerEditNote.text = widget.ticket.note;

    super.initState();
  }

  Future<void> getTicketInfoIndication() async {
    final RequesstHouseMedical request = RequesstHouseMedical();
    final MedicalTicket respone =
        await request.requestTicketInfo(context, ticketNow.id);
    if (respone != null) {
      setState(() {
        ticketNow = respone;
        viewMain = viewIndication(ticketNow.indications);
      });
    }
  }

  Future<void> getTicketInfoService() async {
    final RequesstHouseMedical request = RequesstHouseMedical();
    final MedicalTicket respone =
        await request.requestTicketInfo(context, ticketNow.id);
    if (respone != null) {
      setState(() {
        ticketNow = respone;
        viewMain = viewServices(ticketNow.services);
      });
    }
  }

  Future<void> onClickDone() async {
    final RequesstHouseMedical request = RequesstHouseMedical();
    final MedicalTicketPrice respone =
        await request.requestTicketInfoPrice(context, ticketNow.id);
    if (respone != null) {
      await DialogUtil.showDialogConfirmYesNo(_scaffoldKey, context,
          title: 'XÁC NHẬN PHIẾU KHÁM',
          message: 'Tổng giá: ${AppUtil.convertMoney(respone.totalPrice)}',
          nameButton: 'Đồng ý', okBtnFunction: () async {
        requestDoneTicket();
      });
    }
  }

  Future<void> requestDoneTicket() async {
    final RequesstHouseMedical request = RequesstHouseMedical();
    final int respone =
        await request.requestTicketFinish(context, ticketNow.id);
    if (respone != null && respone == 0) {
      await DialogUtil.showDialogCreateSuccess(_scaffoldKey, context,
          messageSuccess: 'Hoàn thành phiếu khám thành công',
          okBtnFunction: () {});
      Navigator.pop(context);
    }
  }

  Widget viewAppBar() => AppBar(
          actions: [
            GestureDetector(
                onTap: onClickDone,
                child: Container(
                    height: double.infinity,
                    margin: const EdgeInsets.only(top: 15, bottom: 15),
                    padding: const EdgeInsets.only(left: 15, right: 12),
                    child: const Center(
                        child: Icon(Icons.file_download_done,
                            color: Colors.green, size: 35)))),
          ],
          titleTextStyle: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.normal),
          backgroundColor: Constants.white,
          title: const Text(
            'PHIẾU KHÁM TẠI NHÀ',
            style: TextStyle(
                color: Constants.colorMain,
                fontWeight: FontWeight.w500,
                fontFamily: Constants.fontName,
                letterSpacing: 0,
                fontSize: 18),
          ),
          leading: AppUtil.iconBack(context),
          elevation: 1);

  @override
  Widget build(BuildContext context) => Scaffold(
        key: _scaffoldKey,
        appBar: viewAppBar(),
        body: Row(
          children: <Widget>[
            Expanded(
                child: Container(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
                    color: Constants.white,
                    height: double.infinity,
                    child: viewMain)),
            Container(
                height: double.infinity,
                color: Constants.white,
                child: SingleChildScrollView(
                  child: Column(
                      children: items
                          .map((item) => viewItemTab(
                              item: item, isShow: index == item.index))
                          .toList()),
                ))
          ],
        ),
      );

  Widget viewItemTab({IconHouseMedical item, bool isShow}) => GestureDetector(
      onTap: () {
        setState(() {
          index = item.index;
          onChangeTab();
        });
      },
      child: Container(
          color: isShow ? Constants.white : Constants.background,
          height: 55,
          width: 55,
          child: Center(
              child: Image.asset(item.imagePath,
                  width: item.width,
                  height: item.height,
                  color: isShow
                      ? Constants.colorMain
                      : const Color(0xFFCCCCCC)))));

  void onChangeTab() {
    if (index == 0) {
      setState(() {
        viewMain = tabPatientInfo;
      });
    }
    if (index == 1) {
      setState(() {
        viewMain = tabHealth;
      });
    }
    if (index == 2) {
      getTicketInfoIndication();
    }
    if (index == 5) {
      getTicketInfoService();
    }
    if (index == 6) {
      viewMain = tabImg;
    }
    if (index == 3 || index == 4) {
      setState(() {
        viewMain = const TabNoneHouseMedical();
      });
    }
    if (index == 7) {
      setState(() {
        viewMain = viewNote();
      });
    }
  }

  Widget viewServices(List<IndicationTicket> services) => SingleChildScrollView(
          child: Column(
        children: [
          Text('DỊCH VỤ', style: styleTextTitle),
          const SizedBox(height: 5),
          services != null && services.isNotEmpty
              ? ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: services.length,
                  itemBuilder: (BuildContext context, int index) =>
                      viewItemIndication(services[index], () {
                        onClickRemoveIndication(services[index], 0);
                      }, () {
                        onClickResultService(services[index]);
                      }))
              : const SizedBox(),
          services != null && services.isNotEmpty
              ? totalMoneyIndication(services)
              : const SizedBox(),
          Align(
              child: WidgetButtonHouseMedical()
                ..name = 'THÊM DỊCH VỤ'
                ..onClick = onClickAddService),
          const SizedBox(height: 35)
        ],
      ));
  Future<void> onClickAddService() async {
    final result = await Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) =>
              ScreenAddServiceHouseMedical(idTicket: ticketNow.id)),
    );
    ScaffoldMessenger.of(context).setState(() {
      getTicketInfoService();
    });
  }

  Widget viewIndication(List<IndicationTicket> arrIndication) =>
      SingleChildScrollView(
          child: Column(
        children: [
          Text('CHỈ ĐỊNH', style: styleTextTitle),
          const SizedBox(height: 5),
          arrIndication != null && arrIndication.isNotEmpty
              ? ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: arrIndication.length,
                  itemBuilder: (BuildContext context, int index) =>
                      viewItemIndication(arrIndication[index], () {
                        onClickRemoveIndication(arrIndication[index], 1);
                      }, () {
                        onClickResultIndication(arrIndication[index]);
                      }))
              : const SizedBox(),
          arrIndication != null && arrIndication.isNotEmpty
              ? totalMoneyIndication(arrIndication)
              : const SizedBox(),
          Align(
              child: WidgetButtonHouseMedical()
                ..name = 'THÊM CHỈ ĐỊNH'
                ..onClick = onClickAddIndication),
          const SizedBox(height: 35)
        ],
      ));

  Widget totalMoneyIndication(List<IndicationTicket> arrIndication) {
    int money = 0;
    for (final IndicationTicket item in arrIndication) {
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

  Widget viewItemIndication(
      IndicationTicket item, Function onClick, Function onClick2) {
    if (item.state == 'terminated') {
      return const SizedBox();
    } else {
      return Column(
        children: [
          Container(
              decoration: BoxDecoration(
                  color: const Color(0xFF2D9CDB).withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Row(
                children: [
                  GestureDetector(
                      onTap: onClick,
                      child: Container(
                          margin: const EdgeInsets.only(left: 8, right: 8),
                          color: const Color(0xFFC4C4C4),
                          child: const Icon(Icons.clear,
                              color: Color(0xFF2D9CDB)))),
                  Expanded(child: Text(item.name, style: styleText))
                ],
              )),
          const SizedBox(height: 3),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            GestureDetector(
                onTap: onClick2,
                child: Container(
                    padding: const EdgeInsets.only(
                        left: 5, right: 5, top: 3, bottom: 3),
                    decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    // color: Colors.green,
                    child: Text('Kết quả', style: styleTextColorWihte))),
            Text(AppUtil.convertMoney(item.price), style: styleTextHint)
          ]),
          const SizedBox(height: 10)
        ],
      );
    }
  }

  Future<void> onClickResultIndication(IndicationTicket item) async {
    final result = await Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) => ScreenResultTicketService()
            ..name = 'CHỈ ĐỊNH'
            ..result = item.result
            ..fileIds = item.fileIds
            ..id = item.id),
    );
    ScaffoldMessenger.of(context).setState(() {
      getTicketInfoIndication();
    });
  }

  Future<void> onClickResultService(IndicationTicket item) async {
    final result = await Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) => ScreenResultTicketService()
            ..name = 'DỊCH VỤ'
            ..result = item.result
            ..fileIds = item.fileIds
            ..id = item.id),
    );
    ScaffoldMessenger.of(context).setState(() {
      getTicketInfoService();
    });
  }

  Future<void> onClickRemoveIndication(
      IndicationTicket indication, int type) async {
    await DialogUtil.showDialogConfirmYesNo(_scaffoldKey, context,
        title: type == 1 ? 'XÁC NHẬN XOÁ CHỈ ĐỊNH' : 'XÁC NHẬN XOÁ DỊCH VỤ',
        message: indication.name,
        nameButton: 'Đồng ý', okBtnFunction: () async {
      final RequesstHouseMedical request = RequesstHouseMedical();
      final int result =
          await request.requestTicketRemoveIndication(context, indication.id);
      if (result == 0) {
        type == 1
            ? await getTicketInfoIndication()
            : await getTicketInfoService();
      }
    });
  }

  Future<void> onClickAddIndication() async {
    final result = await Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) =>
              ScreenAddIndicationHouseMedical(idTicket: ticketNow.id)),
    );
    ScaffoldMessenger.of(context).setState(() {
      getTicketInfoIndication();
    });
  }

  Widget viewNote() => Column(children: [
        Text('Kết quả khám bệnh', style: styleTextTitle),
        const SizedBox(height: 8),
        TextFormField(
          textInputAction: TextInputAction.done,
          minLines: 18,
          maxLines: 25,
          controller: controllerEditNote,
          style: Constants.styleTextNormalBlueColor,
          decoration: InputDecoration(
              filled: true,
              fillColor: Constants.colorTextHint.withOpacity(0.3),
              hintText: 'Nhập kết quả',
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              )),
        ),
        Align(
            child: WidgetButtonHouseMedical()
              ..name = 'CẬP NHẬT'
              ..onClick = onClickUpdateNote)
      ]);
  AppUtil appUtil = AppUtil();
  Future<void> onClickUpdateNote() async {
    if (controllerEditNote.text.trim().isEmpty) {
      appUtil.showToastWithScaffoldState(
          _scaffoldKey, 'Chưa nhập kế quả khám!');
      return;
    }

    final RequesstHouseMedical request = RequesstHouseMedical();
    final int result = await request.requestTicketUpdateNote(
        context, widget.ticket.id, controllerEditNote.text.trim());
    if (result == 0) {
      await DialogUtil.showDialogCreateSuccess(_scaffoldKey, context,
          messageSuccess: 'Cập nhật kết quả thành công', okBtnFunction: () {});
    }
  }

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

  TextStyle styleTextColorWihte = const TextStyle(
      // decoration: TextDecoration.underline,
      // fontStyle: FontStyle.italic,
      color: Constants.white,
      fontWeight: FontWeight.w600,
      fontFamily: Constants.fontName,
      fontSize: 12);

  TextStyle styleTextTitle = const TextStyle(
      color: Constants.colorMain,
      fontWeight: FontWeight.w600,
      fontFamily: Constants.fontName,
      fontSize: 15);

  TextStyle styleTextColor = const TextStyle(
      // decoration: TextDecoration.underline,
      // fontStyle: FontStyle.italic,
      color: Constants.colorMain,
      fontWeight: FontWeight.w500,
      fontFamily: Constants.fontName,
      fontSize: 14);
}

class IconHouseMedical {
  IconHouseMedical({this.imagePath = '', this.name = '', this.index});

  String imagePath, name;
  int index;
  double width, height;

  static List<IconHouseMedical> items = <IconHouseMedical>[
    IconHouseMedical(
        imagePath: 'assets/icons/icn_house_info.png',
        name: 'thông tin',
        index: 0)
      ..width = 35
      ..height = 35,
    IconHouseMedical(
        imagePath: 'assets/icons/icn_house_oxy.png',
        name: 'nhịp tim cân nặng',
        index: 1)
      ..width = 35
      ..height = 35,
    IconHouseMedical(
        imagePath: 'assets/icons/icn_house_xn.png', name: 'chỉ định', index: 2)
      ..width = 35
      ..height = 35,
    IconHouseMedical(
        imagePath: 'assets/icons/icn_house_cd.png',
        name: 'chuẩn đoán hình ảnh',
        index: 3)
      ..width = 35
      ..height = 35,
    IconHouseMedical(
        imagePath: 'assets/icons/icn_house_thuoc.png', name: 'thuốc', index: 4)
      ..width = 35
      ..height = 35,
    IconHouseMedical(
        imagePath: 'assets/icons/icn_house_medical.png',
        name: 'kết luận khám',
        index: 5)
      ..width = 35
      ..height = 35,
    IconHouseMedical(
        imagePath: 'assets/icons/icn_house_img.png', name: 'hình ảnh', index: 6)
      ..width = 35
      ..height = 35,
    IconHouseMedical(
        imagePath: 'assets/icons/icn_house_note.png', name: 'note', index: 7)
      ..width = 30
      ..height = 30,
  ];
}
