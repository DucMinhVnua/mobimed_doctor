import 'package:flutter/material.dart';

import '../../../../../utils/AppUtil.dart';
import '../../../../../utils/Constant.dart';
import '../../../model/chat_message.dart';
import 'audio_message.dart';
import 'text_message.dart';
import 'video_message.dart';

class Message extends StatelessWidget {
  final ChatMessage message;
  String img;
  String gender;

  Message({
    Key key,
    this.message,
    this.img,
    this.gender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget messageContaint(ChatMessage message) =>
        TextMessage(message: message, isLeft: !message.isSender);

    return Padding(
      padding: const EdgeInsets.only(top: Constants.kDefaultPadding),
      child: Row(
        mainAxisAlignment:
            message.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isSender) ...[
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: ClipOval(
                  child: AppUtil.imageAvatarDoctor(img, gender, 35, 35)),
            ),
            const SizedBox(width: kDefaultPadding / 2),
          ],
          messageContaint(message),
          if (message.isSender) MessageStatusDot(status: message.messageStatus)
        ],
      ),
    );
  }
}

class MessageStatusDot extends StatelessWidget {
  final int status;
  const MessageStatusDot({Key key, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color dotColor(int status) {
      if (status == MessageStatus.not_sent.index) {
        return Colors.red;
      }
      if (status == MessageStatus.sent.index ||
          status == MessageStatus.viewed.index) {
        return Constants.colorMain;
      }
      return Colors.transparent;
    }

    return Container(
      margin: const EdgeInsets.only(left: kDefaultPadding / 2),
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color: dotColor(status),
        shape: BoxShape.circle,
      ),
      child: Icon(
        status == MessageStatus.not_sent ? Icons.close : Icons.done,
        size: 8,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}
