import 'package:flutter/material.dart';
import '../extension/HexColor.dart';

class Constants {
  static double heightBottom = 100;

  static const TextStyle styleTextTitleAppBar = TextStyle(
      color: Constants.white,
      fontSize: 18,
      fontWeight: FontWeight.w800,
      letterSpacing: 0,
      fontFamily: Constants.fontName);

  static const String formatDateTime = 'dd/MM/yyyy HH:mm';
  static const String formatDateTimeTimeFirst = 'HH:mm - dd/MM/yyyy';

  static const Color kPrimaryColor = Color(0xFF1a746b);
  static const Color kMedColor = Color(0xFF26a69a);
  static const Color kSecondaryColor = Color(0xFF51b7ae);

  static const Color kContentColorLightTheme = Color(0xFF1D1D35);
  static const Color kContentColorDarkTheme = Color(0xFFF5FCF9);
  static const Color kWarninngColor = Color(0xFFF3BB1C);
  static const Color kErrorColor = Color(0xFFF03738);

  static const double kDefaultPadding = 20;

  static const String statusErrorNetwork =
      'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối và thử lại';
  static const String statusTitleNotification = 'Thông báo';

  static const Color notWhite = Color(0xFFEDF0F2);
  static const Color red = Color(0xFFCD5C5C);
  static const Color colorTitle = Color(0xFF2633C5);

  static const Color nearlyWhite = Color(0xFFFAFAFA);
  static const Color white = Color(0xFFFFFFFF);
  // static const Color background = Color(0xFFF2F2F2); // #F2F2F2
  static const Color nearlyDarkBlue = Color(0xFF16A1F6);

  static const Color colorAppBar = Color(0xFF54C1FB);

  static const Color colorMain = Color(0xFF16A1F6);
  static const Color colorShadow = Color(0xFFEEFAFF);
  static const Color colorText = Color(0xFF696969);
  static const Color colorTextHint = Color(0xFF808080);

