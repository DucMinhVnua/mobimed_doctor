import 'package:flutter/material.dart';

import '../extension/HexColor.dart';
import 'Constant.dart';

class DefaultSmallRowButtonUI extends StatelessWidget {
  final String name;
  final String color;
  final Function clickButton;

  const DefaultSmallRowButtonUI({
    Key key,
    @required this.name,
    @required this.color,
    @required this.clickButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              color: HexColor.fromHex(color),
              margin: const EdgeInsets.all(2),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Text(
                  name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: Constants.Size_text_small),
                ),
              ),
            ),
            onTap: () async {
              clickButton();
            },
          ),
        ],
      );
}
