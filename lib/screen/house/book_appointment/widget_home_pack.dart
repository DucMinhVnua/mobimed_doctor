import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../utils/AppUtil.dart';
import '../../../utils/Constant.dart';

class WidgetHomePack extends StatelessWidget {
  String name, imageId;
  dynamic price;
  WidgetHomePack({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          imageId != null && imageId.isNotEmpty
              ? ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(5)),
                  child: FadeInImage.assetNetwork(
                      fit: BoxFit.fill,
                      height: 75,
                      width: double.infinity,
                      placeholder: 'assets/old/defaultimage.png',
                      image: dotenv.env['BASE_API_URL_FILE_PREVIEW_URL'] +
                          imageId),
                )
              : Container(
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(5)),
                    image: DecorationImage(
                      image: AssetImage('assets/old/defaultimage.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  height: 75,
                  width: double.infinity,
                ),
          const SizedBox(height: 3),
          Expanded(
              child: Text(
            name.length > 23 ? '${name.substring(0, 23)}...' : name,
            style: const TextStyle(
                color: Constants.colorText,
                fontWeight: FontWeight.w500,
                fontFamily: Constants.fontName,
                fontSize: 12),
          )),
          Expanded(
              child: Text(
            'Giá: ${AppUtil.convertMoney(price)}',
            style: const TextStyle(
                color: Constants.colorMain,
                fontWeight: FontWeight.normal,
                fontFamily: Constants.fontName,
                fontSize: 12),
          ))
        ],
      );
}

class ButtonText extends StatelessWidget {
  final String text;
  final Function press;

  const ButtonText({Key key, this.text, this.press}) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: press,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Text(
          text,
          style: const TextStyle(
              decoration: TextDecoration.underline,
              fontStyle: FontStyle.italic,
              color: Constants.colorTextHint,
              fontWeight: FontWeight.normal,
              fontFamily: Constants.fontName,
              fontSize: 13),
        ),
      ));
}
