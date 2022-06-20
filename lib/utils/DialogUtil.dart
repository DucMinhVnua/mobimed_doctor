import 'package:flutter/material.dart';

import '../dialog/DialogChangeAppointmentState.dart';
import '../dialog/DialogConfirmWithInput.dart';
import '../dialog/DialogConfirmYesNo.dart';
import '../dialog/DialogCreateMedicalSessionSuccess.dart';
import '../dialog/DialogCreatePatientSuccess.dart';
import '../dialog/DialogWithHtml.dart';
import '../dialog/DialogWithTitle.dart';
import '../model/ResultCallBackData.dart';
import 'Constant.dart';

class DialogUtil {
  static DialogUtil _instance = DialogUtil.internal();

  DialogUtil.internal();

  factory DialogUtil() => _instance;

  Constants constants = Constants();

  static Future<String> showDialogCreatePatientSuccess(
      GlobalKey<ScaffoldState> _scaffoldKey, BuildContext context,
      {@required String patientCode, @required Function okBtnFunction}) async {
    final String dialogResult = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            contentPadding: EdgeInsets.all(0),
            content: DialogCreatePatientSuccess(_scaffoldKey, context,
                patientCode))); //.then((value) => value);
    return dialogResult;
  }

  static Future<bool> showDialogCreateSuccess(
      GlobalKey<ScaffoldState> _scaffoldKey, BuildContext context,
      {@required String messageSuccess,
      @required Function okBtnFunction}) async {
    final bool dialogResult = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            contentPadding: EdgeInsets.all(0),
            content: DialogCreateMedicalSessionSuccess(_scaffoldKey, context,
                messageSuccess))); //.then((value) => value);
    return dialogResult;
  }

  static Future<bool> showDialogWithTitle(
      GlobalKey<ScaffoldState> _scaffoldKey, BuildContext context,
      {@required String dialogTitle,
      @required String dialogMessage,
      @required Function okBtnFunction}) async {
    final bool dialogResult = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            contentPadding: EdgeInsets.all(0),
            content: DialogWithTitle(_scaffoldKey, context, dialogTitle,
                dialogMessage))); //.then((value) => value);
    return dialogResult;
  }

  static Future<bool> showDialogWithHtml(
      GlobalKey<ScaffoldState> _scaffoldKey, BuildContext context,
      {@required String dialogTitle,
      @required String dialogMessage,
      @required Function okBtnFunction}) async {
    final bool dialogResult = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            contentPadding: EdgeInsets.all(0),
            content: DialogWithHtml(_scaffoldKey, context, dialogTitle,
                dialogMessage))); //.then((value) => value);
    return dialogResult;
  }

  static Future<ResultCallBackData> showDialogChangeAppointmentState(
      GlobalKey<ScaffoldState> _scaffoldKey, BuildContext context,
      {@required String dialogTitle,
      @required String dialogMessage,
      @required String currentAppointmentState,
      @required Function okBtnFunction}) async {
    final ResultCallBackData dialogResult = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            contentPadding: EdgeInsets.all(0),
            content: DialogChangeAppointmentState(
                _scaffoldKey,
                context,
                dialogTitle,
                dialogMessage,
                currentAppointmentState))); //.then((value) => value);
    return dialogResult;
  }

  static Future<bool> showDialogConfirmYesNo(
      GlobalKey<ScaffoldState> _scaffoldKey, BuildContext context,
      {@required String title,
      @required String message,
      String nameButton,
      @required Function okBtnFunction}) async {
    final bool dialogResult = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            contentPadding: EdgeInsets.all(0),
            content: DialogConfirmYesNo(_scaffoldKey, context, title, message,
                nameButton, okBtnFunction))); //.then((value) => value);
    return dialogResult;
  }

  static Future<String> showDialogConfirmWithInput(
      GlobalKey<ScaffoldState> _scaffoldKey, BuildContext context,
      {@required String title,
      String inputHint,
      String message,
      String inputValidate}) async {
    final String dialogResult = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            contentPadding: EdgeInsets.all(0),
            content: DialogConfirmWithInput(_scaffoldKey, context, title,
                inputHint, message, inputValidate))); //.then((value) => value);
    return dialogResult;
  }
}