  static const Color nearlyBlue = Color(0xFF16A1F6);
  static const Color nearlyBlack = Color(0xFF213333);
  static const Color grey = Color(0xFF3A5160);
  static const Color darkGrey = Color(0xFF313A44);
  // static const Color colorShadow = Color(0xFF85CBFF);

  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);
  static const Color deactivatedText = Color(0xFF767676);
  static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color spacer = Color(0xFFF2F2F2);
  static const Color colorTextTitle = Colors.blueAccent;
  static const String fontName = 'Roboto';

  static const TextTheme textTheme = TextTheme(
    headline4: display1,
    headline5: headline,
    headline6: title,
    subtitle2: subtitle,
    bodyText2: body2,
    bodyText1: body1,
    caption: caption,
  );

  static const TextStyle titleSelectColor = TextStyle(
      fontSize: 14,
      color: Constants.colorMain,
      fontWeight: FontWeight.w800,
      fontFamily: fontName);
  static const TextStyle titleSelectWhite = TextStyle(
      fontSize: 14,
      color: Constants.white,
      fontWeight: FontWeight.w800,
      fontFamily: fontName);

  static const TextStyle titleSelect = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      fontFamily: fontName);

  static TextStyle styleHintText = TextStyle(
      color: colorText.withOpacity(0.5),
      fontWeight: FontWeight.normal,
      fontFamily: Constants.fontName,
      fontSize: 15);

  static const TextStyle display1 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    color: darkerText,
  );

  static const TextStyle headline = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: darkerText,
  );

  static const TextStyle title = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
    color: darkerText,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.04,
    color: darkText,
  );

  static const TextStyle body2 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.2,
    color: darkText,
  );

  static const TextStyle body1 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: darkText,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: lightText, // was lightText
  );

  static const double sizeTop = 50; // MediaQuery.of(context).padding.top
  static const String prefAccessToken = 'PREF_ACCESSTOKEN_DKTPT';
  static const String prefUserName = 'PREF_USERNAME_DKTPT';

  static const String nameApp = '_DKTPT';
  // ignore: non_constant_identifier_names
  static const String PREF_ACCESSTOKEN = 'PREF_ACCESSTOKEN_DKTPT';
  // ignore: non_constant_identifier_names
  static const String PREF_ACCESSTOKEN_THAIDITAT = 'PREF_ACCESSTOKEN_THAIDITAT';
  // ignore: non_constant_identifier_names
  static const String PREF_USERNAME = 'PREF_USERNAME_DKTPT';
  // ignore: non_constant_identifier_names
  static const String PREF_PASSWORD = 'PREF_PASSWORD_DKTPT';
  // ignore: non_constant_identifier_names
  static const String PREF_AVATAR = 'PREF_AVATAR';
  // ignore: non_constant_identifier_names
  static const String PREF_QUEUE_UPLOAD = 'PREF_QUEUE_UPLOAD';
  // ignore: non_constant_identifier_names
  static const String PREF_FCM_ID = 'PREF_FCM_ID';
  // ignore: non_constant_identifier_names
  static const String PREF_INREVIEW = 'PREF_INREVIEW';
  // ignore: non_constant_identifier_names
  static const String PREF_QUEUE_OBWHEEL = 'PREF_QUEUE_OBWHEEL';

  static const String NOTIFY_TYPE_OPENAPP = 'open-app';
  static const String NOTIFY_TYPE_OPENDETAILNOTIFY = 'open-detail-notify';
  static const String NOTIFY_TYPE_OPENDETAILBRIEFING = 'open-detail-briefing';
  static const String NOTIFY_TYPE_OPEN_LINK = 'open-url';

  static const String FORMAT_DATEREQUEST = 'yyyy-MM-dd';
  static const String FORMAT_DATEONLY = 'dd/MM/yyyy';
  static const String FORMAT_TIMEONLY = 'HH:mm';
  // static const String FORMAT_TIMEONLY = "hh:mm";
  static const String FORMAT_DATETIME = 'dd/MM/yyyy HH:mm';
  static const String FORMAT_DATETIME_TIMEFIRST = 'HH:mm - dd/MM/yyyy';

  static const Color background = Color(0xFFF2F2F2); // #F2F2F2
  static const String Color_primary = '#1B92F6';
  static const String Color_green = '#33CC00';
  static const String Color_bluetext = '#192A56';
  static const String Color_maintext = '#000000';
  static const String Color_subtext = '#404040';
  static const String Color_red = '#F84366';
  static const String Color_divider = '#EEEEEE';
  static const String Color_input_underline = '#BCBCBC';
  static const String Color_main_background = '#EDEDED';
  static const String Color_hinttext = '#808080';

  static const String SignalSuccess = 'SUCCESS';
  static const String SignalSuccessCREAT = 'SUCCESSCREAT';
  static const String SignalSuccessEDIT = 'SUCCESSEDIT';

  //AppointmentState { WAITING, CANCEL, APPROVE, SERVED }
  static const String AppointmentState_WAITING = 'WAITING';
  static const String AppointmentState_CANCEL = 'CANCEL';
  static const String AppointmentState_APPROVE = 'APPROVE';
  static const String AppointmentState_SERVED = 'SERVED';

  static const int Color_gradient_blue_start = 0xFF1B92F6;
  static const int Color_gradient_blue_end = 0xFF1B92F6;
  static const int Color_gradient_yellow_start = 0xFFFCE792;
  static const int Color_gradient_yellow_end = 0xFFEFD003;
  static const int Color_gradient_green_start = 0xFF319243;
  static const int Color_gradient_green_end = 0xFF319243;
  static const int Color_bg_title_input = 0xFFF2F2F2;

  static const double Size_text_supersmall = 12;
  static const double Size_text_small = 13;
  static const double Size_text_normal = 14;
  static const double Size_text_title = 16;

  static const TextStyle styleTextTitleBlueColor = TextStyle(
      color: Color(0xFF192A56),
      fontWeight: FontWeight.normal,
      fontSize: Size_text_title);
  static const TextStyle styleTextTitleMainColor = TextStyle(
      color: Color(0xFF000000),
      fontWeight: FontWeight.normal,
      fontSize: Size_text_title);
  static const TextStyle styleTextTitleSubColor = TextStyle(
      color: Color(0xFF404040),
      fontWeight: FontWeight.normal,
      fontSize: Size_text_title);

  static const TextStyle styleTextNormalWhiteColor = TextStyle(
      color: Color(0xFFFFFFFF),
      fontWeight: FontWeight.normal,
      fontFamily: Constants.fontName,
      fontSize: Size_text_normal);
  static const TextStyle styleTextNormalBlueColor = TextStyle(
      color: Color(0xFF192A56),
      fontWeight: FontWeight.normal,
      fontFamily: Constants.fontName,
      fontSize: Size_text_normal);
  static const TextStyle styleTextNormalMainColor = TextStyle(
      color: Color(0xFF000000),
      fontWeight: FontWeight.normal,
      fontFamily: Constants.fontName,
      fontSize: Size_text_normal);
  static const TextStyle styleTextNormalSubColor = TextStyle(
      color: Color(0xFF404040),
      fontWeight: FontWeight.normal,
      fontFamily: Constants.fontName,
      fontSize: Size_text_normal);
  static const TextStyle styleTextNormalHintColor = TextStyle(
      color: Color(0xFF808080),
      fontWeight: FontWeight.normal,
      fontFamily: Constants.fontName,
      fontSize: Size_text_normal);
  static const TextStyle styleTextNormalRedColor = TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.normal,
      fontFamily: Constants.fontName,
      fontSize: Size_text_normal);
  static const TextStyle styleTextNormalGreenColor = TextStyle(
      color: Colors.green,
      fontWeight: FontWeight.normal,
      fontFamily: Constants.fontName,
      fontSize: Size_text_normal);

  static const TextStyle styleTextSmallWhiteColor = TextStyle(
      color: Color(0xFFFFFFFF),
      fontWeight: FontWeight.normal,
      fontFamily: Constants.fontName,
      fontSize: Size_text_small);
  static const TextStyle styleTextSmallMainColor = TextStyle(
      color: Color(0xFF000000),
      fontWeight: FontWeight.normal,
      fontFamily: Constants.fontName,
      fontSize: Size_text_small);
  static const TextStyle styleTextSmallSubColor = TextStyle(
      color: Color(0xFF404040),
      fontWeight: FontWeight.normal,
      fontFamily: Constants.fontName,
      fontSize: Size_text_small);
  static const TextStyle styleTextSmallBlueColor = TextStyle(
      color: Color(0xFF192A56),
      fontWeight: FontWeight.normal,
      fontFamily: Constants.fontName,
      fontSize: Size_text_small);
  static const TextStyle styleTextSmallPrimaryColor = TextStyle(
      color: Color(0xFF1B92F6),
      fontWeight: FontWeight.normal,
      fontFamily: Constants.fontName,
      fontSize: Size_text_small);
  static const TextStyle styleTextSuperSmallSubColor = TextStyle(
      color: Color(0xFF404040),
      fontWeight: FontWeight.normal,
      fontFamily: Constants.fontName,
      fontSize: Size_text_supersmall);
  static const TextStyle styleTextSuperSmallBlueColor = TextStyle(
      color: Color(0xFF192A56),
      fontWeight: FontWeight.normal,
      fontFamily: Constants.fontName,
      fontSize: Size_text_supersmall);
  static const TextStyle styleTextSuperSmallPrimaryColor = TextStyle(
      color: Color(0xFF1B92F6),
      fontWeight: FontWeight.normal,
      fontFamily: Constants.fontName,
      fontSize: Size_text_supersmall);
  static const TextStyle styleTextSmallRedColor = TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.normal,
      fontFamily: Constants.fontName,
      fontSize: Size_text_small);

  static const TextStyle styleTextNormalBlueColorBold = TextStyle(
      color: Color(0xFF192A56),
      fontWeight: FontWeight.bold,
      fontFamily: Constants.fontName,
      fontSize: Size_text_normal);
  static const TextStyle styleTextNormalRedColorBold = TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.bold,
      fontFamily: Constants.fontName,
      fontSize: Size_text_normal);

  InputDecoration getInputDecoration(
      String hintText, bool _validateErrorInput, String _validateErrorText) {
    if (_validateErrorInput != null) {
      return InputDecoration(
          errorText: _validateErrorInput ? _validateErrorText : null,
          hintText: hintText,
          border: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: HexColor.fromHex(Constants.Color_divider))));
    } else {
      return InputDecoration(
          hintText: hintText,
          border: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: HexColor.fromHex(Constants.Color_divider))));
    }
  }
}

const kPrimaryColor = Color(0xFF1a746b);
const kMedColor = Color(0xFF26a69a);
const kSecondaryColor = Color(0xFF51b7ae);

const kContentColorLightTheme = Color(0xFF1D1D35);
const kContentColorDarkTheme = Color(0xFFF5FCF9);
const kWarninngColor = Color(0xFFF3BB1C);
const kErrorColor = Color(0xFFF03738);

const kDefaultPadding = 20.0;
