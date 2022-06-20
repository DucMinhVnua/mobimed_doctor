import 'package:flutter/material.dart';

import '../../utils/Constant.dart';

class TabNoneHouseMedical extends StatelessWidget {
  const TabNoneHouseMedical({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const Center(
      child: Text('Tính năng đang cập nhật',
          style: TextStyle(
              // decoration: TextDecoration.underline,
              // fontStyle: FontStyle.italic,
              color: Constants.colorText,
              fontWeight: FontWeight.w500,
              fontFamily: Constants.fontName,
              fontSize: 15)));
}
