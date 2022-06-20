// class
import 'dart:async';

import 'package:flutter/material.dart';

import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';
import '../../utils/DialogUtil.dart';
import 'house_appoinmrnt_data.dart';
import 'request_house_medical.dart';

class ScreenAddServiceHouseMedical extends StatefulWidget {
  String idTicket;
  ScreenAddServiceHouseMedical({Key key, this.idTicket}) : super(key: key);

  @override
  _ScreenAddServiceHouseMedicalState createState() =>
      _ScreenAddServiceHouseMedicalState();
}

class _ScreenAddServiceHouseMedicalState
    extends State<ScreenAddServiceHouseMedical> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<HomeMedicalPackData> arrPacks = [];
  List<String> arrIdPackSelect = [];
  List<HomeMedicalServiceData> arrServices = [];
  List<String> arrIdServicesSelect = [];

  int typeSelect = 1;
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
  String textHintSearch = ' gói khám';
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
    if (typeSelect == 1) {
      await getMorePack();
    } else {
      await getMoreService();
    }
  }

  Future<void> getMoreService() async {
    final RequesstHouseMedical request = RequesstHouseMedical();
    final List<HomeMedicalServiceData> result =
        await request.requestGetServicesSearch(context, keySearch);
    if (result != null) {
      setState(() {
        arrServices = result;
      });
    }
  }

  Future<void> getMorePack() async {
    final RequesstHouseMedical request = RequesstHouseMedical();
    final List<HomeMedicalPackData> result =
        await request.requestGetPackSearch(context, keySearch);
    if (result != null) {
      setState(() {
        arrPacks = result;
      });
    }
  }

  Future<void> onClickDone() async {
    final List<ServiceDataInput> arrInput = [];
    arrIdServicesSelect
        .map((e) => arrInput.add(ServiceDataInput()
          ..isPack = false
          ..servingTime = DateTime.now().toIso8601String()
          ..setId(e)))
        .toList();
    arrIdPackSelect
        .map((e) => arrInput.add(ServiceDataInput()
          ..isPack = true
          ..servingTime = DateTime.now().toIso8601String()
          ..setId(e)))
        .toList();
    final RequesstHouseMedical request = RequesstHouseMedical();
    final int result = await request.requestTicketAddService(
        context, widget.idTicket, arrInput);

    if (result != null && result == 0) {
      await DialogUtil.showDialogCreateSuccess(_scaffoldKey, context,
          messageSuccess: 'Thêm dịch vụ thành công', okBtnFunction: () {});
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
            'THÊM DỊCH VỤ',
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
                'Tìm kiếm $textHintSearch', onChangeHandler, editingController),
            viewSelectTab(),
            Text(
                'Có ${arrIdPackSelect.length + arrIdServicesSelect.length} dịch vụ được chọn',
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
                itemCount:
                    typeSelect == 1 ? arrPacks.length : arrServices.length,
                itemBuilder: (BuildContext context, int index) =>
                    typeSelect == 1
                        ? viewItem(arrPacks[index].price, arrPacks[index].name,
                            arrPacks[index].id, true)
                        : viewItem(
                            arrServices[index].price,
                            arrServices[index].name,
                            arrServices[index].id,
                            false))
          ],
        )),
      );

  Widget viewItem(int price, String name, String id, bool isPack) => Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.only(left: 10, right: 10),
      width: double.infinity,
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(
                    name,
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
                    'Giá: ${AppUtil.convertMoney(price)}',
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
              onClickAdd(id);
            }, id)
          ]),
          const Divider(
            color: Constants.colorTextHint,
          )
        ],
      ));

  void onClickAdd(String idItem) {
    setState(() {
      typeSelect == 1
          ? arrIdPackSelect.contains(idItem)
              ? arrIdPackSelect.remove(idItem)
              : arrIdPackSelect.add(idItem)
          : arrIdServicesSelect.contains(idItem)
              ? arrIdServicesSelect.remove(idItem)
              : arrIdServicesSelect.add(idItem);
    });
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

  bool checkTick(String idService) {
    if (typeSelect == 1) {
      for (final String item in arrIdPackSelect) {
        if (idService == item) {
          return true;
        }
      }
      return false;
    } else {
      for (final String item in arrIdServicesSelect) {
        if (idService == item) {
          return true;
        }
      }
      return false;
    }
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
          iconSelect('Gói khám', typeSelect == 1, 1),
          iconSelect('Dịch vụ khám', typeSelect == 2, 2)
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
      typeSelect = index;
      getMoreData();
      textHintSearch = typeSelect == 1 ? 'gói khám' : 'dịch vụ khám';
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
