import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../utils/AppUtil.dart';
import '../../../utils/Constant.dart';
import '../../../utils/DialogUtil.dart';
import '../house_appoinmrnt_data.dart';
import 'house_appointment_book_data.dart';
import 'widget_home_pack.dart';

class ScreenHouseCartServices extends StatefulWidget {
  const ScreenHouseCartServices({Key key}) : super(key: key);

  @override
  _ScreenHouseCartServicesState createState() =>
      _ScreenHouseCartServicesState();
}

class _ScreenHouseCartServicesState extends State<ScreenHouseCartServices> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<HomeServiceSelect> arrServicesSelect = [];
  double moneyTotal = 0;

  @override
  void initState() {
    super.initState();
    getServices();
  }

  Future<void> getServices() async {
    final List<HomeServiceSelect> servicesSelect = [];
    for (final HomeMedicalServiceData item in AppUtil.arrCartServices) {
      final HomeServiceSelect select = HomeServiceSelect()
        ..service = item
        ..time = null;
      servicesSelect.add(select);
    }
    setState(() {
      arrServicesSelect = servicesSelect;
      totalMoney();
    });
  }

  void totalMoney() {
    double money = 0;
    for (final HomeServiceSelect item in arrServicesSelect) {
      money += item.service.price;
    }
    setState(() {
      moneyTotal = money;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppUtil.customAppBar(
            context, '${arrServicesSelect.length} DỊCH VỤ ĐÃ CHỌN'),
        body: SingleChildScrollView(
            child: Column(
          children: [viewServices(), viewBottom()],
        )),

        // bottomNavigationBar: viewBottom(),
        // floatingActionButton: Container(
        //     width: MediaQuery.of(context).size.width * 0.70,
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(20.0),
        //     ),
        //     child: Column(children: [
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           const SizedBox(),
        //           Text('Tổng giá: ${AppUtil.convertMoney(moneyTotal)}',
        //               style: const TextStyle(
        //                   color: Constants.colorTextHint,
        //                   fontWeight: FontWeight.w200,
        //                   fontFamily: Constants.fontName,
        //                   fontSize: 14))
        //         ],
        //       ),
        //       FloatingActionButton.extended(
        //         backgroundColor: Color(0xFF2980b9),
        //         onPressed: () {},
        //         elevation: 0,
        //         label: Text(
        //           "BOOK NOW",
        //           style: TextStyle(fontSize: 18.0),
        //         ),
        //       )
        //     ])),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
  Widget viewBottom() => Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Tổng giá: ',
                style: TextStyle(
                    color: Constants.colorText,
                    fontWeight: FontWeight.w500,
                    fontFamily: Constants.fontName,
                    fontSize: 15)),
            Text(AppUtil.convertMoney(moneyTotal),
                style: const TextStyle(
                    color: Constants.colorMain,
                    fontWeight: FontWeight.w500,
                    fontFamily: Constants.fontName,
                    fontSize: 15)),
          ],
        ),
        const SizedBox(height: 15),
        GestureDetector(
            onTap: onClickBook,
            child: Container(
              margin: const EdgeInsets.only(left: 55, right: 55, bottom: 25),
              height: 45,
              decoration: BoxDecoration(
                color: Constants.nearlyBlue,
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Constants.nearlyBlue.withOpacity(0.5),
                      offset: const Offset(1.1, 1.1),
                      blurRadius: 3),
                ],
              ),
              child: const Center(
                child: Text(
                  'TIẾP TỤC',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: Constants.fontName,
                    fontSize: 18,
                    letterSpacing: 0,
                    color: Constants.nearlyWhite,
                  ),
                ),
              ),
            )),
      ]));
  Widget viewServices() => Container(
      margin: const EdgeInsets.only(top: 8),
      height: arrServicesSelect.length * 85.0,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: arrServicesSelect.length,
        itemBuilder: (BuildContext context, int index) => viewRowService(index),
      ));
  Widget viewRowService(int index) {
    final HomeServiceSelect item = arrServicesSelect[index];
    return Container(
        height: 85,
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              '${index + 1}. ${item.service.name}',
              style: const TextStyle(
                  color: Constants.colorText,
                  fontWeight: FontWeight.w500,
                  fontFamily: Constants.fontName,
                  fontSize: 13),
            ),
            SizedBox(
                width: 25,
                height: 25,
                child: IconButton(
                    padding: const EdgeInsets.all(1),
                    iconSize: 20,
                    onPressed: () {
                      onClickRemoveCart(item);
                    },
                    icon: const Icon(Icons.remove_circle_outline,
                        size: 20, color: Colors.red)))
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text(
              'Thời gian',
              style: TextStyle(
                  color: Constants.colorTextHint,
                  fontWeight: FontWeight.w200,
                  fontFamily: Constants.fontName,
                  fontSize: 13),
            ),
            GestureDetector(
                onTap: () {
                  selectTime(index);
                },
                child: item.time != null
                    ? Text(
                        DateFormat(Constants.formatDateTime).format(item.time),
                        style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w200,
                            fontFamily: Constants.fontName,
                            fontSize: 13),
                      )
                    : const Text('Chưa chọn thời gian',
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w200,
                            fontFamily: Constants.fontName,
                            fontSize: 13)))
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            ButtonText(
                press: () {
                  serviceDetail(item.service);
                },
                text: 'Mô tả dịch vụ'),
            Text(
              'Giá: ${AppUtil.convertMoney(item.service?.price)}',
              style: const TextStyle(
                  color: Constants.colorMain,
                  fontWeight: FontWeight.w200,
                  fontFamily: Constants.fontName,
                  fontSize: 13),
            )
          ]),
          const Divider(
            color: Constants.colorTextHint,
          ),
        ]));
  }

  void onClickAdd(HomeMedicalServiceData item) {
    setState(() {
      AppUtil.arrCartServices.add(item);
    });
    // AppUtil.showToast(
    //     context, 'Thêm dịch vụ ${item.name} vào giỏ hàng thành công!');
  }

  Future<void> onClickBook() async {
    if (arrServicesSelect.isEmpty) {
      await DialogUtil.showDialogWithTitle(_scaffoldKey, context,
          dialogTitle: 'THÔNG BÁO',
          dialogMessage: 'Bạn chưa chọn dịch vụ hãy quay lại để lựa chọn',
          okBtnFunction: () {});
      return;
    }
    bool check = true;
    final List<HomeServiceBook> serviceBook = [];
    for (final HomeServiceSelect item in arrServicesSelect) {
      if (item.time == null) {
        check = false;
        break;
      }
      final HomeServiceBook service = HomeServiceBook()
        ..isPack = false
        ..servingTime = item.time
        ..setId(item.service.id);
      serviceBook.add(service);
    }
    if (check) {
      // await Navigator.push(
      //   context,
      //   CupertinoPageRoute(
      //       builder: (context) => ScreenHomePatient(serviceBook: serviceBook)),
      // );
    } else {
      await DialogUtil.showDialogWithTitle(_scaffoldKey, context,
          dialogTitle: 'THÔNG BÁO',
          dialogMessage: 'Bạn chưa chọn thời gian cho các dịch vụ !',
          okBtnFunction: () {});
    }
  }

  Future<void> serviceDetail(HomeMedicalServiceData item) async {
    await DialogUtil.showDialogWithTitle(_scaffoldKey, context,
        dialogTitle: item.name,
        dialogMessage: item.description,
        okBtnFunction: () {});
  }

  Future<void> selectTime(int index) async {
    await showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) => SizedBox(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            child: CupertinoDatePicker(
              minimumDate: DateTime.now(),
              // initialDateTime: DateTime.now().add(const Duration(days: 1)),
              initialDateTime: arrServicesSelect[index].time ?? DateTime.now(),
              use24hFormat: true,
              onDateTimeChanged: (DateTime date) {
                setState(() {
                  arrServicesSelect[index].time = date;
                });
              },
            )));
  }

  void onClickRemoveCart(HomeServiceSelect item) {
    setState(() {
      arrServicesSelect.remove(item);
      AppUtil.arrCartServices.remove(item.service);

      totalMoney();
    });
  }
}

class HomeServiceSelect {
  HomeMedicalServiceData service;
  DateTime time;
}
