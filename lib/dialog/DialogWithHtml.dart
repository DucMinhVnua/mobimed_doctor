import 'package:DoctorApp/extension/HexColor.dart';
import 'package:DoctorApp/utils/Constant.dart';
import 'package:flutter/material.dart';
import 'package:DoctorApp/utils/AppUtil.dart';
import 'package:flutter_html/flutter_html.dart';

// ignore: must_be_immutable
class DialogWithHtml extends StatefulWidget {
  String successTitle;
  String successMessage;
  BuildContext context;
  GlobalKey<ScaffoldState> scaffoldKey;

  DialogWithHtml(
      this.scaffoldKey, this.context, this.successTitle, this.successMessage);

  @override
  _DialogWithHtmlState createState() => _DialogWithHtmlState();
}

class _DialogWithHtmlState extends State<DialogWithHtml>
    with TickerProviderStateMixin {
  AppUtil appUtil = new AppUtil();

  AnimationController _controller;
  // ignore: unused_field
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
      // child: SingleChildScrollView(child: Html(data: widget.successMessage)),
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
              child: Html(data: widget.successMessage)),
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
    );
  }
}
