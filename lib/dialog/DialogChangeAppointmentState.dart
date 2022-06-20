import 'package:flutter/material.dart';
import 'package:DoctorApp/extension/HexColor.dart';
import 'package:DoctorApp/model/ResultCallBackData.dart';
import 'package:DoctorApp/utils/AppUtil.dart';
import 'package:DoctorApp/utils/Constant.dart';

// ignore: must_be_immutable
class DialogChangeAppointmentState extends StatefulWidget {
  String successTitle;
  String successMessage;
  String appointmentState;
  BuildContext context;
  GlobalKey<ScaffoldState> scaffoldKey;

  DialogChangeAppointmentState(this.scaffoldKey, this.context,
      this.successTitle, this.successMessage, this.appointmentState);

  @override
  _DialogChangeAppointmentStateState createState() =>
      _DialogChangeAppointmentStateState();
}

//enum AppointmentState { WAITING, CANCEL, APPROVE, SERVED }
class _DialogChangeAppointmentStateState
    extends State<DialogChangeAppointmentState> with TickerProviderStateMixin {
  AppUtil appUtil = new AppUtil();

  AnimationController _controller;
  // ignore: unused_field
  Animation<double> _animation;
  String _selectedAppointmentState = Constants.AppointmentState_WAITING;
  bool _isEnabledStateWaiting = true;
  bool _isEnabledStateApprove = true;
  bool _isEnabledStateCancel = true;

  TextEditingController textControllerInput = new TextEditingController();
  bool _validateInput = false;

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this, value: 0.1);
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.bounceInOut);

    _controller.forward();

    setState(() {
      if (widget.appointmentState == "WAITING") {
        _selectedAppointmentState = Constants.AppointmentState_WAITING;
      } else if (widget.appointmentState == "APPROVE") {
        _isEnabledStateWaiting = false;
        _selectedAppointmentState = Constants.AppointmentState_APPROVE;
      } else if (widget.appointmentState == "SERVED") {
        _isEnabledStateWaiting = false;
        _isEnabledStateApprove = false;
        _selectedAppointmentState = Constants.AppointmentState_CANCEL;
      } else if (widget.appointmentState == "CANCEL") {
        _isEnabledStateWaiting = false;
        _isEnabledStateApprove = false;
        _selectedAppointmentState = Constants.AppointmentState_CANCEL;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Center(
              child: Text(
                widget.successTitle,
                style: Constants.styleTextTitleBlueColor,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Divider(
              color: Colors.grey,
              height: 4.0,
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Text(
                    widget.successMessage,
                    style: Constants.styleTextNormalBlueColor,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: <Widget>[
                      Radio<String>(
//                    title: const Text('Đang chờ'),
                        value: Constants.AppointmentState_WAITING,
                        groupValue: _selectedAppointmentState,
                        onChanged: _isEnabledStateWaiting
                            ? (String value) {
                                setState(() {
                                  _selectedAppointmentState = value;
                                });
                              }
                            : null,
                      ),
                      Text(
                        "Chưa xác nhận",
                        style: TextStyle(
                            color: _isEnabledStateWaiting
                                ? Color(0xFF192A56)
                                : Color(0xFF808080),
                            fontWeight: FontWeight.normal,
                            fontSize: Constants.Size_text_normal),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Radio<String>(
//                    title: const Text('Đã duyệt'),
                        value: Constants.AppointmentState_APPROVE,
                        groupValue: _selectedAppointmentState,
                        onChanged: _isEnabledStateApprove
                            ? (String value) {
                                setState(() {
                                  _selectedAppointmentState = value;
                                });
                              }
                            : null,
                      ),
                      Text(
                        "Đã duyệt",
                        style: TextStyle(
                            color: _isEnabledStateApprove
                                ? Color(0xFF192A56)
                                : Color(0xFF808080),
                            fontWeight: FontWeight.normal,
                            fontSize: Constants.Size_text_normal),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Radio<String>(
//                    title: const Text('Hủy khám'),
                        value: Constants.AppointmentState_CANCEL,
                        groupValue: _selectedAppointmentState,
                        onChanged: _isEnabledStateCancel
                            ? (String value) {
                                setState(() {
                                  _selectedAppointmentState = value;
                                });
                              }
                            : null,
                      ),
                      Text(
                        "Hủy khám",
                        style: TextStyle(
                            color: _isEnabledStateCancel
                                ? Color(0xFF192A56)
                                : Color(0xFF808080),
                            fontWeight: FontWeight.normal,
                            fontSize: Constants.Size_text_normal),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _selectedAppointmentState == Constants.AppointmentState_CANCEL
                      ? TextFormField(
//                  textInputAction: TextInputAction.done,
                          minLines: 3,
                          maxLines: 5,
                          controller: textControllerInput,
                          style: Constants.styleTextNormalBlueColor,

                          decoration: InputDecoration(
                              errorText: _validateInput
                                  ? "Vui lòng nhập lý do hủy khám"
                                  : null,
                              filled: true,
                              fillColor:
                                  HexColor.fromHex(Constants.Color_divider),
                              hintText: "Nhập lý do hủy khám",
                              border: InputBorder.none),
                        )
                      : SizedBox(),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 40,
                    width: 100,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                        color: HexColor.fromHex(Constants.Color_red),
                        border: Border.all(
                            color: HexColor.fromHex(Constants.Color_divider)),
                        borderRadius: BorderRadius.all(Radius.circular(25))),
//                          color: HexColor.fromHex(Constants.Color_primary),
                    child: Center(
                      child: Text(
                        "Đóng",
                        textAlign: TextAlign.center,
                        style: Constants.styleTextSmallWhiteColor,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    ResultCallBackData resultCallBack =
                        new ResultCallBackData();
                    resultCallBack.data1 = _selectedAppointmentState.toString();
                    if (_selectedAppointmentState ==
                        Constants.AppointmentState_CANCEL) {
                      if (textControllerInput.text == "") {
                        setState(() {
                          _validateInput = true;
                        });
                        return;
                      }
                      resultCallBack.data2 = textControllerInput.text;
                    }
                    Navigator.pop(context, resultCallBack);
                  },
                  child: Container(
                    height: 40,
                    width: 100,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                        color: HexColor.fromHex(Constants.Color_primary),
                        border: Border.all(
                            color: HexColor.fromHex(Constants.Color_divider)),
                        borderRadius: BorderRadius.all(Radius.circular(25))),
//                          color: HexColor.fromHex(Constants.Color_primary),
                    child: Center(
                      child: Text(
                        "Hoàn thành",
                        textAlign: TextAlign.center,
                        style: Constants.styleTextSmallWhiteColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 25.0,
            ),
//            )
          ],
//              ),
        ),
      ),
    );
  }
}
