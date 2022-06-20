import 'dart:convert';
import 'package:DoctorApp/utils/Constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:DoctorApp/bloc/userinfo/userinfo_bloc.dart';
import 'package:DoctorApp/extension/HexColor.dart';
import 'package:DoctorApp/extension/RaisedGradientButton.dart';
import 'package:DoctorApp/model/UserInfoData.dart';
import 'package:DoctorApp/screen/account/ScreenUpdateProfile.dart';
import 'package:DoctorApp/utils/AppUtil.dart';
import 'package:flutter/material.dart';

import '../online_medical/service/signaling.dart';
import 'ScreenChangePassword.dart';
import 'ScreenLogin.dart';
import 'screen_introduction.dart';
import 'screen_policy.dart';
import 'screen_user_info.dart';

class TabHomeCaNhan extends StatefulWidget {
  final String title;

  TabHomeCaNhan({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TabHomeCaNhanState();
}

class _TabHomeCaNhanState extends State<TabHomeCaNhan>
    with AutomaticKeepAliveClientMixin<TabHomeCaNhan> {
  AppUtil appUtil = AppUtil();
  ScrollController _scrollController;
  UserInfoBloc userInfoBloc;
  UserInfoData userData;

  @override
  void initState() {
    super.initState();

    userInfoBloc = BlocProvider.of<UserInfoBloc>(context);
    _scrollController = ScrollController();

    //Start load userinfo
    userInfoBloc.add(
      LoadUserInfoEvent(context),
    );
  }

  void onCLickInfo() {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => ScreenUserInfo()),
    );
  }

  void onCLickChangePass() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ScreenChangePassword()));
  }

  void onClickPolicy() {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => const ScreenPolicy()),
    );
  }

  SignalingProvider _signaling;
  Future<void> onClickLogout() async {
    final ConfirmAction action = await appUtil.asyncConfirmDialog(
        context, 'Thông báo', 'Bạn có chắc chắn muốn đăng xuất?');
    if (action == ConfirmAction.ACCEPT) {
      await Future.delayed(const Duration(milliseconds: 200)).then((_) {
//                                        AppUtil.isLogin = false;
        AppUtil.saveToSettting(Constants.PREF_ACCESSTOKEN, '');
        AppUtil.saveToSettting(Constants.PREF_PASSWORD, '');
        AppUtil.saveToSettting(Constants.PREF_USERNAME, '');
        _signaling = SignalingProvider();
        _signaling.stop();
        // this code is executed after the future ends.
        Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(
              builder: (context) => ScreenLogin(),
            ),
            (route) => false);
//                                Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      });
    } else if (action == ConfirmAction.CANCEL) {}
  }

  void onClickIntroduction() {
    Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) =>
              ScreenIntroduction(url: 'https://benhviendakhoatinhphutho.vn/')),
    );
  }

  Color colorMenu = const Color(0xFF868686).withOpacity(0.8);

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) => DefaultTabController(
        length: 3,
        child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                const SizedBox(height: 25),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      viewIcon('Thông tin', colorMenu, onCLickInfo,
                          Icons.info_outline),
                      viewIcon('Đổi mật khẩu', colorMenu, onCLickChangePass,
                          Icons.lock_outline),
                      viewIcon('Chính sách', colorMenu, onClickPolicy,
                          Icons.policy_outlined),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      viewIcon('Giới thiệu', colorMenu, onClickIntroduction,
                          Icons.question_mark_outlined),
                      viewIcon('Đăng xuất', Colors.red, onClickLogout,
                          Icons.power_settings_new_outlined),
                      const SizedBox(height: 100, width: 110)
                    ]),
              ],
            ))),
      );

  Widget viewIcon(String name, Color color, Function onClick, IconData icon) =>
      GestureDetector(
          onTap: onClick,
          child: SizedBox(
              width: 110,
              height: 85,
              child: Column(children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.only(
                      left: 5, right: 5, top: 5, bottom: 5),
                  decoration: const BoxDecoration(
                    color: Constants.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                        topRight: Radius.circular(8)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Constants.colorTextHint,
                        // offset: Offset(1.1, 1.1),
                        // blurRadius: 1
                        spreadRadius: 0.5,
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  height: 45,
                  width: 45,
                  child: Icon(icon,
                      size: 23,
                      color: name == 'Đăng xuất'
                          ? Colors.red
                          : Constants.colorMain),
                ),
                Text(
                  name,
                  style: TextStyle(
                      color: color.withOpacity(0.8), // Constants.colorText,
                      fontWeight: FontWeight.w500,
                      fontFamily: Constants.fontName,
                      fontSize: 14),
                ),
              ])));

  @override
  bool get wantKeepAlive => true;
}
