import 'package:flutter/material.dart';
import 'package:DoctorApp/extension/HexColor.dart';
import 'package:DoctorApp/utils/AppUtil.dart';
import 'package:DoctorApp/utils/Constant.dart';

// ignore: must_be_immutable
class DialogCreateMedicalSessionSuccess extends StatefulWidget {
  String successMessage;
  BuildContext context;
  GlobalKey<ScaffoldState> scaffoldKey;

  DialogCreateMedicalSessionSuccess(
      this.scaffoldKey, this.context, this.successMessage);

  @override
  _DialogCreateMedicalSessionSuccessState createState() =>
      _DialogCreateMedicalSessionSuccessState();
}

class _DialogCreateMedicalSessionSuccessState
    extends State<DialogCreateMedicalSessionSuccess>
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
              height: 25,
            ),
            Center(
              child: ScaleTransition(
                  scale: _animation,
                  alignment: Alignment.center,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_outline,
                            size: 100.0, color: Colors.green),
                      ])),
            ),
            SizedBox(
              height: 15.0,
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  widget.successMessage,
                  textAlign: TextAlign.center,
                  style: Constants.styleTextTitleBlueColor,
                ),
              ),
            ),
            SizedBox(
              height: 25.0,
            ),

//            Container(
//              width: 140,
//              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
////              decoration: BoxDecoration(
//////                color: HexColor.fromHex(Constants.Color_primary),
////                borderRadius: BorderRadius.only(
////                    bottomLeft: Radius.circular(10.0),
////                    bottomRight: Radius.circular(10.0)),
////              ),
//              child:
            InkWell(
              onTap: () {
                Navigator.pop(context, true);
              },
              child: Container(
                height: 40,
                width: 200,
                margin: EdgeInsets.symmetric(horizontal: 50),
                decoration: BoxDecoration(
                    color: HexColor.fromHex(Constants.Color_primary),
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
