import 'dart:async';

import 'package:flutter/material.dart';

import '../../utils/AppUtil.dart';
import 'ScreenQLKhamBenhChoKham.dart';
import 'ScreenQLKhamBenhDaKham.dart';
import 'ScreenQLKhamBenhDangKham.dart';

class ScreenQLKhamBenhContainer extends StatefulWidget {
  const ScreenQLKhamBenhContainer({Key key}) : super(key: key);

  @override
  _ScreenQLKhamBenhContainerState createState() =>
      _ScreenQLKhamBenhContainerState();
}

class TabContent {
  String title;
  Widget content;
  TabContent({this.title, this.content});
}

class _ScreenQLKhamBenhContainerState extends State<ScreenQLKhamBenhContainer>
    with TickerProviderStateMixin {
  GlobalKey<ScreenQLKhamBenhChoKhamState> keyChoKham = GlobalKey();
  GlobalKey<ScreenQLKhamBenhDangKhamState> keyDangKham = GlobalKey();
  GlobalKey<ScreenQLKhamBenhDaKhamState> keyDaKham = GlobalKey();
  String keySearch = '';
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppUtil.customAppBar(context, 'QL KHÁM BỆNH'),
            body: Column(
              children: <Widget>[
                AppUtil.customTabBar(
                    tabController, ['Chờ khám', 'Đang khám', 'Đã khám']),
                AppUtil.searchWidget(
                    'Tìm kiếm', onChangeHandler, editingController),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      ScreenQLKhamBenhChoKham(
                        key: keyChoKham,
                        keySearch: keySearch,
                      ),
                      ScreenQLKhamBenhDangKham(
                        key: keyDangKham,
                        keySearch: keySearch,
                      ),
                      ScreenQLKhamBenhDaKham(
                          key: keyDaKham, keySearch: keySearch)
                    ],
                  ),
                )
              ],
            ),
            // )
          ),
        ),
      );

  TextEditingController editingController = TextEditingController();
  Timer searchOnStoppedTyping;
  void onChangeHandler(String value) {
    AppUtil.showPrint(' onChangeHandler value: $value');
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

  Future<void> search(String value) async {
    AppUtil.showLog('parent keySearch: $keySearch');
    if (keyChoKham != null &&
        keyChoKham.currentState != null &&
        keyChoKham.currentState.mounted) {
      await keyChoKham.currentState.reloadData();
    }
    if (keyDangKham != null &&
        keyDangKham.currentState != null &&
        keyDangKham.currentState.mounted) {
      await keyDangKham.currentState.reloadData();
    }
    if (keyDaKham.currentState != null &&
        keyDaKham.currentState != null &&
        keyDaKham.currentState.mounted) {
      await keyDaKham.currentState.reloadData();
    }
  }
}
