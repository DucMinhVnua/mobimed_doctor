import 'package:DoctorApp/extension/HexColor.dart';
import 'package:DoctorApp/utils/Constant.dart';
import 'package:flutter/material.dart';

class WidgetButtonIcon extends StatelessWidget {
  final String menuTitle;
  final String iconUrl;
  final Function clickButton;

  const WidgetButtonIcon(
      {Key key,
      @required this.menuTitle,
      @required this.iconUrl,
      @required this.clickButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(0),
      width: 180,
      height: 125,
      child: InkWell(
          onTap: clickButton,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 180.0,
              maxHeight: 180.0,
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: Card(
                    elevation: 5,
                    child: SizedBox(
                      height: 125,
                      width: 180,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(
                            height: 12,
                          ),
                          Image.asset(iconUrl,
                              width: 55, height: 55, fit: BoxFit.cover),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            menuTitle,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color:
                                    HexColor.fromHex(Constants.Color_subtext)),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )));
}

class WidgetButtonIconHome extends StatelessWidget {
  final String menuTitle;
  final String iconUrl;
  final Function clickButton;
  final Color color;

  const WidgetButtonIconHome(
      {Key key,
      @required this.menuTitle,
      @required this.iconUrl,
      @required this.clickButton,
      @required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) => InkWell(
      onTap: clickButton,
      child: Container(
        height: 80,
        width: 175,
        padding: const EdgeInsets.only(left: 8, right: 8),
        margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
        decoration: BoxDecoration(
          color: color,
          gradient: LinearGradient(colors: [color.withOpacity(0.5), color]),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Image.asset(iconUrl, fit: BoxFit.cover),
            Text(
              menuTitle,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0,
                  fontFamily: Constants.fontName),
            ),
          ],
        ),
      ));
}
