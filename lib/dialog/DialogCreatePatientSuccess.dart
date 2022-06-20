import 'package:flutter/material.dart';
import 'package:DoctorApp/extension/HexColor.dart';
import 'package:DoctorApp/utils/AppUtil.dart';
import 'package:DoctorApp/utils/Constant.dart';

// ignore: must_be_immutable
class DialogCreatePatientSuccess extends StatefulWidget {
  String patientCode;
  BuildContext context;
  GlobalKey<ScaffoldState> scaffoldKey;

  DialogCreatePatientSuccess(this.scaffoldKey, this.context, this.patientCode);

  @override
  _DialogCreatePatientSuccessState createState() =>
      _DialogCreatePatientSuccessState();
}

class _DialogCreatePatientSuccessState
    extends State<DialogCreatePatientSuccess> {
  AppUtil appUtil = new AppUtil();
  TextEditingController textControllerNote = new TextEditingController();
  bool _validateNote = false;

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
              height: 12,
            ),
            Center(
              child: Text(
                "Tạo bệnh nhân thành công",
                style: Constants.styleTextTitleBlueColor,
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            Divider(
              color: Colors.grey,
              height: 4.0,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 15.0,
                  ),
                  Center(
                    child: Text(
                      "Mã bệnh nhân",
                      style: Constants.styleTextNormalHintColor,
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: Center(
                        child: Text(
                      widget.patientCode,
                      style: Constants.styleTextNormalBlueColorBold,
                    )),
                    decoration: BoxDecoration(
                        color: HexColor.fromHex(Constants.Color_divider),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
//                  textInputAction: TextInputAction.done,
                    minLines: 3,
                    maxLines: 5,
                    controller: textControllerNote,
                    style: Constants.styleTextNormalBlueColor,

                    decoration: InputDecoration(
                        errorText: _validateNote
                            ? 'Lý do khám không được để trống'
                            : null,
                        filled: true,
                        fillColor: HexColor.fromHex(Constants.Color_divider),
//                    labelText: "Ghi chú khám",
                        hintText: "Nhập lý do khám",
                        border: InputBorder.none),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
//              decoration: BoxDecoration(
////                color: HexColor.fromHex(Constants.Color_primary),
//                borderRadius: BorderRadius.only(
//                    bottomLeft: Radius.circular(10.0),
//                    bottomRight: Radius.circular(10.0)),
//              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                        height: 40,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: HexColor.fromHex(
                                      Constants.Color_divider)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25))),
//                          color: HexColor.fromHex(Constants.Color_primary),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  "Đóng",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: HexColor.fromHex(
                                          Constants.Color_maintext)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (textControllerNote.text == null ||
                            textControllerNote.text.length == 0) {
                          setState(() {
                            _validateNote = true;
                          });
//                          appUtil.showToastWithScaffoldState(
//                              widget.scaffoldKey, "Vui lòng nhập lý do khám");
                          return;
                        } else {
                          setState(() {
                            _validateNote = false;
                          });
                        }

//                        MedicalSessionInputData itemInput =
//                            new MedicalSessionInputData();
//                        itemInput.patientCode = widget.patientCode;
//                        itemInput.reason = textControllerNote.text;
//                        Navigator.pop(context, itemInput);
                        String reason = textControllerNote.text;
                        Navigator.pop(context, reason);
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                        height: 40,
                        child: Container(
                          decoration: BoxDecoration(
                              color: HexColor.fromHex(Constants.Color_primary),
                              border: Border.all(
                                  color: HexColor.fromHex(
                                      Constants.Color_divider)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25))),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  "Đăng ký khám",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              /*    Text(
                    "Rate Product",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),*/
            )
//                InkWell(
//                  child: ,
//                ),
            /*    Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: HexColor.fromHex(Constants.Color_primary)
                  ),
                )*/
          ],
//              ),
        ),
      ),
    );
  }
}
