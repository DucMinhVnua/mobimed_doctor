import 'package:flutter/material.dart';
import '../utils/Constant.dart';

class RaisedGradientButton extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final Function onPressed;

  const RaisedGradientButton({
    Key key,
    this.width = double.infinity,
    this.height = 35.0,
    this.onPressed,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: 45,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
                colors: [Color(0xFF32C5FF), Color(0xFF61E4FF)]),
            boxShadow: const [
              BoxShadow(
                color: Constants.colorMain,
                offset: Offset(0, 1.5),
                blurRadius: 1.5,
              ),
            ]),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
              onTap: onPressed,
              child: Center(
                child: Text(
                  text,
                  style: const TextStyle(
                      color: Constants.white,
                      fontWeight: FontWeight.w500,
                      fontFamily: Constants.fontName,
                      letterSpacing: 0,
                      fontSize: 16),
                ),
              )),
        ),
      );
}
