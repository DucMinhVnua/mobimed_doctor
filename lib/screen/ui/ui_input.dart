import 'package:flutter/material.dart';

import '../../utils/Constant.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.85,
      height: 50,
      decoration: BoxDecoration(
          color: Constants.colorMain.withOpacity(0.05),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Constants.colorMain)),
      child: child,
    );
  }
}

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChange;
  final TextEditingController controller;

  const RoundedInputField(
      {Key key, this.hintText, this.icon, this.onChange, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) => TextFieldContainer(
        child: TextField(
          controller: controller,
          onChanged: onChange,
          // keyboardType: TextInputType.number,
          decoration: InputDecoration(
              icon: Icon(
                icon,
                color: Constants.colorMain,
              ),
              hintText: hintText,
              hintStyle: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
                letterSpacing: 0,
                fontFamily: Constants.fontName,
                color: Constants.grey,
              ),
              border: InputBorder.none),
        ),
      );
}

class RoundedInputPhoneNumber extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onChange;
  final TextEditingController controller;

  const RoundedInputPhoneNumber(
      {Key key, this.hintText, this.onChange, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) => TextFieldContainer(
        child: TextField(
          controller: controller,
          onChanged: onChange,
          textAlign: TextAlign.left,
          maxLines: 1,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              icon: const Icon(
                Icons.phone_android_outlined,
                color: Constants.colorMain,
              ),
              hintText: hintText,
              hintStyle: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
                letterSpacing: 0,
                fontFamily: Constants.fontName,
                color: Constants.grey,
              ),
              border: InputBorder.none),
        ),
      );
}

class RoundedInputFieldPass extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final Function onChangeObscure;
  final bool isObscure;

  const RoundedInputFieldPass(
      {Key key,
      this.hintText,
      this.controller,
      this.onChangeObscure,
      this.isObscure})
      : super(key: key);

  @override
  Widget build(BuildContext context) => TextFieldContainer(
        child: TextField(
          controller: controller,
          obscureText: isObscure,
          decoration: InputDecoration(
              icon: const Icon(
                Icons.lock_outline,
                color: Constants.colorMain,
              ),
              hintText: hintText,
              hintStyle: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
                letterSpacing: 0,
                fontFamily: Constants.fontName,
                color: Constants.grey.withOpacity(0.65),
              ),
              suffixIcon: IconButton(
                  icon: Icon(
                    isObscure ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: onChangeObscure),
              border: InputBorder.none),
        ),
      );
}

class RoundedSelectBox extends StatelessWidget {
  final String name;
  final Widget child;
  const RoundedSelectBox({Key key, this.name, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) => TextFieldContainer(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(
                    top: 12, bottom: 5, left: 5, right: 5),
                child: Text(
                  name,
                  style: TextStyle(
                      color: Constants.colorText.withOpacity(0.8),
                      fontWeight: FontWeight.normal,
                      fontFamily: Constants.fontName,
                      fontSize: 14),
                )),
            const SizedBox(
              width: 20,
            ),
            Expanded(child: child)
          ],
        ),
      );
}

class OTPDigitTextFieldBox extends StatelessWidget {
  final bool first;
  final bool last;
  final TextEditingController controller;
  const OTPDigitTextFieldBox(
      {Key key, @required this.first, @required this.last, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        color: Constants.spacer,
        height: 85,
        width: 55,
        child: AspectRatio(
          aspectRatio: 1,
          child: TextField(
            controller: controller,
            autofocus: true,
            onChanged: (value) {
              if (value.length == 1 && last == false) {
                FocusScope.of(context).nextFocus();
              }
              if (value.isEmpty && first == false) {
                FocusScope.of(context).previousFocus();
              }
            },
            showCursor: false,
            readOnly: false,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            decoration: InputDecoration(
              counter: const Offstage(),
              enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(width: 2, color: Constants.colorMain),
                  borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(width: 2, color: Constants.colorMain),
                  borderRadius: BorderRadius.circular(10)),
              hintText: "_",
            ),
          ),
        ),
      );
}
