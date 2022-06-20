import 'dart:async';
import 'package:DoctorApp/screen/re_examination/ScreenQLTaiKhamTatCa.dart';
import 'package:DoctorApp/screen/re_examination/ScreenQLTaiKhamTrongNgay.dart';
import 'package:flutter/material.dart';
import 'package:DoctorApp/extension/HexColor.dart';
import 'package:DoctorApp/utils/AppUtil.dart';
import 'package:DoctorApp/utils/Constant.dart';

class ScreenQLTaiKhamContainer extends StatefulWidget {
  @override
  _ScreenQLTaiKhamContainerState createState() =>
      _ScreenQLTaiKhamContainerState();
}

class TabContent {
  String title;
  Widget content;
  TabContent({this.title, this.content});
}

class _ScreenQLTaiKhamContainerState extends State<ScreenQLTaiKhamContainer>
    with TickerProviderStateMixin {
  GlobalKey<ScreenQLTaiKhamTrongNgayState> keyTrongNgay = GlobalKey();
  GlobalKey<ScreenQLTaiKhamTatCaState> keyTatCa = GlobalKey();
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
            appBar: AppUtil.customAppBar(context, 'QL TÁI KHÁM'),
            body: Column(
              children: <Widget>[
                AppUtil.customTabBar(tabController, ['Trong ngày', 'Tất cả']),
                AppUtil.searchWidget(
                    'Tìm kiếm', _onChangeHandler, editingController),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      ScreenQLTaiKhamTrongNgay(
                        key: keyTrongNgay,
                        keySearch: keySearch,
                      ),
                      ScreenQLTaiKhamTatCa(
                        key: keyTatCa,
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
        () => searchOnStoppedTyping = new Timer(duration, () => search(value)));
  }

  search(value) async {
    AppUtil.showLog('parent keySearch: ' + keySearch);
    if (keyTrongNgay != null &&
        keyTrongNgay.currentState != null &&
        keyTrongNgay.currentState.mounted) {
      keyTrongNgay.currentState.reloadData();
    }
    if (keyTatCa != null &&
        keyTatCa.currentState != null &&
        keyTatCa.currentState.mounted) {
      keyTatCa.currentState.reloadData();
    }
  }
}
