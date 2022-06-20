import 'package:flutter/material.dart';

import '../../utils/Constant.dart';

class WidgetButtonHouseMedical extends StatelessWidget {
  String name;
  Function onClick;
  WidgetButtonHouseMedical({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: onClick,
      child: Container(
          padding: const EdgeInsets.only(left: 25, right: 25, top: 15),
          width: 222,
          height: 55,
          child: Card(
            color: Constants.colorMain,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            elevation: 6,
            child: Center(
              child: Text(
                name,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: Constants.fontName,
                  fontSize: 15,
                  letterSpacing: 0,
                  color: Constants.white,
                ),
              ),
            ),
          )));
}
