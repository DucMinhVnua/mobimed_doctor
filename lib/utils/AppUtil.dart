import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_platform/universal_platform.dart';

import '../extension/HexColor.dart';
import '../model/OBWheelData.dart';
import '../model/ResponseData.dart';
import '../model/ResponseDataWithPages.dart';
import '../screen/house/book_appointment/screen_house_cart_service.dart';
import '../screen/house/house_appoinmrnt_data.dart';
import '../screen/notification/ScreenListNotifications.dart';
import '../utils/LoadingDialog.dart';
import 'Constant.dart';

enum ConfirmAction { CANCEL, ACCEPT }
//enum AppointmentState { WAITING, CANCEL, APPROVE, SERVED }

class AppUtil {
  Constants constants = Constants();
  String appFolderName = 'DKPT_NoiBo';
  static String userId = '';
  static bool isOnline = false;
  static bool isReadMessage = false;

  static Widget imageAvatarDoctor(
          String img, String gender, double width, double height) =>
      img != null && img.trim().isNotEmpty
          ? Image.network(
              dotenv.env['BASE_API_URL_AVATAR_DOCTOR'] + img,
              fit: BoxFit.cover,
              width: width,
              height: height,
            )
          : Image.asset(
              (gender == '1' || gender == 'male')
                  ? 'assets/avatar/icon_baby_boy.png'
                  : 'assets/avatar/icon_baby_girl.png',
              matchTextDirection: true,
              fit: BoxFit.cover,
              width: width,
              height: height,
            );

  static String convertToAgo(DateTime input) {
    final Duration diff = DateTime.now().difference(input);

    if (diff.inDays >= 1) {
      return '${diff.inDays} ngày';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours} giờ';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes} phút';
    } else if (diff.inSeconds >= 1) {
      return '${diff.inSeconds} giây';
    } else {
      return 'vừa mới';
    }
  }

  static List<HomeMedicalServiceData> arrCartServices = [];

  static Widget customAppBarCart(BuildContext context, String name) =>
      PreferredSize(
          preferredSize: const Size(double.infinity, 100),
          child: Container(
            padding: const EdgeInsets.only(top: 8, bottom: 12),
            height: 100,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg_app_bar.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // iconBack(context),
                  SizedBox(
                      width: 50,
                      height: 35,
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.navigate_before,
                              size: 30, color: Constants.white))),
                  Text(
                    name,
                    style: Constants.styleTextTitleAppBar,
                  ),
                  AppUtil.arrCartServices.isNotEmpty
                      ? InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>
                                      const ScreenHouseCartServices()),
                            );
                          },
                          child: SizedBox(
                              width: 40,
                              height: 55,
                              child: Stack(
                                children: [
                                  // const IconButton(
                                  //     icon: Icon(Icons.shopping_cart_outlined,
                                  //         size: 30, color: Constants.colorText)),
                                  Positioned(
                                      bottom: 0,
                                      right: 12,
                                      child: Image.asset(
                                        'assets/icons_utilities/icn_cart.png',
                                        fit: BoxFit.fill,
                                        color: Constants.white,
                                        // height: 27, //double.infinity,
                                        width: 25, //double.infinity,
                                      )),
                                  Positioned(
                                      bottom: 15,
                                      right: 3,
                                      child: Container(
                                          width: 20,
                                          height: 20,
                                          padding: const EdgeInsets.only(
                                              top: 3, bottom: 3),
                                          decoration: BoxDecoration(
                                              // color: Colors.orangeAccent,
                                              // border: Border.all(
                                              //     color: HexColor.fromHex(
                                              //         Constants.colorDivider)),
                                              // borderRadius: const BorderRadius.all(
                                              //     Radius.circular(25))
                                              color: Constants.white,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(25)),
                                              border: Border.all(
                                                  color:
                                                      const Color(0xFFFE3030))),
                                          child: Text(
                                            AppUtil.arrCartServices.length
                                                .toString(),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                color: Color(0xFFFE3030),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0,
                                                fontFamily: Constants.fontName),
                                          )))
                                ],
                              )))
                      : const SizedBox(width: 50, height: 35)
                ]),
          ));

  static Widget customAppBarMain(BuildContext context, String name) =>
      PreferredSize(
          preferredSize: const Size(double.infinity, 100),
          child: Container(
            padding:
                const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 12),
            height: 100,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg_app_bar.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    name,
                    style: Constants.styleTextTitleAppBar,
                  ),
                ]),
          ));

  static Widget searchWidget(String hintSearch, Function onchangeHandler,
          TextEditingController edittingController) =>
      Container(
          height: 50,
          width: double.infinity,
          margin:
              const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
          color: Constants.white,
          child: Center(
            child: TextField(
              style: const TextStyle(
                  color: Color(0xFF000000),
                  fontWeight: FontWeight.normal,
                  fontFamily: Constants.fontName,
                  fontSize: 16),
              onChanged: onchangeHandler,
              onSubmitted: onchangeHandler,
              controller: edittingController,
              // decoration: InputDecoration(
              //   filled: true,
              //   fillColor: Colors.white,
              //   hintText: hintSearch,
              //   suffixIcon: const Icon(Icons.search),
              //   border: InputBorder.none,
              // ),
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.all(
                    Radius.circular(35),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    width: 2,
                    color: Constants.colorMain,
                  ),
                  borderRadius: BorderRadius.circular(35),
                ),
                filled: true,
                fillColor: Constants.colorTextHint.withOpacity(0.1),
                hintText: hintSearch,
                suffixIcon: const Icon(Icons.search),
                border: InputBorder.none,
              ),
            ),
          ));
  static Widget parseHomeAppoinmentState(String state) {
    Color tmpColor;
    String strStateName = '';
    switch (state) {
      case 'serving':
        strStateName = 'Đang phục vụ';
        tmpColor = Colors.yellow;
        break;
      case 'processing':
        strStateName = 'Đang xử lý';
        tmpColor = Colors.orange;
        break;
      case 'done':
        strStateName = 'Hoàn thành';
        tmpColor = Colors.green;
        break;
      case 'accepted':
        strStateName = 'Đã được bác sĩ nhận';
        tmpColor = Colors.blue;
        break;
      case 'terminated':
        strStateName = 'Hủy khám';
        tmpColor = Colors.red;
        break;
      case 'doctor_terminated':
        strStateName = 'Hủy khám';
        tmpColor = Colors.red;
        break;
    }
    return Text(strStateName, style: TextStyle(color: tmpColor, fontSize: 13));
  }

