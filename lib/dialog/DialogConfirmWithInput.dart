import 'package:DoctorApp/extension/HexColor.dart';
import 'package:DoctorApp/utils/AppUtil.dart';
import 'package:DoctorApp/utils/Constant.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DialogConfirmWithInput extends StatefulWidget {
  String title;
  String inputHint;
  String message;
  String inputValidate;
  BuildContext context;
  GlobalKey<ScaffoldState> scaffoldKey;

  DialogConfirmWithInput(this.scaffoldKey, this.context, this.title,
      this.inputHint, this.message, this.inputValidate);

  @override
  _DialogConfirmWithInputState createState() => _DialogConfirmWithInputState();
}

class _DialogConfirmWithInputState extends State<DialogConfirmWithInput> {
  AppUtil appUtil = new AppUtil();
  TextEditingController textControllerInput = new TextEditingController();
  bool _validateInput = false;

  @override
  void initState() {
    super.initState();
    if (widget.message != "") {
      setState(() {
        textControllerInput.text = widget.message;
      });
    }
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
              height: 18,
            ),
            Center(
              child: Text(
                widget.title,
                style: Constants.styleTextTitleBlueColor,
              ),
            ),
            SizedBox(
              height: 10.0,
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
                    height: 6.0,
                  ),
                  TextFormField(
//                  textInputAction: TextInputAction.done,
                    minLines: 4,
                    maxLines: 6,
                    controller: textControllerInput,
                    style: Constants.styleTextNormalBlueColor,

                    decoration: InputDecoration(
                        errorText: _validateInput ? widget.inputValidate : null,
                        filled: true,
                        fillColor: HexColor.fromHex(Constants.Color_divider),
                        hintText: widget.inputHint,
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
                        if (textControllerInput.text == null ||
                            textControllerInput.text.length == 0) {
                          setState(() {
                            _validateInput = true;
                          });
                          return;
                        } else {
                          setState(() {
                            _validateInput = false;
                          });
                        }

                        String reason = textControllerInput.text;
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
                                  "Đồng ý",
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
            )
          ],
        ),
      ),
    );
  }
}
