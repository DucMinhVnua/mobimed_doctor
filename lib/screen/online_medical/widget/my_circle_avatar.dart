import 'package:flutter/material.dart';

class MyCircleAvatar extends StatelessWidget {
  final Object img;

  const MyCircleAvatar({@required this.img, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(.3),
                offset: const Offset(0, 2),
                blurRadius: 5)
          ],
        ),
        child: CircleAvatar(
          backgroundImage: img,
        ),
      );
}
