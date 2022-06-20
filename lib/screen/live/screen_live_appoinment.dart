import 'dart:async';

import 'package:flutter/material.dart';

import '../../utils/AppUtil.dart';
import '../manage_appointment/ScreenQLDatKhamDangKham.dart';
import '../manage_appointment/ScreenQLDatKhamTrongNgay.dart';

class ScreenLiveAppoinment extends StatefulWidget {
  const ScreenLiveAppoinment({Key key}) : super(key: key);

  @override
  _ScreenLiveAppoinmentState createState() => _ScreenLiveAppoinmentState();
}

class _ScreenLiveAppoinmentState extends State<ScreenLiveAppoinment>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  GlobalKey<ScreenQLDatKhamTrongNgayState> keyTrongNgay = GlobalKey();
  GlobalKey<ScreenQLDatKhamDangKhamState> keyDangKham = GlobalKey();
  String keySearch = '';

  TextEditingController editingController = TextEditingController();
  Timer searchOnStoppedTyping;
  _onChangeHandler(value) {
    AppUtil.showPrint('_onChangeHandler value: $value');
    setState(() {
      keySearch = value;
    });
    const duration = Duration(
        milliseconds:
            1000); // set the duration that you want call search() after that.
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping.cancel()); // clear timer
    }
    setState(
        () => searchOnStoppedTyping = Timer(duration, () => search(value)));
  }

  search(value) async {
    AppUtil.showLog('parent keySearch: ' + keySearch);
    if (keyTrongNgay != null &&
        keyTrongNgay.currentState != null &&
        keyTrongNgay.currentState.mounted) {
      keyTrongNgay.currentState.reloadData();
    }
    if (keyDangKham != null &&
        keyDangKham.currentState != null &&
        keyDangKham.currentState.mounted) {
      keyDangKham.currentState.reloadData();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      key: _scaffoldKey,
      appBar: AppUtil.customAppBar(context, 'QL TRỰC TIẾP'),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          AppUtil.customTabBar(tabController, ['Khách mới', 'Đã tiếp nhận']),
          AppUtil.searchWidget('Tìm kiếm', _onChangeHandler, editingController),
          Expanded(
              child: TabBarView(controller: tabController, children: [
            ScreenQLDatKhamTrongNgay(
              key: keyTrongNgay,
              keySearch: keySearch,
            ),
            ScreenQLDatKhamDangKham(
              key: keyDangKham,
              keySearch: keySearch,
            ),
          ])),
        ],
      ));
}
