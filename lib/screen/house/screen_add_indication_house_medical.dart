// class
import 'dart:async';

import 'package:flutter/material.dart';

import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';
import '../../utils/DialogUtil.dart';
import 'house_appoinmrnt_data.dart';
import 'request_house_medical.dart';

class ScreenAddIndicationHouseMedical extends StatefulWidget {
  String idTicket;
  ScreenAddIndicationHouseMedical({Key key, this.idTicket}) : super(key: key);

  @override
  _ScreenAddIndicationHouseMedicalState createState() =>
      _ScreenAddIndicationHouseMedicalState();
}

class _ScreenAddIndicationHouseMedicalState
    extends State<ScreenAddIndicationHouseMedical> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<TicketIndication> items = [];
  List<TicketIndication> itemsSelect = [];
  int typeIndication = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getMoreData();
      }
    });
    getMoreData();
  }

  int page = 0, pageSize = 18, totalPages = 10;
  TextEditingController editingController = TextEditingController();
  String keySearch = '';
  Timer searchOnStoppedTyping;

  void onChangeHandler(String value) {
    setState(() {
      keySearch = value;
    });

    const duration = Duration(milliseconds: 1000);
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping.cancel()); // clear timer
    }
    setState(
        () => searchOnStoppedTyping = Timer(duration, () => search(value)));
  }

  Future<void> search(String value) async {
    AppUtil.showPrint('Search key: $value');

    page = 0;
    pageSize = 18;
    totalPages = 10;

    await getMoreData();
  }

  Future<void> getMoreData() async {
    final RequesstHouseMedical request = RequesstHouseMedical();
    final List<TicketIndication> result = await request.requestGetIndication(
        context, keySearch, typeIndication, items.length, 50);
    if (result != null) {
      setState(() {
        items = result;
      });
    }
  }

  Future<void> onClickDone() async {
    final RequesstHouseMedical request = RequesstHouseMedical();
    final List<String> arrIds = [];
    itemsSelect.map((e) => arrIds.add(e.id)).toList();
    final int result = await request.requestTicketAddIndication(
        context, widget.idTicket, arrIds);
    if (result != null && result == 0) {
      await DialogUtil.showDialogCreateSuccess(_scaffoldKey, context,
          messageSuccess: 'Thêm chỉ định thành công', okBtnFunction: () {});
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
            'THÊM CHỈ ĐỊNH',
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
        body: SingleChildScrollView(
            child: Column(
          children: [
            AppUtil.searchWidget(
                'Tìm kiếm chỉ định', onChangeHandler, editingController),
            viewSelectTab(),
            Text('Có ${itemsSelect.length} chỉ định được chọn',
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFamily: Constants.fontName,
                  fontSize: 14,
                  letterSpacing: 0,
                  color: Constants.colorMain,
                )),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) =>
                    viewItemIndication(index))
          ],
        )),
      );

  Widget viewItemIndication(int index) {
    final TicketIndication item = items[index];
    return item != null && item.price > 0
        ? Container(
            margin: const EdgeInsets.only(top: 15),
            padding: const EdgeInsets.only(left: 10, right: 10),
            width: double.infinity,
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text(
                              item.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: Constants.fontName,
                                fontSize: 15,
                                letterSpacing: 0,
                                color: Constants.colorText,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Giá: ${AppUtil.convertMoney(item.price)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontFamily: Constants.fontName,
                                fontSize: 14,
                                letterSpacing: 0,
                                color: Constants.colorMain,
                              ),
                            ),
                          ])),
                      viewButtonAdd(() {
                        onClickAdd(item);
                      }, item.id)
                    ]),
                const Divider(
                  color: Constants.colorTextHint,
                )
              ],
            ))
        : const SizedBox();
  }

  void onClickAdd(TicketIndication item) {
    if (itemsSelect.contains(item)) {
      setState(() {
        itemsSelect.remove(item);
      });
    } else {
      setState(() {
        itemsSelect.add(item);
      });
    }
  }

  Widget viewButtonAdd(Function onClick, String idIndication) =>
      GestureDetector(
          onTap: onClick,
          child: SizedBox(
            width: 65,
            height: 35,
            child: Center(
                child: Icon(
                    checkTick(idIndication) == true
                        ? Icons.check_box_outlined
                        : Icons.check_box_outline_blank,
                    color: Constants.colorMain,
                    size: 30)),
          ));

  bool checkTick(String idIndication) {
    for (final TicketIndication item in itemsSelect) {
      if (idIndication == item.id) {
        return true;
      }
    }
    return false;
  }

  Widget viewSelectTab() => Container(
      height: 30,
      width: 350,
      margin: const EdgeInsets.fromLTRB(15, 5, 15, 5),
      decoration: BoxDecoration(
        color: Constants.white,
        border: Border.all(color: Constants.colorMain),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Constants.colorShadow.withOpacity(0.2),
              offset: const Offset(1.1, 5),
              blurRadius: 8),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          iconSelect('Xét nghiệm', typeIndication == 1, 1),
          iconSelect('Dịch vụ', typeIndication == 2, 2)
        ],
      ));
  Widget iconSelect(String name, bool isCheck, int index) => GestureDetector(
      onTap: () {
        onClickTab(index);
      },
      child: Container(
          width: 165,
          decoration: isCheck ? getDecoration(index) : const BoxDecoration(),
          child: Center(
              child: Text(name,
                  style: isCheck
                      ? Constants.titleSelectWhite
                      : Constants.titleSelectColor))));
  void onClickTab(int index) {
    setState(() {
      typeIndication = index;
      getMoreData();
    });
  }

  static LinearGradient linearGradient = const LinearGradient(
      colors: [Constants.colorMain, Constants.colorShadow]);
  BoxDecoration decoration0 = BoxDecoration(
    gradient: linearGradient,
    borderRadius: const BorderRadius.horizontal(left: Radius.circular(15)),
  );
  BoxDecoration decoration2 = BoxDecoration(
    gradient: linearGradient,
    borderRadius: const BorderRadius.horizontal(right: Radius.circular(15)),
  );
  BoxDecoration getDecoration(int index) {
    if (index == 1) {
      return decoration0;
    }
    if (index == 2) {
      return decoration2;
    }
  }
}
