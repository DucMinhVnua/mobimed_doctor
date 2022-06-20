import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../utils/Constant.dart';
import '../../../model/chat_message.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({
    Key key,
    this.message,
    this.isLeft,
  }) : super(key: key);

  final ChatMessage message;
  final bool isLeft;

  @override
  Widget build(BuildContext context) => Flexible(
      child: Container(
          // margin: EdgeInsets.only(top: kDefaultPadding),
          padding: const EdgeInsets.symmetric(
            horizontal: Constants.kDefaultPadding * 0.75,
            vertical: kDefaultPadding / 2,
          ),
          decoration: BoxDecoration(
            color:
                Constants.colorMain.withOpacity(message.isSender ? 0.6 : 0.05),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment:
                isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              Text(
                message.text,
                style: TextStyle(
                  fontFamily: Constants.fontName,
                  fontSize: 15,
                  color: message.isSender
                      ? Colors.white
                      : Theme.of(context).textTheme.bodyText1.color,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                (message.time != null)
                    ? DateFormat('HH:mm').format(message.time)
                    : '',
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: Constants.fontName,
                  color: message.isSender
                      ? Colors.white
                      : Theme.of(context).textTheme.bodyText1.color,
                ),
              ),
            ],
          )));
}
