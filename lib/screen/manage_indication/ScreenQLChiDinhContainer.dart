import 'dart:async';

import 'package:flutter/material.dart';

import '../../utils/AppUtil.dart';
import 'ScreenQLChiDinhChoXuLy.dart';
import 'ScreenQLChiDinhDangThucHien.dart';
import 'ScreenQLChiDinhHoanThanh.dart';

class ScreenQLChiDinhContainer extends StatefulWidget {
  @override
  _ScreenQLChiDinhContainerState createState() =>
      _ScreenQLChiDinhContainerState();
}

class TabContent {
  String title;
  Widget content;
  TabContent({this.title, this.content});
}

class _ScreenQLChiDinhContainerState extends State<ScreenQLChiDinhContainer>
    with TickerProviderStateMixin {
  GlobalKey<ScreenQLChiDinhDangThucHienState> keyDangDangThucHien = GlobalKey();
  GlobalKey<ScreenQLChiDinhHoanThanhState> keyHoanThanh = GlobalKey();
  GlobalKey<ScreenQLChiDinhChoXuLyState> keyChoXuLy = GlobalKey();
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
            appBar: AppUtil.customAppBar(context, 'QL CHỈ ĐỊNH'),
            body: Column(
              children: <Widget>[
                AppUtil.customTabBar(tabController,
                    ['Chờ xử lý', 'Đang thực hiện', 'Đã hoàn thành']),
                AppUtil.searchWidget(
                    'Tìm kiếm', _onChangeHandler, editingController),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      ScreenQLChiDinhChoXuLy(
                        key: keyChoXuLy,
                        keySearch: keySearch,
                      ),
                      ScreenQLChiDinhDangThucHien(
                        key: keyDangDangThucHien,
                        keySearch: keySearch,
                      ),
                      ScreenQLChiDinhHoanThanh(
                        key: keyHoanThanh,
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
    if (keyDangDangThucHien != null &&
        keyDangDangThucHien.currentState != null &&
        keyDangDangThucHien.currentState.mounted) {
      keyDangDangThucHien.currentState.reloadData();
    }
    if (keyHoanThanh != null &&
        keyHoanThanh.currentState != null &&
        keyHoanThanh.currentState.mounted) {
      keyHoanThanh.currentState.reloadData();
    }
    if (keyChoXuLy != null &&
        keyChoXuLy.currentState != null &&
        keyChoXuLy.currentState.mounted) {
      keyChoXuLy.currentState.reloadData();
    }
  }
}
