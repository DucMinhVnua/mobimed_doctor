import 'package:flutter/material.dart';

import '../extension/HexColor.dart';
import '../utils/AppUtil.dart';
import '../utils/Constant.dart';

// ignore: must_be_immutable
class DialogConfirmYesNo extends StatefulWidget {
  String title;
  String message;
  String nameButton;
  Function okBtnFunction;
  BuildContext context;
  GlobalKey<ScaffoldState> scaffoldKey;

  DialogConfirmYesNo(this.scaffoldKey, this.context, this.title, this.message,
      this.nameButton, this.okBtnFunction);

  @override
  _DialogConfirmYesNoState createState() => _DialogConfirmYesNoState();
}

class _DialogConfirmYesNoState extends State<DialogConfirmYesNo> {
  // AppUtil appUtil = new AppUtil();
  // TextEditingController textControllerInput = new TextEditingController();
  // bool _validateInput = false;

  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 18,
              ),
              Center(
                child: Text(
                  widget.title,
                  style: Constants.styleTextTitleBlueColor,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const Divider(
                color: Colors.grey,
                height: 4,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Text(
                        widget.message,
                        style: Constants.styleTextNormalHintColor,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
//                   TextFormField(
// //                  textInputAction: TextInputAction.done,
//                     minLines: 3,
//                     maxLines: 5,
//                     controller: textControllerInput,
//                     style: Constants.styleTextNormalBlueColor,

//                     decoration: InputDecoration(
//                       errorText: _validateInput ? widget.inputValidate : null,
//                         filled: true,
//                         fillColor: HexColor.fromHex(Constants.Color_divider),
//                         hintText: widget.inputHint,
//                         border: InputBorder.none),

//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 0),
                          height: 40,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: HexColor.fromHex(
                                        Constants.Color_divider)),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(25))),
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
                          widget.okBtnFunction();
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 0),
                          height: 40,
                          child: Container(
                            decoration: BoxDecoration(
                                color:
                                    HexColor.fromHex(Constants.Color_primary),
                                border: Border.all(
                                    color: HexColor.fromHex(
                                        Constants.Color_divider)),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(25))),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    widget.nameButton, //"Đồng ý",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
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

// ignore: must_be_immutable
class DialogCreateSuccessButton extends StatefulWidget {
  String successMessage;
  BuildContext context;
  GlobalKey<ScaffoldState> scaffoldKey;
  Function okBtnFunction;

  DialogCreateSuccessButton(
      this.scaffoldKey, this.context, this.successMessage, this.okBtnFunction);

  @override
  _DialogCreateSuccessButtonState createState() =>
      _DialogCreateSuccessButtonState();
}

class _DialogCreateSuccessButtonState extends State<DialogCreateSuccessButton>
    with TickerProviderStateMixin {
  AppUtil appUtil = new AppUtil();

  AnimationController _controller;
  Animation<double> _animation;

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
  }

  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 25,
              ),
              Center(
                child: ScaleTransition(
                    scale: _animation,
                    alignment: Alignment.center,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle_outline,
                              size: 100, color: Colors.green),
                        ])),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    widget.successMessage,
                    textAlign: TextAlign.center,
                    style: Constants.styleTextTitleBlueColor,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  widget.okBtnFunction();
                },
                child: Container(
                  height: 40,
                  width: 200,
                  margin: const EdgeInsets.symmetric(horizontal: 50),
                  decoration: BoxDecoration(
                      color: HexColor.fromHex(Constants.Color_primary),
                      border: Border.all(
                          color: HexColor.fromHex(Constants.Color_divider)),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(25))),
//                          color: HexColor.fromHex(Constants.Color_primary),
                  child: const Center(
                    child: Text(
                      "Đóng",
                      textAlign: TextAlign.center,
                      style: Constants.styleTextSmallWhiteColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
//            )
            ],
//              ),
          ),
        ),
      );
}
