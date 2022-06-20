import 'dart:async';

import 'package:flutter/material.dart';

import '../../utils/AppUtil.dart';
import 'ScreenQLDatKhamDaKham.dart';
import 'ScreenQLDatKhamDangKham.dart';
import 'ScreenQLDatKhamTrongNgay.dart';

class ScreenQLDatKhamContainer extends StatefulWidget {
  const ScreenQLDatKhamContainer({Key key}) : super(key: key);

  @override
  _ScreenQLDatKhamContainerState createState() =>
      _ScreenQLDatKhamContainerState();
}

class TabContent {
  String title;
  Widget content;
  TabContent({this.title, this.content});
}

class _ScreenQLDatKhamContainerState extends State<ScreenQLDatKhamContainer>
    with TickerProviderStateMixin {
  GlobalKey<ScreenQLDatKhamTrongNgayState> keyTrongNgay = GlobalKey();
  GlobalKey<ScreenQLDatKhamDangKhamState> keyDangKham = GlobalKey();
  GlobalKey<ScreenQLDatKhamDaKhamState> keyDaKham = GlobalKey();
  String keySearch = '';
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: DefaultTabController(
          length: 2,
          child: Scaffold(
            // appBar: AppBar(
            //   title: const Text('QL ĐẶT KHÁM'),
            //   bottom: const TabBar(
            //     labelStyle: TextStyle(fontSize: 13),
            //     indicatorColor: Colors.white,
            //     tabs: [
            //       Tab(
            //         text: 'Đã đặt trong ngày',
            //       ),
            //       Tab(
            //         text: 'Đã đến khám trong ngày',
            //       ),
            //       // Tab(
            //       //   text: "Đã khám",
            //       // )
            //     ],
            //   ),
            //   iconTheme: const IconThemeData(color: Colors.white),
            //   titleTextStyle: const TextStyle(
            //       color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            //   backgroundColor: HexColor.fromHex(Constants.Color_primary),
            // ),
            appBar: AppUtil.customAppBar(context, 'QL ĐẶT KHÁM'),
            body: Column(
              children: <Widget>[
                AppUtil.customTabBar(
                    tabController, ['Đặt trong ngày', 'Đến khám trong ngày']),
                AppUtil.searchWidget(
                    'Tìm kiếm', _onChangeHandler, editingController),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      ScreenQLDatKhamTrongNgay(
                        key: keyTrongNgay,
                        keySearch: keySearch,
                      ),
                      ScreenQLDatKhamDangKham(
                        key: keyDangKham,
                        keySearch: keySearch,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );

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
    if (keyDaKham.currentState != null &&
        keyDaKham.currentState != null &&
        keyDaKham.currentState.mounted) {
      keyDaKham.currentState.reloadData();
    }
  }
}
