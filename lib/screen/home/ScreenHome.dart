import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../bloc/userinfo/userinfo_bloc.dart';
import '../../controller/ApiGraphQLControllerQuery.dart';
import '../../extension/HexColor.dart';
import '../../model/UserInfoData.dart';
import '../../utils/AppStyle.dart';
import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';
import '../account/ScreenChangePassword.dart';
import '../account/ScreenChinhSachSuDung.dart';
import '../account/ScreenLogin.dart';
import '../account/ScreenThongTinCaNhan.dart';
import '../notification/ScreenListNotifications.dart';
import '../online_medical/service/signaling.dart';
import '../patient/ScreenDSBenhNhan.dart';
import 'QRCreatePage.dart';
import 'QRScanPage.dart';
import 'ScreenHomeContainer.dart';
import 'ScreenThongKe.dart';
import 'TabHomeMenu.dart';

class ScreenHome extends StatefulWidget {
  final String title;

  const ScreenHome({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ScreenHomeContainer screenHomeContainer = ScreenHomeContainer();

  AppUtil appUtil = AppUtil();

  SignalingProvider _signaling;

  String inReview = 'true';

  UserInfoBloc userInfoBloc;

  int selectedDrawerIndex = 0;

  String nameUser = '';
  String imgAvatar = 'assets/avatar/icon_bs_nu.png';

  @override
  initState() {
    super.initState();

    userInfoBloc = BlocProvider.of<UserInfoBloc>(context);

    //Start load userinfo
    userInfoBloc.add(
      LoadUserInfoEvent(context),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => checkReviewInfo());

    requestGetAccountInfo();
  }

  Future<void> requestGetAccountInfo() async {
    try {
      final ApiGraphQLControllerQuery apiController =
          ApiGraphQLControllerQuery();
      final QueryResult result =
          await apiController.requestGetAccountInfo(context);
      if (result == null) return;
      AppUtil.showLog('Response requestGetAccountInfo: ${result.data}');
      final responseData = appUtil.processResponse(result);
      if (responseData != null) {
        final int code = responseData.code;
        final String message = responseData.message;
        final Map data = responseData.data;
        if (code == 0) {
          //Login thành công
          final UserInfoData userData = UserInfoData.fromJson(data);
          setState(() {
            nameUser = userData.base.fullName;
            AppUtil.userId = userData.id;

            if (userData.base.avatar != null &&
                userData.base.avatar.length > 8) {
              imgAvatar = dotenv.env['BASE_API_URL_AVATAR_DOCTOR'] +
                  userData.base.avatar;
            } else {
              imgAvatar = (userData.base.gender == '1' ||
                      userData.base.gender == 'male')
                  ? 'assets/avatar/icon_bs_nam.png'
                  : 'assets/avatar/icon_bs_nu.png';
            }
          });
          setupSignal();
        } else {
          AppUtil.showLog(
              'requestGetAccountInfo code: $code, message: $message');
        }
      }
    } on Exception catch (e) {
      AppUtil.showLog('requestRegisterDevice Error: $e');
    }
  }

  void setupSignal() {
    WidgetsBinding.instance?.addObserver(this);

    _signaling = SignalingProvider();

    _signaling?.onSignalingStateChange = (SignalingState state) {
      switch (state) {
        case SignalingState.ConnectionClosed:
          setState(() {
            AppUtil.isOnline = false;
          });
          break;
        case SignalingState.ConnectionError:
          break;
        case SignalingState.ConnectionReconnected:
        case SignalingState.ConnectionOpen:
          setState(() {
            AppUtil.isOnline = true;
          });

          // _signaling.getPeers();
          break;
      }
    };
    if (!_signaling.isConnected) {
      _signaling.connect();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> checkReviewInfo() async {
    final String tmpInReview =
        await AppUtil.getFromSetting(Constants.PREF_INREVIEW);
    setState(() {
      inReview = tmpInReview;
      AppUtil.showLog('inReview: $inReview');
    });
  }

  Widget getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return inReview == 'true' ? const TabHomeMenu() : screenHomeContainer;
//        return  ScreenHomeContainer();
      case 1:
        return const ScreenThongTinCaNhan();
      case 2:
        return ScreenChinhSachSuDung();
      case 3:
        Future.delayed(const Duration(milliseconds: 200)).then((_) {
          AppUtil.saveToSettting(Constants.PREF_ACCESSTOKEN, '');
          // this code is executed after the future ends.
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/bloc.login', (Route<dynamic> route) => false);
//          Navigator.pushReplacementNamed(context, '/bloc.login');
        });
        return null;
//        return null;
      default:
        return null;
    }
  }

  void onSelectedItem(int index) {
    setState(() {
      selectedDrawerIndex = index;
      Navigator.of(context).pop(); // close the drawer
    });
  }

//  AppUtil appUtil =  AppUtil();
  Widget widgetWhenSuccess(UserInfoData userData) => Column(
        children: <Widget>[
          const SizedBox(height: 45),
          Center(
            child: ClipOval(
              child: userData.base != null &&
                      userData.base.avatar != null &&
                      !appUtil.checkValidLocalPath(userData.base.avatar)
                  ? FadeInImage.assetNetwork(
                      placeholder: 'assets/avata_user.png',
                      image: userData.base.avatar,
                      matchTextDirection: true,
                      fit: BoxFit.cover,
                      width: 80,
                      height: 80,
                    )
                  : Image.asset(
                      'assets/avata_user.png',
                      matchTextDirection: true,
                      fit: BoxFit.cover,
                      width: 80,
                      height: 80,
                    ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            userData.base.fullName ?? 'BỆNH VIỆN ĐA KHOA \n TỈNH PHÚ THỌ',
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: textSizeTitle,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          const SizedBox(
            height: 18,
          ),
        ],
      );

  Widget widgetWhenFailed() => Column(
        children: <Widget>[
          const SizedBox(height: 38),
          const Center(
            child: Text(
              'Tài khoản',
              style: TextStyle(
                  fontSize: textSizeNormal,
                  fontWeight: FontWeight.normal,
                  color: Colors.white),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Center(
              child: ClipOval(
            child: Image.asset(
              'assets/avata_user.png',
              matchTextDirection: true,
              fit: BoxFit.cover,
              width: 120,
              height: 120,
            ),
          )),
          const SizedBox(
            height: 18,
          ),
        ],
      );

  Widget viewAppBar() => AppBar(
      elevation: 0,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.qr_code_outlined),
          color: Constants.colorMain,
          iconSize: 25,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const QRScanPage()));
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications_none),
          color: Constants.colorMain,
          iconSize: 25,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const ScreenListNotifications()));
          },
        )
      ],
      backgroundColor: Constants.background,
      centerTitle: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Xin chào',
            style: TextStyle(
                color: Constants.colorText.withOpacity(0.7),
                fontWeight: FontWeight.normal,
                fontFamily: Constants.fontName,
                fontSize: 13),
          ),
          Text(
            nameUser,
            style: const TextStyle(
                color: Constants.colorText,
                fontWeight: FontWeight.w600,
                fontFamily: Constants.fontName,
                fontSize: 16),
          ),
        ],
      ),
      leading: IconButton(
        onPressed: () {
          // _scaffoldKey.currentState?.openDrawer();
        },
        icon: CircleAvatar(
          radius: 60,
          backgroundColor: Colors.white,
          child: ClipOval(
            child: !imgAvatar.contains('assets/avatar/')
                ? Image.network(
                    imgAvatar,
                    fit: BoxFit.cover,
                    width: 120,
                    height: 120,
                  )
                : Image.asset(
                    imgAvatar,
                    matchTextDirection: true,
                    width: 120,
                    height: 120,
                  ),
          ),
        ),
      ));

  Widget viewDrawer() => Drawer(
        elevation: 20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(color: Constants.colorMain),
              child: BlocBuilder<UserInfoBloc, UserInfoState>(
                  builder: (context, state) {
                if (state is UserInfoInitialState) {
                  return widgetWhenFailed();
                }
                if (state is UserInfoLoadingState) {
                  return widgetWhenFailed();
                }
                if (state is UserInfoLoadedState) {
                  final QueryResult result = state.responseUserInfoData;

                  if (result != null) {
//                          Constants constants =  Constants();
                    //UserInfo thành công
                    final responseData = appUtil.processResponse(result);
                    if (responseData != null) {
                      final int code = responseData.code;
                      final Map data = responseData.data;
                      //    var json = jsonDecode(result.);

                      if (code == 0) {
                        //Login thành công
                        final UserInfoData userData =
                            UserInfoData.fromJson(data);

                        setState(() {
                          nameUser = userData.base.fullName;

                          if (userData.base.avatar != null &&
                              userData.base.avatar.length > 8) {
                            imgAvatar =
                                dotenv.env['BASE_API_URL_AVATAR_DOCTOR'] +
                                    userData.base.avatar;
                          } else {
                            imgAvatar = (userData.base.gender == '1' ||
                                    userData.base.gender == 'male')
                                ? 'assets/avatar/icon_bs_nam.png'
                                : 'assets/avatar/icon_bs_nu.png';
                          }
                        });
                        AppUtil.showLog(
                            'requestGetUserInfo: ${jsonEncode(userData.toJson())}');
                        log('Json data userInfo: ${jsonEncode(userData)}');
                        return widgetWhenSuccess(userData);
                      } else {
                        return widgetWhenFailed();
                      }
                    } else {
                      return widgetWhenFailed();
                    }
                    /*  return Center(
                              child: Text('Tải thông tin tài khoản thành công'));*/
                  } else {
                    if (state is UserInfoErrorState) {
                      return widgetWhenFailed();
                    }
                  }
                  if (state is UserInfoLoadedState) {
                    return widgetWhenFailed();
                  } else if (state is UserInfoErrorState) {
                    return widgetWhenFailed();
                  } else {
                    return widgetWhenFailed();
                  }
                }
                return widgetWhenFailed();
              }),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      inReview == 'true'
                          ? const SizedBox()
                          : Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      const Text('TIỆN ÍCH',
                                          style: TextStyle(
                                              color: Color(0xFF9A9A9A),
                                              fontWeight: FontWeight.normal,
                                              fontSize:
                                                  Constants.Size_text_title)),
                                      const SizedBox(
                                        height: 18,
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            screenHomeContainer.moveToTab(0);
                                            _scaffoldKey.currentState
                                                .openEndDrawer();
                                          },
                                          child: Container(
                                            color: Colors.white,
                                            width: double.infinity,
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                    'assets/icon_home_active.png'),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                const Text('Trang chủ',
                                                    style: Constants
                                                        .styleTextNormalSubColor),
                                              ],
                                            ),
                                          )),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            screenHomeContainer.moveToTab(2);
                                            _scaffoldKey.currentState
                                                .openEndDrawer();
                                          },
                                          child: Container(
                                            color: Colors.white,
                                            width: double.infinity,
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                    'assets/icon_thongbao_32.png'),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                const Text('Thông báo',
                                                    style: Constants
                                                        .styleTextNormalSubColor),
                                              ],
                                            ),
                                          )),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            _scaffoldKey.currentState
                                                .openEndDrawer();
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const ScreenThongKe()));
                                          },
                                          child: Container(
                                            color: Colors.white,
                                            width: double.infinity,
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                    'assets/sitemenu_thongke.png'),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                const Text('Thống kê',
                                                    style: Constants
                                                        .styleTextNormalSubColor),
                                              ],
                                            ),
                                          )),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      GestureDetector(
                                          onTap: () {
//                                    screenHomeContainer.moveToTab(1);
                                            _scaffoldKey.currentState
                                                .openEndDrawer();
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const ScreenDSBenhNhan()));
                                          },
                                          child: Container(
                                            color: Colors.white,
                                            width: double.infinity,
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                    'assets/sitemenu_dsbenhnhan.png'),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                const Text('Bệnh nhân',
                                                    style: Constants
                                                        .styleTextNormalSubColor),
                                              ],
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Divider(
                                  color:
                                      HexColor.fromHex(Constants.Color_divider),
                                ),
                              ],
                            ),
                      inReview == 'true'
                          ? const SizedBox()
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text('TÀI KHOẢN',
                                      style: TextStyle(
                                          color: Color(0xFF9A9A9A),
                                          fontWeight: FontWeight.normal,
                                          fontSize: Constants.Size_text_title)),
                                  const SizedBox(
                                    height: 18,
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        screenHomeContainer.moveToTab(3);
                                        _scaffoldKey.currentState
                                            .openEndDrawer();
                                      },
                                      child: Container(
                                        color: Colors.white,
                                        width: double.infinity,
                                        child: Row(
                                          children: [
                                            Image.asset(
                                                'assets/btmn_canhan_gray.png'),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            const Text('Tài khoản',
                                                style: Constants
                                                    .styleTextNormalSubColor),
                                          ],
                                        ),
                                      )),
                                  const SizedBox(
                                    height: 18,
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ScreenChangePassword()));
                                        _scaffoldKey.currentState
                                            .openEndDrawer();
                                      },
                                      child: Container(
                                        color: Colors.white,
                                        width: double.infinity,
                                        child: Row(
                                          children: [
                                            Image.asset(
                                                'assets/sitemenu_changepass.png'),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            const Text('Đổi mật khẩu',
                                                style: Constants
                                                    .styleTextNormalSubColor),
                                          ],
                                        ),
                                      )),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  GestureDetector(
                                      onTap: () async {
                                        Navigator.pop(context);
                                        final ConfirmAction action =
                                            await appUtil.asyncConfirmDialog(
                                                context,
                                                'Thông báo',
                                                'Bạn có chắc chắn muốn đăng xuất?');
                                        if (action == ConfirmAction.ACCEPT) {
                                          await Future.delayed(const Duration(
                                                  milliseconds: 200))
                                              .then((_) {
//                                        AppUtil.isLogin = false;
                                            AppUtil.saveToSettting(
                                                Constants.PREF_ACCESSTOKEN, '');
                                            AppUtil.saveToSettting(
                                                Constants.PREF_PASSWORD, '');
                                            // this code is executed after the future ends.
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    CupertinoPageRoute(
                                                      builder: (context) =>
                                                          ScreenLogin(),
                                                    ),
                                                    (route) => false);
//                                Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
                                          });
                                        } else if (action ==
                                            ConfirmAction.CANCEL) {}
                                      },
                                      child: Container(
                                        color: Colors.white,
                                        width: double.infinity,
                                        child: Row(
                                          children: [
                                            Image.asset(
                                                'assets/icon_logout.png'),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            const Text('Đăng xuất',
                                                style: TextStyle(
                                                    color: Color(0xFFFF2929),
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: Constants
                                                        .Size_text_normal)),
                                          ],
                                        ),
                                      )),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) =>
      inReview == 'true' ? viewReview() : viewNoReview();

  Widget viewNoReview() => WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: viewAppBar(),
          drawer: viewDrawer(),
          body: getDrawerItemWidget(selectedDrawerIndex),
        ),
      );

  Widget viewReview() => WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          drawer: viewDrawer(),
          body: getDrawerItemWidget(selectedDrawerIndex),
        ),
      );

  Future<bool> _onWillPop() =>
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Thông báo'),
          content: const Text('Bạn có chắc chắn muốn thoát ứng dụng'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Không'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Có'),
            ),
          ],
        ),
      ) ??
      false;
}
