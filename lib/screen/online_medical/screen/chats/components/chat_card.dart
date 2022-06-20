import 'package:flutter/material.dart';

import '../../../../../utils/AppUtil.dart';
import '../../../../../utils/Constant.dart';
import '../../../model/chat_data.dart';
import '../../../widget/my_circle_avatar.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({
    Key key,
    this.chat,
    this.press,
  }) : super(key: key);

  final ChatContact chat;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: press,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Constants.kDefaultPadding,
              vertical: kDefaultPadding * 0.75),
          child: Row(
            children: [
              Stack(
                children: [
                  const MyCircleAvatar(
                    img: AssetImage('assets/images/avatar.jpg'),
                  ),
                  if (chat.online != null && chat.online)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: 16,
                        width: 16,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                      ),
                    )
                ],
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chat.fullName,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        chat.phoneNumber,
                        style: const TextStyle(
                            color: Constants.colorMain,
                            fontSize: 14,
                            fontWeight: FontWeight.w300),
                      ),
                      const SizedBox(height: 5),
                      Opacity(
                        opacity: 0.64,
                        child: Text(
                          chat.lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Opacity(
                opacity: 0.64,
                child: Text(AppUtil.convertToAgo(chat.lastTime)),
              ),
            ],
          ),
        ),
      );
}
