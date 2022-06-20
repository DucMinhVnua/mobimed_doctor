/*
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pshpnoibo/screen/ScreenWebViewNotificationDetail.dart';
import 'package:pshpnoibo/utils/AppUtil.dart';
import 'package:pshpnoibo/utils/Constant.dart';
import 'package:url_launcher/url_launcher.dart';

class FirebaseNotifications {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  FirebaseMessaging _firebaseMessaging;
  AppUtil appUtil = new AppUtil();
  Constants constants = new Constants();
  BuildContext mContext;

  void setUpFirebase(BuildContext context) {
    AppUtil.showLog("FirebaseNotifications setUpFirebase Called");
    mContext = context;
    _firebaseMessaging = FirebaseMessaging();
    firebaseCloudMessaging_Listeners(context);

    setUpLocalNotification(context);
  }

  void setUpLocalNotification(BuildContext context) {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    // If you have skipped STEP 3 then change app_icon to @mipmap/ic_launcher
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('app_icon');
//        new AndroidInitializationSettings('mipmap/ic_launcher');
//    new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
//    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
//    var data = await jsonDecode(payload);
//    processOptionData(data);
//    appUtil.showPopup(mContext, "Notify onMessage", "payload: " + payload);
    var arrData = payload.split(separateDataString);
    if (arrData != null && arrData.length > 1) {
//     appUtil.showPopup(mContext, "Notify onMessage", "Type: " + arrData[0] + ", Linked: " + arrData[1]);
      processClickNotify(arrData[0], arrData[1]);
    }
  }

  String separateDataString = "o_____o";
  void firebaseCloudMessaging_Listeners(BuildContext context) {
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token) {
      AppUtil.showLogFull("FirebaseNotifications token: " + token);
      AppUtil.saveToSettting(constants.PREF_FCM_ID, token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        AppUtil.showPrint('FirebaseNotifications on message $message');
        String _pushTitle = "";
        String _pushMessage = "";
        if (Theme.of(context).platform == TargetPlatform.iOS)
          _pushMessage = message['aps']['alert'];
        else {
          _pushTitle = message['notification']['title'];
          _pushMessage = message['notification']['body'];
        }
//        _showMessage(message, context);
        String dataPayload = "";
        if (message.containsKey('data')) {
          // Handle data message
          final dynamic data = message['data'];
          AppUtil.showPrint('FirebaseNotifications on message data $data');

//          dataPayload = message['data'].toString();
//          processOptionData(data);
          String type = data["Type"];
          String linked = data["Linked"];
          dataPayload = type + separateDataString + linked;
        }

//        if (message.containsKey('notification')) {
//          // Handle notification message
//          final dynamic notification = message['notification'];
//          AppUtil.showPrint('FirebaseNotifications on message notification $notification');
//        }

        _showNotificationWithDefaultSound(
            _pushTitle, _pushMessage, dataPayload);
      },
      onResume: (Map<String, dynamic> message) async {
        AppUtil.showPrint('FirebaseNotifications on resume $message');
        if (message.containsKey('data')) {
          // Handle data message
          final dynamic data = message['data'];
          AppUtil.showPrint('FirebaseNotifications on resume data $data');
          String type = data["Type"];
          String linked = data["Linked"];

          AppUtil.showPrint('FirebaseNotifications onResume: Type $type, linked: $linked');
          processClickNotify(type, linked);
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        AppUtil.showPrint('FirebaseNotifications on launch $message');
        if (message.containsKey('data')) {
          // Handle data message
          final dynamic data = message['data'];
          AppUtil.showPrint('FirebaseNotifications on launch data $data');
//          processDataNotify(data);
          String type = data["Type"];
          String linked = data["Linked"];

          AppUtil.showPrint('FirebaseNotifications onLaunch: Type $type, linked: $linked');
          processClickNotify(type, linked);
        }
//        AppUtil.showPopup(context, "Notify onLaunch", "Notify onLaunch");
      },
    );
  }

  processDataNotify(Map<String, dynamic> data) {
    String type = data["Type"];
    String linked = data["Linked"];

    AppUtil.showPrint(
        'FirebaseNotifications processOptionData: Type $type, linked: $linked');
    processClickNotify(type, linked);
  }

  processClickNotify(String type, String linked) async {
    switch (type) {
      case Constants.NOTIFY_TYPE_OPENAPP:
        break;
      case Constants.NOTIFY_TYPE_OPENDETAILNOTIFY:
        AppUtil.showPrint(
            'FirebaseNotifications processClickNotify data: Type $type, linked: $linked');
        Navigator.push(mContext, MaterialPageRoute(builder: (_) {
          return ScreenWebViewNotificationDetail(
            itemID: linked,
            title: "Chi tiết",
          );
        }));
        break;
    */
/*  case Constants.NOTIFY_TYPE_OPENDETAILBRIEFING:
        AppUtil.showPrint(
            'FirebaseNotifications processClickNotify data: Type $type, linked: $linked');
        Navigator.push(mContext, MaterialPageRoute(builder: (_) {
          return ScreenWebViewDetailBriefing(itemID: linked, title: "Chi tiết",);
        }));
        break;*//*

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
    }
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      AppUtil.showPrint("Settings registered: $settings");
    });
  }

  // Method 2
  Future _showNotificationWithDefaultSound(
      String title, String messsage, String dataPayload) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'PSHN_NoiBo', 'PSHN_NoiBo', 'PSHN_NoiBo',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      messsage,
      platformChannelSpecifics,
      payload: dataPayload,
//      payload: 'Default_Sound',
    );
  }

  void _showMessage(Map<String, dynamic> message, context) {
    SnackBar bar = SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 10),
      action: SnackBarAction(
        label: "Close",
        textColor: Colors.redAccent,
        onPressed: () => Scaffold.of(context).hideCurrentSnackBar(),
      ),
      content: Padding(
        padding: const EdgeInsets.only(bottom: 25.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(message['notification']["title"]),
            Text(message['notification']["body"]),
          ],
        ),
      ),
    );

    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(bar);
  }
}
*/