// Xử lý dữ liệu trả về
  saveOBWheel(List<OBWheelData> arrMediaFile) async {
    print('Save OBWheel');
    final String jsonUser = jsonEncode(arrMediaFile);
//    print("Json Saved: " + jsonUser);
    //Lưu tạm file queue
    //Lưu trên local
    await saveToSettting(Constants.PREF_QUEUE_OBWHEEL, jsonUser);
  }

  Future<List<OBWheelData>> getOBWheelHistory() async {
    // getFromSetting lấy dữ liệu local
    final String jsonQueueObWheel =
        await getFromSetting(Constants.PREF_QUEUE_OBWHEEL);
//    print("jsonQueueUpload: " + jsonQueueUpload);
    if (jsonQueueObWheel == null || jsonQueueObWheel.trim() == '') {
      return [];
    } else {
      // store json data into list
      final list = json.decode(jsonQueueObWheel) as List;
      var listOBWheel = list.map((p) => OBWheelData.fromJsonMap(p)).toList();
      if (listOBWheel == null) {
        print('listOBWheel NULL  ==> Create List ');
        listOBWheel = [];
      }

      print('getQueueUpload result listOBWheel size: ' +
          listOBWheel.length.toString());
      return listOBWheel;
    }
  }

  // ignore: missing_return
  String getFilePathFromAppFolder() {}

  dismissKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  textFieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  // chuyển đổi html string để hiển thị lên text
  String parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;
    return parsedString;
  }

  // Kiểm tra phải là số thực hay không?
  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  // Đổi trạng thái cuộc hẹn sang string
  String parseAppointmentState(String processENUM) {
    String strOut = '';
    switch (processENUM.toUpperCase()) {
      case 'WAITING':
        strOut = 'Chưa xác nhận';
        break;
      case 'APPROVE':
        strOut = 'Đã duyệt';
        break;
      case 'SERVED':
        strOut = 'Đã đến khám';
        break;
      case 'CANCEL':
        strOut = 'Hủy khám';
        break;
    }
    return strOut;
  }

  Widget parseAppoinmentStateWidget(String state) {
    Color tmpColor = HexColor.fromHex('#FF9900');
//    Text textView ;
    // Text(appUtil.parseAppoinmentState(itemData.state), style: TextStyle(color: Colors.white, fontSize: Constants.Size_text_normal),),
    String strStateName = '';
    switch (state) {
      case 'WAITING':
        strStateName = 'Chưa xác nhận';
        tmpColor = HexColor.fromHex('#FF9900');
        break;
      case 'APPROVE':
        strStateName = 'Đã duyệt'; //319243
        tmpColor = HexColor.fromHex('#319243');
        break;
      case 'SERVED':
        strStateName = 'Đã đến khám';
        tmpColor = HexColor.fromHex('#1B92F6');
        break;
      case 'CANCEL':
        strStateName = 'Hủy khám';
        tmpColor = HexColor.fromHex('#F84366');
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        border: Border.all(
            color: tmpColor, // set border color
            width: 1), // set border width
        borderRadius: const BorderRadius.all(Radius.circular(
            15)), // set rounded corner radiusake rounded corner of border
      ),
      child: Text(
        strStateName,
        style: TextStyle(color: tmpColor, fontSize: Constants.Size_text_small),
      ),
    );
  }

  String parseScope(String scopeKey) {
    String strScopeName = '';
    switch (scopeKey) {
      case 'ALL_STAFF':
        strScopeName = 'Toàn thể nhân viên công ty';
        break;
      case 'ALL_STAFF_OF_DEPARTMENT':
        strScopeName = 'Toàn thể nhân viên thuộc khoa';
        break;
      case 'GROUP':
        strScopeName = 'Nhóm';
        break;
      case 'PERSONAL':
        strScopeName = 'Cá nhân';
        break;
      case 'PERSONAL':
        strScopeName = 'Cá nhân';
        break;
    }
    return strScopeName;
  }

  // Lấy id thiết bị
  Future<String> getDeviceId() async {
    String identifier;
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (UniversalPlatform.isAndroid) {
      final AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      identifier = androidDeviceInfo.androidId; // unique ID on Android
    } else if (UniversalPlatform.isIOS) {
      final IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      identifier = iosDeviceInfo.identifierForVendor; // unique ID on iOS
    }
    showLog('getDeviceId: $identifier');
    return identifier;
//    if (Theme.of(context).platform == TargetPlatform.iOS) {
//      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
//      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
//    } else {
//      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
//      return androidDeviceInfo.androidId; // unique ID on Android
//    }
  }
