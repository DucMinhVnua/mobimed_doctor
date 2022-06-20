import 'package:flutter/material.dart';

import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';
import '../account/TabHomeCaNhan.dart';
import '../notification/TabListNotifications.dart';
import '../online_medical/service/observer.dart';
import '../online_medical/service/signaling.dart';
import '../patient/TabHomeListBNDatKham.dart';
import 'TabHomeMenu.dart';
import 'tab_chat.dart';
import 'tab_home_none.dart';

// ignore: must_be_immutable
class ScreenHomeContainer extends StatefulWidget {
  final _ScreenHomeContainerState __screenHomeContainerState =
      _ScreenHomeContainerState();

  ScreenHomeContainer({Key key}) : super(key: key);

  void moveToTab(int _tabIndex) {
    __screenHomeContainerState.moveToTab(_tabIndex);
  }

  @override
  _ScreenHomeContainerState createState() => __screenHomeContainerState;
}

class _ScreenHomeContainerState extends State<ScreenHomeContainer>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<ScreenHomeContainer> {
  TabController _tabController;
  TabHomeMenu tabHomeMenu = const TabHomeMenu();
  TabHomeNone tabHomeNone = const TabHomeNone();
  TabChat tabChat = const TabChat();
  TabHomeListBNDatKham tabHomeListPatients = const TabHomeListBNDatKham();
  TabListNotifications tabListNotifications = TabListNotifications();
  TabHomeCaNhan tabHomeCaNhan = TabHomeCaNhan();
  int indexBar = 0;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 5);
    _tabController.addListener(_handleTabSelection);

    final SignalingProvider _signaling = SignalingProvider();
    final observer = Observer(MSG_CHAT, onChat);
    _signaling.registerObserver('Messages_home', observer);
  }

  void onChat(mess) {
    setState(() {
      AppUtil.isReadMessage = true;
    });
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) => Scaffold(
        body: DefaultTabController(
          length: 4,
          child: Scaffold(
            bottomNavigationBar: menu(),
            body: TabBarView(
              controller: _tabController,
              children: [
                tabHomeMenu,
                tabHomeNone,
                tabHomeListPatients,
                tabChat,
                tabHomeCaNhan
              ],
            ),
          ),
        ),
      );

  void moveToTab(int _tabIndex) {
    if (_tabController != null) {
      _tabController.animateTo(_tabIndex);
      AppUtil.showLog('moveToTab: $_tabIndex');
    } else {
      AppUtil.showLog('moveToTab: _tabController NULL');
    }
  }

  double sizeIcon = 30;
  Widget menu() => TabBar(
        controller: _tabController,
//        labelStyle: Constants.styleTextSmallSubColor,
        labelColor: Constants.colorMain,
        labelStyle: styleTextMenuSelect,
        unselectedLabelStyle: styleTextMenu,
        unselectedLabelColor: colorMenu,
        indicatorSize: TabBarIndicatorSize.tab,
        labelPadding: const EdgeInsets.symmetric(horizontal: 1),
        // indicatorPadding: EdgeInsets.all(2.0),
        indicatorColor: Constants.colorMain,
        tabs: [
          Tab(
              text: 'Trang chủ',
              icon: Image.asset('assets/icons/icn_home.png',
                  width: sizeIcon,
                  height: sizeIcon,
                  color: _tabController.index == 0
                      ? Constants.colorMain
                      : colorMenu)),
          Tab(
              text: 'Lịch làm việc',
              icon: Image.asset('assets/icons/icn_time.png',
                  width: sizeIcon,
                  height: sizeIcon,
                  color: _tabController.index == 1
                      ? Constants.colorMain
                      : colorMenu)),
          Tab(
              text: 'Đặt khám',
              icon: Image.asset('assets/icons/icn_medical.png',
                  width: sizeIcon,
                  height: sizeIcon,
                  color: _tabController.index == 2
                      ? Constants.colorMain
                      : colorMenu)),
          Tab(
              text: 'Trao đổi',
              icon: Stack(
                children: [
                  Image.asset('assets/icons/icn_mess.png',
                      width: sizeIcon,
                      height: sizeIcon,
                      color: _tabController.index == 3
                          ? Constants.colorMain
                          : colorMenu),
                  if (AppUtil.isReadMessage)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: 16,
                        width: 16,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                      ),
                    )
                ],
              )),
          Tab(
              text: 'Thông tin',
              icon: Image.asset('assets/icons/icn_info.png',
                  width: sizeIcon,
                  height: sizeIcon,
                  color: _tabController.index == 4
                      ? Constants.colorMain
                      : colorMenu)),
        ],
      );

  static Color colorMenu = const Color(0xFF868686);
  TextStyle styleTextMenu = TextStyle(
      color: colorMenu,
      fontWeight: FontWeight.w600,
      fontFamily: Constants.fontName,
      fontSize: 12);
  TextStyle styleTextMenuSelect = const TextStyle(
      color: Constants.colorMain,
      fontWeight: FontWeight.w600,
      fontFamily: Constants.fontName,
      fontSize: 12);
  @override
  bool get wantKeepAlive => true;
}
