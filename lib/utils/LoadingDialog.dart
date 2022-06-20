import 'package:flutter/material.dart';

import 'Constant.dart';

// ignore: must_be_immutable
class LoadingDialog extends StatefulWidget {
  LoadingDialogState state;

  bool isShowing() => state != null && state.mounted;

  @override
  createState() => state = LoadingDialogState();
}

class LoadingDialogState extends State<LoadingDialog> {
  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.center,
        child: SizedBox(
          height: 200,
          child: Column(
            children: <Widget>[
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.lightBlue),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Đóng",
                  style: Constants.styleTextNormalWhiteColor,
                ),
              )
            ],
          ),
        ),
      );
}