/*  Future<String> getDeviceId(BuildContext context) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      showLog("getDeviceId: " + iosDeviceInfo.identifierForVendor);
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      showLog("getDeviceId: " + androidDeviceInfo.androidId);
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }*/

/*  //call this method from init state to create folder if the folder is not exists
  Future<void>  createAppFolder(bool isEditArticle) async {
    try{
      //create Variable
      String directory = (await getApplicationDocumentsDirectory()).path;
      String appDirectory = directory + "/" + appFolderName;
      if (await Directory(appDirectory).exists() != true) {
        print("Directory $appDirectory not exist");
        io.Directory(appDirectory).createSync(recursive: true);
        //do your work
      } else {
        print("Directory $appDirectory exist");

        //Trong trường hợp không phải là edit article ==> nếu queue upload rỗng thì sẽ xóa tất cả các file thừa cho khỏi nặng máy
        final myDir = io.Directory(appDirectory);
        List<io.FileSystemEntity> _images;
        _images = myDir.listSync(recursive: true, followLinks: false);

      }
    }catch(ex){
      print(ex.toString());
    }
  }*/

/*  Future<String> saveFile(io.File _file, String _fileName) async {
    String directory = (await getApplicationDocumentsDirectory()).path;
    String path = directory + "/" + appFolderName;
    // copy the file to a path
    String fileFullPath = '$path/$_fileName';
    final io.File newFile = await _file.copy(fileFullPath);
//    final io.File newImage = await _file.copy(fileFullPath);
//    io.File file = io.File(fileFullPath);
//    await file.writeAsBytes(_file.readAsBytesSync());
    if((await newFile.exists()) == true && (await newFile.length()) > 0) {
      print("File $_fileName saved to path: $fileFullPath");
      String newFilePath = newFile.path;
      print("File $_fileName get path: $newFilePath");
    }else{
      print("File $_fileName DON'T saved to path: $fileFullPath");
    }
    return fileFullPath;
  }*/

