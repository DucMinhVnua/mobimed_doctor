import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:universal_platform/universal_platform.dart';

import '../../controller/ApiGraphQLControllerMutation.dart';
import '../../controller/ApiGraphQLControllerQuery.dart';
import '../../controller/UserApiGraphQLControllerQuery.dart';
import '../../design_widget/widget_button_icon.dart';
import '../../extension/HexColor.dart';
import '../../model/DeviceInput.dart';
import '../../model/GraphQLModels.dart';
import '../../model/UserInfoData.dart';
import '../../utils/AppUtil.dart';
import '../../utils/Constant.dart';
import '../OBWheel/ScreenOBWheelContainer.dart';
import '../house/screen_house_appoinment.dart';
import '../manage_appointment/ScreenQLDatKhamContainer.dart';
import '../manage_conclusion/ScreenQLKhamBenhContainer.dart';
import '../manage_indication/ScreenQLChiDinhContainer.dart';
import '../manage_prescription/ScreenQLDonThuoc.dart';
import '../news/ContentHotNews.dart';
import '../news/ContentListNews.dart';
import '../news/ScreenListNews.dart';
import '../re_examination/ScreenQLTaiKhamContainer.dart';
import 'box_tittle.dart';
import 'box_utilities.dart';

class TabHomeMenu extends StatefulWidget {
  const TabHomeMenu({Key key}) : super(key: key);

  @override
  _TabHomeMenuState createState() => _TabHomeMenuState();
}

class _TabHomeMenuState extends State<TabHomeMenu> {
  Constants constants = Constants();
  AppUtil appUtil = AppUtil();
  String inReview = 'true';

  @override
  void initState() {
    super.initState();

//    _future =  checkReviewInfo();
    WidgetsBinding.instance.addPostFrameCallback((_) => checkReviewInfo());
  }

  checkReviewInfo() async {
    final String tmpInReview =
        await AppUtil.getFromSetting(Constants.PREF_INREVIEW);
    if (mounted) {
      setState(() {
        inReview = tmpInReview;
      });
    }
    if (tmpInReview == 'false') {
      requestGetAccountInfo(context);
    }
  }

