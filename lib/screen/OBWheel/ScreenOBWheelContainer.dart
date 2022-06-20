import 'package:flutter/material.dart';

import '../../utils/AppUtil.dart';
import 'ScreenOBWheel.dart';
import 'ScreenOBWheelHistory.dart';

class ScreenOBWheelContainer extends StatefulWidget {
  const ScreenOBWheelContainer({Key key}) : super(key: key);

  @override
  _ScreenOBWheelContainerState createState() => _ScreenOBWheelContainerState();
}

class _ScreenOBWheelContainerState extends State<ScreenOBWheelContainer>
    with TickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppUtil.customAppBar(context, 'Tính tuổi thai'),
            body: Column(
              children: [
                AppUtil.customTabBar(
                    tabController, ['Tính tuổi thai', 'Lịch sử']),
                Expanded(
                    child: TabBarView(
                  controller: tabController,
                  children: [
                    ScreenOBWheel(),
                    ScreenOBWheelHistory(),
                  ],
                ))
              ],
            )),
      );

  @override
  // ignore: override_on_non_overriding_member
  bool wantKeepAlive = true;
}