/*   deleteAllFileFromAppFolder() async {
    try{
      String directory = (await getApplicationDocumentsDirectory()).path;
      String path = directory + "/" + appFolderName;
      // copy the file to a path

      //up xong thì xóa file gốc đi
      final dir = io.Directory(path);
      dir.deleteSync(recursive: false); //chỉ xóa file bên trong

      print("Remove all File from $path success");
    }catch(e){
      print("Error deleteAllFileFromAppFolder: " + e.toString());
    }
  }*/

  // Kiểm tra đường dẫn local hợp lệ
  bool checkValidLocalPath(String path) {
    bool isLocal = true;
    if (!path.contains('http')) {
      isLocal = true;
    } else {
      isLocal = false;
    }
    return isLocal;
  }

  String formatNameByCurrentTime(String _prefixWithLine) {
    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat('ddMMyyyy_HHmmss').format(now);
    return _prefixWithLine + formattedDate;
  }

  // ignore: unused_element
  MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder) =>
      MaterialPageRoute(
        settings: settings,
        builder: (ctx) => builder,
      );

  static AppBar getAppBar(Text textTitle) => AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.normal),
        backgroundColor: HexColor.fromHex(Constants.Color_primary),
        title: textTitle,
      );

  static Widget customTabBar(
          TabController tabController, List<String> selectTitle) =>
      Container(
          height: 30,
          margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
          decoration: BoxDecoration(
            border: Border.all(color: Constants.colorMain),
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Constants.colorShadow.withOpacity(0.2),
                  offset: const Offset(1.1, 5),
                  blurRadius: 8),
            ],
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.white),
            child: TabBar(
                indicatorColor: Constants.colorShadow.withOpacity(0.2),
                controller: tabController,
                unselectedLabelColor: Constants.colorMain,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xFF32C5FF), Color(0xFF61E4FF)]),
                  borderRadius: BorderRadius.circular(15),
                  // color: Colors.redAccent
                ),
                tabs: selectTitle
                    .map((tabName) =>
                        Tab(child: Text(tabName, style: Constants.titleSelect)))
                    .toList()),
          ));

  static AppBar customAppBar(BuildContext context, String textTitle) => AppBar(
      titleTextStyle: const TextStyle(
          color: Colors.white, fontSize: 18, fontWeight: FontWeight.normal),
      backgroundColor: Constants.white,
      title: Text(
        textTitle,
        style: const TextStyle(
            color: Constants.colorMain,
            fontWeight: FontWeight.w500,
            fontFamily: Constants.fontName,
            letterSpacing: 0,
            fontSize: 18),
      ),
      leading: iconBack(context),
      elevation: 0);

  static Widget iconBack(BuildContext context) => InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          width: 30,
          height: 30,
          decoration: BoxDecoration(
              // color: Colors.blueAccent,
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              boxShadow: [
                BoxShadow(
                    color: Constants.colorShadow
                        .withOpacity(0.5), // Colors.black12,
                    offset: const Offset(1.1, 1.1),
                    spreadRadius: 3,
                    blurRadius: 3)
              ]),
          child: const Icon(Icons.navigate_before,
              size: 30, color: Constants.colorMain),
        ),
      );

  static AppBar customAppBarBackFunction(
          BuildContext context, String textTitle, Function onClick) =>
      AppBar(
          titleTextStyle: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.normal),
          backgroundColor: Constants.white,
          title: Text(
            textTitle,
            style: const TextStyle(
                color: Constants.colorMain,
                fontWeight: FontWeight.w500,
                fontFamily: Constants.fontName,
                letterSpacing: 0,
                fontSize: 18),
          ),
          leading: iconBackFunction(context, onClick),
          elevation: 0);

  static Widget iconBackFunction(BuildContext context, Function onClick) =>
      InkWell(
        onTap: onClick,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          width: 30,
          height: 30,
          decoration: BoxDecoration(
              // color: Colors.blueAccent,
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              boxShadow: [
                BoxShadow(
                    color: Constants.colorShadow
                        .withOpacity(0.5), // Colors.black12,
                    offset: const Offset(1.1, 1.1),
                    spreadRadius: 3,
                    blurRadius: 3)
              ]),
          child: const Icon(Icons.navigate_before,
              size: 30, color: Constants.colorMain),
        ),
      );

  AppBar getAppBarWithNotificationButton(
          BuildContext context, Text textTitle) =>
      AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ScreenListNotifications()));
            },
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.normal),
        backgroundColor: HexColor.fromHex(Constants.Color_primary),
        title: textTitle,
      );

  AppBar getAppBarWithFunctionButton(
          BuildContext context, Text textTitle, IconButton iconButton) =>
      AppBar(
        actions: <Widget>[
          iconButton,
        ],
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.normal),
        backgroundColor: HexColor.fromHex(Constants.Color_primary),
        title: textTitle,
      );

  SharedPreferences sharedPreferences;
  String getStringFromSetting(String key) {
    const String _outValue = '';
    try {
      SharedPreferences.getInstance().then((SharedPreferences sp) {
        sharedPreferences = sp;
        String _outValue = sharedPreferences.getString(key);
        // will be null if never previously saved
        _outValue ??= '';
      });
    } on Exception catch (e) {
      e.toString();
    }

    return _outValue;
  }

  /// ------------------------------------------------------------
  /// Method that returns the user decision to allow notifications
  /// ------------------------------------------------------------
  static Future<String> getFromSetting(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(key) ?? '';
  }

  /// ----------------------------------------------------------
  /// Method that saves the user decision to allow notifications
  /// ----------------------------------------------------------
  static Future<bool> saveToSettting(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(key, value);
  }

  Future<bool> saveBoolToSettting(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setBool(key, value);
  }

  ResponseData processResponse(QueryResult responseResult) {
    ResponseData responseData;
    try {
      if (responseResult != null && responseResult.data != null) {
//        Map<String, dynamic> response = responseResult.data[];
        final mapResponse = responseResult.data['response'] as Map;
        final data = mapResponse['data'];
//        var data = mapResponse['data'] as Map;
        final int code = mapResponse['code'];
        final String message = mapResponse['message'];
//    var mapResponse = json.decode(response) as Map<String, dynamic>;
//    var responseJson = response["response"];
//    int code = responseJson["code"];
//    String message = responseJson["message"];
//    data = responseJson["data"];
        responseData = ResponseData(code, message, data);
      } else {
        print('processResponse responseResult NULL');
      }
      // ignore: unused_catch_clause
    } on FormatException catch (e) {
//      AppUtil appUtil = AppUtil();
//      appUtil.hideDialog(context);
      print('The provided string is not valid JSON');
    }
    return responseData;
  }

  ResponseDataWithPages processResponseWithPage(QueryResult responseResult) {
    ResponseDataWithPages responseData;
    try {
      if (responseResult != null && responseResult.data != null) {
//        Map<String, dynamic> response = responseResult.data[];
        final mapResponse = responseResult.data['response'] as Map;
        final data = mapResponse['data'];
//        var data = mapResponse['data'] as Map;
        final int code = mapResponse['code'];
        final String message = mapResponse['message'];
        final int page = mapResponse['page'];
        final int pages = mapResponse['pages'];
//    var mapResponse = json.decode(response) as Map<String, dynamic>;
//    var responseJson = response["response"];
//    int code = responseJson["code"];
//    String message = responseJson["message"];
//    data = responseJson["data"];
        responseData = ResponseDataWithPages(code, message, data, page, pages);
      } else {
        print('processResponse responseResult NULL');
      }
    } on FormatException {
//      AppUtil appUtil = AppUtil();
//      appUtil.hideDialog(context);
      print('The provided string is not valid JSON');
    }
    return responseData;
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,1800}'); // 1800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  static void showLog(String text) {
    debugPrint(text);
  }

  static void showLogFull(String text) {
    log(text);
  }

  static void showPrint(Object object) {
    if (kDebugMode) {
      print(object);
    }
  }

