import 'package:flutter/material.dart';

import '../design_theme/theme_custom.dart';
import '../extension/HexColor.dart';
import '../utils/Constant.dart';

class WidgetButtonAlign extends StatelessWidget {
  final String name;
  final Function clickButton;

  const WidgetButtonAlign({
    Key key,
    @required this.name,
    @required this.clickButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 25),
          height: 50,
          child: Card(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25))),
            color: HexColor.fromHex(Constants.Color_primary),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: DesignAppTheme.nearlyBlue,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(30),
                      ),
                      gradient: const LinearGradient(
                          colors: [Color(0xFF32C5FF), Color(0xFF61E4FF)]),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: DesignAppTheme.nearlyBlue.withOpacity(0.5),
                            offset: const Offset(1.1, 1.1),
                            blurRadius: 10),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Constants.white,
                            fontWeight: FontWeight.w500,
                            fontFamily: Constants.fontName,
                            letterSpacing: 0,
                            fontSize: 18),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        onTap: () async {
          clickButton();
        },
      ));
}

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    @required this.text,
    @required this.onClicked,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => RaisedButton(
        shape: const StadiumBorder(),
        color: Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textColor: Colors.white,
        onPressed: onClicked,
        child: Text(
          text,
          style: const TextStyle(fontSize: 24),
        ),
      );
}
