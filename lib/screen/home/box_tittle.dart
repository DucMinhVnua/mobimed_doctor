import 'package:flutter/material.dart';

import '../../utils/Constant.dart';

class BoxTitle extends StatelessWidget {
  final String titleTxt;
  final String subTxt;
  final Function onClick;

  const BoxTitle({Key key, this.titleTxt, this.subTxt, this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(titleTxt,
                style: const TextStyle(
                    color: Constants.colorText,
                    fontWeight: FontWeight.w800,
                    fontFamily: Constants.fontName,
                    fontSize: Constants.Size_text_title)),
            GestureDetector(
              onTap: onClick,
              child: Text(
                subTxt,
                style: const TextStyle(
                    color: Constants.colorMain,
                    fontFamily: Constants.fontName,
                    fontSize: Constants.Size_text_normal),
              ),
            )
          ],
        ),
      );
}