//  bool _load = false;
  /* static ProgressDialog pr;
  static showLoadingDialog(BuildContext context) async {
    print("############ CALL showLoadingDialog");
    if(pr == null){
//      pr = ProgressDialog(context);
      pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    }
//    pr.
    pr.style(
        message: 'Vui lòng chờ...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );
    await pr.show();
  }
  static hideLoadingDialog(BuildContext context) {
    print("############ CALL hideLoadingDialog");
    if(pr != null ){
//    if(pr != null && pr.isShowing()){
      pr.hide();
    }
  }*/
  static LoadingDialog loadingDialog;

  static void showLoadingDialog(BuildContext context) async {
    print('AppUtil showLoadingDialog');
    await Future.delayed(const Duration(milliseconds: 30));
    await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) =>
            loadingDialog = loadingDialog ?? LoadingDialog());
    //builder: (BuildContext context) => WillPopScope(child:loadingDialog = LoadingDialog() , onWillPop:  () async => false,));
  }

  static void showLoadingDialogWithTitle(
      BuildContext context, String title) async {
    await Future.delayed(const Duration(milliseconds: 30));
    await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) =>
            loadingDialog = loadingDialog ?? LoadingDialog());
    //builder: (BuildContext context) => WillPopScope(child:loadingDialog = LoadingDialog() , onWillPop:  () async => false,));
  }

  // ignore: missing_return
  static Future hideLoadingDialog(BuildContext context) {
    print('AppUtil hideLoadingDialog');
    if (loadingDialog != null && loadingDialog.isShowing()) {
      Navigator.of(context).pop();
      loadingDialog = null;
    }
  }

  Widget loadingView(bool isLoading) => isLoading
      ? Container(
          color: Colors.grey[300],
          width: 70,
          height: 70,
          child: const Padding(
              padding: EdgeInsets.all(5),
              child: Center(child: CircularProgressIndicator())),
        )
      : Container();

  void showToastWithScaffoldState(
      GlobalKey<ScaffoldState> _scaffoldKey, String message) {
    ScaffoldMessenger.of(_scaffoldKey.currentContext).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void showToast(BuildContext context, String message) {
    try {
      final scaffold = Scaffold.of(context);
      ScaffoldMessenger.of(scaffold.context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 3),
        ),
      );
    } on Exception catch (e) {
      print('Error showToast: ' + e.toString());
    }
  }

  static String convertMoney(str) {
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: '');
    return '${formatCurrency.format(str)} VNĐ';
  }

  static String convertMoney2(str) {
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: '');
    return '${formatCurrency.format(str)}';
  }