  Future<void> requestGetAccountInfo(BuildContext _context) async {
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
        //    var json = jsonDecode(result.);

        if (code == 0) {
          //Login thành công
          final UserInfoData userData = UserInfoData.fromJson(data);
          AppUtil.showLogFull(
              'requestGetAccountInfo: ${jsonEncode(userData.toJson())}');

          requestRegisterDevice(context, userData.id);
        } else {
          AppUtil.showLog(
              'requestGetAccountInfo code: $code, message: $message');
        }
      }
    } on Exception catch (e) {
      AppUtil.showLog('requestRegisterDevice Error: $e');
    }
  }

  Future<void> requestRegisterDevice(
      BuildContext _context, String userSubID) async {
    try {
      final String fcmID = await AppUtil.getFromSetting(Constants.PREF_FCM_ID);
      final DeviceInput pushDeviceInput = DeviceInput();
      if (UniversalPlatform.isAndroid) {
        pushDeviceInput.platform = 'ANDROID';
      } else if (UniversalPlatform.isIOS) {
        pushDeviceInput.platform = 'IOS';
      }
      pushDeviceInput
        ..userId = userSubID
        ..tokenId = fcmID
        ..uniqueId = await appUtil.getDeviceId();

      final ApiGraphQLControllerMutation apiController =
          ApiGraphQLControllerMutation();
      final QueryResult result =
          await apiController.requestRegisterDevice(_context, pushDeviceInput);
      AppUtil.showLog('Response requestRegisterDevice: ${result.data}');
      final responseData = appUtil.processResponse(result);
      if (responseData != null) {
        final int code = responseData.code;
        final String message = responseData.message;
//        Map data = responseData.data;
        AppUtil.showLog('requestRegisterDevice code: $code, message: $message');
      } else {
//        AppUtil.hideLoadingDialog(_context);
        AppUtil.showLog('requestRegisterDevice: Response NULL');
      }
    } on Exception catch (e) {
      AppUtil.showLog('requestRegisterDevice Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: inReview == 'true' ? viewReviewApp() : viewNoReviewApp(),
        ),
      );

  TextStyle styleText = TextStyle(
      color: Constants.colorText.withOpacity(0.9),
      fontWeight: FontWeight.normal,
      fontFamily: Constants.fontName,
      fontSize: 14);

  Widget viewNoReviewApp() => Column(children: <Widget>[
        // const BoxPatient(),
        BoxUtilities(context: context),
        // BoxTitle(
        //     titleTxt: 'Đặt khám mới',
        //     subTxt: 'Xem thêm',
        //     onClick: onClickMoreMedical),
        // const BoxMedical(),
        BoxTitle(
            titleTxt: 'Tin tức', subTxt: 'Xem thêm', onClick: onClickMoreNews),
        const ContentListNews(),
      ]);

  void onClickMoreNews() {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const ScreenListNews()));
  }

  void onClickMoreMedical() {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const ScreenListNews()));
  }

  Widget viewReviewApp() => Column(children: <Widget>[
        const ContentHotNews(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            WidgetButtonIcon(
                iconUrl: 'assets/tintuc_48.png',
                menuTitle: 'TIN TỨC',
                clickButton: () {
                  onClickNews();
                }),
          ],
        ),
        Container(
          width: double.infinity,
          height: 1,
          color: HexColor.fromHex(Constants.Color_divider),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            WidgetButtonIcon(
                iconUrl: 'assets/tuoithai_48.png',
                menuTitle: 'TÍNH TUỔI THAI',
                clickButton: () {
                  onClickOBWheel();
                }),
          ],
        ),
        Container(
          width: double.infinity,
          height: 1,
          color: HexColor.fromHex(Constants.Color_divider),
        ),
        const SizedBox(
          height: 500,
          child: ContentListNews(),
        )
      ]);

  Future<void> requestGetNews() async {
    try {
      final List<FilteredInput> arrFilterinput = [];
      final List<SortedInput> arrSortedinput = [];

      // ignore: avoid_init_to_null
      String response = null;
      // ignore: avoid_init_to_null
      QueryResult result = null;
      final String inReview =
          await AppUtil.getFromSetting(Constants.PREF_INREVIEW);
      if (inReview == 'true') {
        arrFilterinput.add(FilteredInput('type', 'USER_NEWS', ''));
        arrSortedinput.add(SortedInput('createdTime', true));
        final UserApiGraphQLControllerQuery apiController =
            UserApiGraphQLControllerQuery();

        result = await apiController.requestGetNewsArticles(
            context, 0, arrFilterinput, arrSortedinput);
        response = result.data.toString();
      } else {
        arrFilterinput.add(FilteredInput('type', 'INTERNAL_NEWS', ''));
        arrSortedinput.add(SortedInput('createdTime', true));
        final ApiGraphQLControllerQuery apiController =
            ApiGraphQLControllerQuery();

        result = await apiController.requestGetNewsArticles(
            context, 0, arrFilterinput, arrSortedinput);
        response = result.data.toString();
      }

      AppUtil.showPrint('Response requestGetNewsArticles: $response');
      if (response != null && result != null) {
        final responseData = appUtil.processResponseWithPage(result);
        final int code = responseData.code;
        final String message = responseData.message;
//    var json = jsonDecode(result.);

        if (code != 0) {
          await AppUtil.showPopup(context, 'Thông báo', message);
        }
      } else {
        await AppUtil.showPopup(context, 'Thông báo',
            'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại');
      }
    } on Exception catch (e) {
      AppUtil.showPrint('requestGetNewsArticles Error: $e');
    }
  }

  void onClickNews() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ScreenListNews()),
    );
  }

  void onClickOBWheel() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ScreenOBWheelContainer()),
    );
  }

  void onClickQLKhamBenh() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const ScreenQLKhamBenhContainer()),
    );
  }

  void onClickQLDatKham() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ScreenQLDatKhamContainer()),
    );
  }

  void onClickHouseAppoinment() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ScreenHouseAppoinment()),
    );
  }

  void onClickQLChiDinh() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ScreenQLChiDinhContainer()),
    );
  }

  void onClickQLTaiKham() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ScreenQLTaiKhamContainer()),
    );
  }

  void onClickQLDonThuoc() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ScreenQLDonThuoc()),
    );
  }
}
