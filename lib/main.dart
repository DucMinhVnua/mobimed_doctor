import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher.dart';

import 'bloc/login/login_bloc.dart';
import 'bloc/userinfo/userinfo_bloc.dart';
import 'fcm/message.dart';
import 'repository/LoginRepository.dart';
import 'repository/UserInfoRepository.dart';
import 'screen/account/ScreenLogin.dart';
import 'screen/news/ScreenWebViewNotificationDetail.dart';
import 'utils/AppUtil.dart';
import 'utils/Constant.dart';
import 'package:get/get.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Xử lý tin nhắn nền điện thoại
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
}

// HttpOverrides hỗ trợ http
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) =>
      super.createHttpClient(context)

        // Chấp nhận kết nối an toàn
        // badCertificateCallback = null => từ chối kết nối => return false
        // badCertificateCallback = true => chấp nhận kết nối => return true
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
}

// Phần chính
Future main() async {
  // load tệp .env để sử dụng data này cho toàn ứng dụng
  await dotenv.load(fileName: '.env');

  // nếu android MyHttpOverrides cho toàn bộ ứng dụng
  if (UniversalPlatform.isAndroid) HttpOverrides.global = MyHttpOverrides();

  runApp(
      // kết hợp nhiều BlocProvider
      MultiBlocProvider(
    providers: [
      // Bloc của login
      BlocProvider<LoginBloc>(
        create: (BuildContext context) => LoginBloc(LoginRepositoryImpl()),
      ),

      // Bloc của thông tin người dùng
      BlocProvider<UserInfoBloc>(
        create: (BuildContext context) =>
            UserInfoBloc(UserInfoRepositoryImpl()),
      ),
      /*   BlocProvider<RegisterBloc>(
        create: (BuildContext context) =>
            RegisterBloc(RegisterRepositoryImpl()),
      ),
      ),*/
    ],
    child: GetMaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'Tổng đài đặt khám',
      theme: ThemeData(primarySwatch: Colors.blue),

      // localizationsDelegates sẽ thay đổi ngôn ngữ trong settings
      // Danh sách tài nguyên được cấp bản dịch
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // ngôn ngữ bản dịch
      supportedLocales: const [
        Locale('vi', ''),
      ],
      home: MyApp(),
//      routes: {
//        "/bloc.login": (context) => ScreenLogin(),
//      },
    ),
  )
      /*  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tổng đài đặt khám',
      theme: ThemeData(primarySwatch: Colors.green
//               primarySwatch: Colors.blue,
      ),
      home:  MyApp(),
    )*/
      );
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppUtil appUtil = AppUtil();

  // Định nghĩa đối tượng gồm các dữ liệu constants
  Constants constants = Constants();

  @override
  void initState() {
    super.initState();

    if (UniversalPlatform.isIOS || UniversalPlatform.isAndroid) {
      setUpFirebase();
    }
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: () {
        final FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      }, // Xử lý event disable nháy trong input khi user click ra ngoài
      child: ScreenLogin());

  ///Firebase Push notification
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  // ignore: unused_field
  FirebaseMessaging _firebaseMessaging;

  // chuỗi riêng biệt
  String separateDataString = 'o_____o';
  void setUpFirebase() {
    // void setUpFirebase(BuildContext context, GlobalKey<ScaffoldState> _navigatorKey) {
    // void setUpFirebase(BuildContext context, GlobalKey<NavigatorState> _navigatorKey) {
    AppUtil.showLog('FirebaseNotifications setUpFirebase Called');

    // mContext = context;
    // navigatorKey = _navigatorKey;
    // navigatorKey = _navigatorKey;
    // mContext = navigatorKey.currentContext;
    firebaseCloudMessaging_Listeners(context);
    setUpLocalNotification(context);
  }

  void setUpLocalNotification(BuildContext context) {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    // If you have skipped STEP 3 then change app_icon to @mipmap/ic_launcher
    final initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
//        AndroidInitializationSettings('mipmap/ic_launcher');
//    AndroidInitializationSettings('app_icon');
    final initializationSettingsIOS = IOSInitializationSettings();
    final initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
//    var data = await jsonDecode(payload);
//    processOptionData(data);
//    appUtil.showPopup(mContext, "Notify onMessage", "payload: " + payload);
    final arrData = payload.split(separateDataString);
    if (arrData != null && arrData.length > 1) {
//     appUtil.showPopup(mContext, "Notify onMessage", "Type: " + arrData[0] + ", Linked: " + arrData[1]);
      processClickNotify(arrData[0], arrData[1]);
    }
  }

  // ignore: non_constant_identifier_names
  Future<void> firebaseCloudMessaging_Listeners(BuildContext context) async {
    if (UniversalPlatform.isIOS) iOS_Permission();
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    final token = await FirebaseMessaging.instance.getToken();
    log('FCM token: $token');
    await AppUtil.saveToSettting(Constants.PREF_FCM_ID, token);
    await FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        Navigator.pushNamed(context, '/message',
            arguments: MessageArguments(message, true));
      }
    });
    FirebaseMessaging.instance.onTokenRefresh.listen((String token) {
      AppUtil.showPrint('New token: $token');

      // sync token to server
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // AppUtil.showPrint('FirebaseNotifications on message ' + jsonEncode(message));
      final RemoteNotification notification = message.notification;
      if (notification != null) {
        final String _pushTitle = notification.title;
        final String _pushMessage = notification.body;
        const String dataPayload = 'Default_Sound';
        _showNotificationWithDefaultSound(
            _pushTitle, _pushMessage, dataPayload);
        return;
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      AppUtil.showPrint('A onMessageOpenedApp event was published!');
      Navigator.pushNamed(context, '/message',
          arguments: MessageArguments(message, true));
    });
  }

  void processDataNotify(Map<String, dynamic> data) {
    final String type = data['Type'];
    final String linked = data['Linked'];

    AppUtil.showPrint(
        'FirebaseNotifications processOptionData: Type $type, linked: $linked');
    processClickNotify(type, linked);
  }

  processClickNotify(String type, String linked) async {
    AppUtil.showPrint(
        'FirebaseNotifications processClickNotify data: Type $type, linked: $linked');
    switch (type) {
      case Constants.NOTIFY_TYPE_OPENAPP:
        break;
      case Constants.NOTIFY_TYPE_OPENDETAILNOTIFY:
        AppUtil.showPrint(
            'FirebaseNotifications processClickNotify data: Type $type, linked: $linked');
        await navigatorKey.currentState.push(MaterialPageRoute(
            builder: (_) => ScreenWebViewNotificationDetail(
                  itemID: linked,
                  title: 'Chi tiết',
                )));
        break;
//      case Constants.NOTIFY_TYPE_OPENDETAILBRIEFING:
//        AppUtil.showPrint(
//            'FirebaseNotifications processClickNotify data: Type $type, linked: $linked');
//        Navigator.push(mContext, MaterialPageRoute(builder: (_) {
//          return ScreenWebViewDetailBriefing(itemID: linked, title: "Chi tiết",);
//        }));
//        break;
      case Constants.NOTIFY_TYPE_OPEN_LINK:
        if (linked != null) {
          final String fileURL = linked;
          if (await canLaunch(fileURL)) {
            await launch(fileURL);
          } else {
            throw 'Could not launch $fileURL';
          }
        }
        break;
    }

    /*   navigatorKey.currentState.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) {
        return ScreenLogin(
          type: type,
          linked: linked,
        );
      }),
          (Route<dynamic> route) => false,
    );*/

//    String userName = await AppUtil.getFromSetting(constants.PREF_USERNAME);
//    String password = await AppUtil.getFromSetting(constants.PREF_PASSWORD);
//    String accessToken = await AppUtil.getFromSetting(constants.PREF_ACCESSTOKEN);
//    if (userName.isNotEmpty && password.isNotEmpty && accessToken.isNotEmpty) {
//      navigatorKey.currentState.pushAndRemoveUntil(
//        MaterialPageRoute(builder: (_) {
//          return ScreenHome(
//            type: type,
//            linked: linked,
//          );
//        }),
//        (Route<dynamic> route) => false,
//      );
//    } else {
//      navigatorKey.currentState.pushAndRemoveUntil(
//        MaterialPageRoute(builder: (_) {
//          return ScreenLogin(
//            type: type,
//            linked: linked,
//          );
//        }),
//        (Route<dynamic> route) => false,
//      );
//    }

    /* navigatorKey.currentState.push(MaterialPageRoute(builder: (_) {
      // Navigator.push(globalScaffoldKey.currentContext, MaterialPageRoute(builder: (_) {
      return ScreenHome(type: type, linked: linked,
      );
    }));*/
    /* navigatorKey.currentState.pushAndRemoveUntil(MaterialPageRoute(builder: (_) {
      // Navigator.push(globalScaffoldKey.currentContext, MaterialPageRoute(builder: (_) {
      return ScreenHome(type: type, linked: linked,
      );
    }), null);*/
    /*switch (type) {
      case Constants.NOTIFY_TYPE_OPENAPP:
        break;
      case Constants.NOTIFY_TYPE_OPENDETAILNOTIFY:
        AppUtil.showPrint('FirebaseNotifications processClickNotify data: Type $type, linked: $linked');
        navigatorKey.currentState.push(MaterialPageRoute(builder: (_) {
          // Navigator.push(globalScaffoldKey.currentContext, MaterialPageRoute(builder: (_) {
          return ScreenWebViewNotificationDetail(
            itemID: linked,
            title: "Chi tiết",
          );
        }));
        break;
      case Constants.NOTIFY_TYPE_OPENDETAILBRIEFING:
        AppUtil.showPrint('FirebaseNotifications processClickNotify data: Type $type, linked: $linked');
        // navigatorKey.currentState.push(route)
        navigatorKey.currentState.push(MaterialPageRoute(builder: (_) {
          // Navigator.push(globalScaffoldKey.currentContext, MaterialPageRoute(builder: (_) {
          return ScreenContainerThongBaoGiaoBanDetail(
            itemID: linked,
            title: "Chi tiết",
          );
        }));
        break;
      case Constants.NOTIFY_TYPE_OPEN_LINK:
        if (linked != null) {
          String fileURL = linked;
          if (await canLaunch(fileURL)) {
            await launch(fileURL);
          } else {
            throw 'Could not launch $fileURL';
          }
        }
        break;

      case Constants.NOTIFY_TYPE_OPENDETAIL_DMSDOCUMENT:
        AppUtil.showPrint('FirebaseNotifications processClickNotify data: Type $type, linked: $linked');
        String fileID = linked;
        String fileType = "";

        if (fileID.contains("::")) {
          var arrID = fileID.split("::");
          if (arrID != null && arrID.length > 1) {
            fileType = arrID[0];
            fileID = arrID[1];
          }
        }
        if (fileType != "" && fileType.toLowerCase() == "vbpq") {
          navigatorKey.currentState.push(MaterialPageRoute(builder: (_) {
            // Navigator.push(globalScaffoldKey.currentContext, MaterialPageRoute(builder: (_) {
            return ScreenContainerFilePhapQuyDetail(
              fileID: fileID,
              fileName: "Chi tiết",
            );
          }));
        } else {
          navigatorKey.currentState.push(MaterialPageRoute(builder: (_) {
            // Navigator.push(globalScaffoldKey.currentContext, MaterialPageRoute(builder: (_) {
            return ScreenContainerFileDetail(
              fileID: fileID,
              fileName: "Chi tiết",
            );
          }));
        }
        break;
      case Constants.NOTIFY_TYPE_OPENDETAIL_DMSCOMMENT:
        AppUtil.showPrint('FirebaseNotifications processClickNotify data: Type $type, linked: $linked');
        String fileID = linked;
        String fileType = "";

        if (fileID.contains("::")) {
          var arrID = fileID.split("::");
          if (arrID != null && arrID.length > 1) {
            fileType = arrID[0];
            fileID = arrID[1];
          }
        }
        if (fileType != "" && fileType.toLowerCase() == "vbpq") {
          navigatorKey.currentState.push(MaterialPageRoute(builder: (_) {
            // Navigator.push(globalScaffoldKey.currentContext, MaterialPageRoute(builder: (_) {
            return ScreenContainerFilePhapQuyDetail(
              fileID: fileID,
              fileName: "Chi tiết",
            );
          }));
        } else {
          navigatorKey.currentState.push(MaterialPageRoute(builder: (_) {
            // Navigator.push(globalScaffoldKey.currentContext, MaterialPageRoute(builder: (_) {
            return ScreenContainerFileDetail(
              fileID: fileID,
              fileName: "Chi tiết",
              selectTabIndex: 2,
            );
          }));
        }
        break;
    }*/
  }

  // ignore: non_constant_identifier_names
  void iOS_Permission() {
    // _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(sound: true, badge: true, alert: true));
    // _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
    //   AppUtil.showPrint("Settings registered: $settings");
    // });
  }

  // Method 2
  Future _showNotificationWithDefaultSound(
      String title, String messsage, String dataPayload) async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'PSHN_NoiBo', 'PSHN_NoiBo',
        importance: Importance.max, priority: Priority.high);
    final iOSPlatformChannelSpecifics = IOSNotificationDetails();
    final platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      messsage,
      platformChannelSpecifics,
      payload: dataPayload,
//      payload: 'Default_Sound',
    );
  }
}

class Call {
  Call(this.number);
  String number;
  bool held = false;
  bool muted = false;
}