// ============== TIME
  static Widget widgetTimeClock(DateTime dateTime) => Container(
      width: 85,
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
      decoration: BoxDecoration(
        color: Constants.colorMain,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        border: Border.all(color: Constants.colorMain),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              const Icon(Icons.timer_rounded, color: Constants.white, size: 22),
              Text(
                DateFormat('HH:mm').format(dateTime),
                style: const TextStyle(
                    color: Constants.white,
                    fontWeight: FontWeight.w800,
                    fontFamily: Constants.fontName,
                    fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(DateFormat('dd').format(dateTime),
              style: const TextStyle(
                  color: Constants.white,
                  fontWeight: FontWeight.w800,
                  fontFamily: Constants.fontName,
                  fontSize: 18)),
          Text(
              DateFormat('EEEE', 'vi_VN').format(
                dateTime,
              ),
              style: const TextStyle(
                  color: Constants.white,
                  fontWeight: FontWeight.w800,
                  fontFamily: Constants.fontName,
                  fontSize: 15)),
        ],
      ));

  static Widget widgetTime(DateTime dateTime) => Container(
        padding: const EdgeInsets.only(top: 3, bottom: 3, left: 3, right: 3),
        margin: const EdgeInsets.only(right: 8),
        width: 75,
        decoration: const BoxDecoration(
          color: Color(0xFF54C1FB),
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              (dateTime != null) ? DateFormat('dd').format(dateTime) : '',
              style: const TextStyle(
                  color: Constants.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: Constants.fontName,
                  fontSize: 32),
            ),
            Text(
                (dateTime != null)
                    ? 'Tháng: ${DateFormat('MM').format(dateTime)}'
                    : '',
                style: const TextStyle(
                    color: Constants.white,
                    fontWeight: FontWeight.w700,
                    fontFamily: Constants.fontName,
                    fontSize: 15)),
          ],
        ),
      );

  static Future<void> showPopup(
      BuildContext context, String title, String content) async {
    // flutter defined function
    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          TextButton(
            child: const Text('Đóng'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<void> showPopupWithFunction(BuildContext context, String title,
      String content, Function onClickFunction) async {
    // flutter defined function
    await showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) => Transform.scale(
              scale: a1.value,
              child: Opacity(
                opacity: a1.value,
                child: AlertDialog(
                  title: Text(title),
                  content: Text(content),
                  actions: <Widget>[
                    // usually buttons at the bottom of the dialog
                    TextButton(
                      child: const Text('Đóng'),
                      onPressed: () {
                        // ignore: unnecessary_statements
                        onClickFunction;
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ),
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        // ignore: missing_return
        pageBuilder: (context, animation1, animation2) {});
  }

  Future<void> showPopupAllScreen(BuildContext context, String urlImg) async {
    final heighScreen = MediaQuery.of(context).size.height;
    final widthScreen = MediaQuery.of(context).size.width;
    await showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) => Transform.scale(
              scale: a1.value,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  (heighScreen > widthScreen)
                      ? SizedBox(
                          width: widthScreen * 0.9,
                          child: Image.network(urlImg))
                      : SizedBox(
                          height: heighScreen * 0.9,
                          child: Image.network(urlImg)),
                ],
              ),
            ),
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        // ignore: missing_return
        pageBuilder: (context, animation1, animation2) {});
  }

  void showPopupWithFunctionScaffordKey(GlobalKey<ScaffoldState> _scaffoldKey,
      String title, String content, Function onClickFunction) {
    // flutter defined function
    showDialog(
      context: _scaffoldKey.currentContext,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          TextButton(
            child: const Text('Đóng'),
            onPressed: () {
              // ignore: unnecessary_statements
              onClickFunction;
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<ConfirmAction> asyncConfirmDialog(
          BuildContext context, String title, String message) async =>
      showDialog<ConfirmAction>(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
            TextButton(
              child: const Text('Đồng ý'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
              },
            )
          ],
        ),
      );

  static String timeAgoSinceDate(DateTime date, {bool numericDates = true}) {
//    DateTime date = DateTime.parse(dateString);
    final date2 = DateTime.now();
    final difference = date2.difference(date);

    if ((difference.inDays / 365).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} năm trước';
    } else if ((difference.inDays / 365).floor() >= 1) {
      return numericDates ? '1 năm trước' : 'Năm trước';
    } else if ((difference.inDays / 30).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} tháng trước';
    } else if ((difference.inDays / 30).floor() >= 1) {
      return numericDates ? '1 tháng trước' : 'Tháng trước';
    } else if ((difference.inDays / 7).floor() >= 2) {
      return '${(difference.inDays / 7).floor()} tuần trước';
    } else if ((difference.inDays / 7).floor() >= 1) {
      return numericDates ? '1 tuần trước' : 'Tuần trước';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inDays >= 1) {
      return numericDates ? '1 ngày trước' : 'Hôm qua';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inHours >= 1) {
      return numericDates ? '1 giờ trước' : 'giờ trước';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} phút trước';
    } else if (difference.inMinutes >= 1) {
      return numericDates ? '1 phút trước' : '1 phút trước';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} giây trước';
    } else {
      return 'Vừa xong';
    }
  }
}
