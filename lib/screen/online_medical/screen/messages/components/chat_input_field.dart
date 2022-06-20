import 'dart:async';

import 'package:flutter/material.dart';
import '../../../../../utils/Constant.dart';
import '../../../bloc/chat_bloc.dart';
import '../../../bloc/chat_bloc_provider.dart';
import '../../../model/chat_message.dart';
import '../../../service/signaling.dart';

class ChatInputField extends StatefulWidget {
  ScrollController scrollController;
  ChatInputField({Key key, this.scrollController}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isComposing = false;

  void _handleSubmitted() {
    ChatBlocProvider.of(context).addMessageSend(_textController.text.trim());

    Timer(
        const Duration(milliseconds: 300),
        () => widget.scrollController.animateTo(
              widget.scrollController.position.maxScrollExtent,
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 80),
            ));

    _textController.clear();
    setState(() {
      _isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Constants.kDefaultPadding,
          vertical: kDefaultPadding / 2,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 4),
              blurRadius: 32,
              color: const Color(0xFF087949).withOpacity(0.08),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Icon(Icons.mic, color: kPrimaryColor),
              // IconButton(
              //   icon: Icon(Icons.attach_file),
              //   onPressed: () {},
              // ),
              // IconButton(
              //   icon: Icon(Icons.camera_alt),
              //   onPressed: () {},
              // ),
              // SizedBox(width: kDefaultPadding),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultPadding * 0.75,
                  ),
                  decoration: BoxDecoration(
                    color: Constants.colorMain.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: kDefaultPadding / 4),
                      Flexible(
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          controller: _textController,
                          focusNode: _focusNode,
                          onChanged: (text) {
                            setState(() {
                              _isComposing = text.isNotEmpty;
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: 'Tin nhắn',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(width: kDefaultPadding / 4),
                      GestureDetector(
                          onTap: _isComposing ? () => _handleSubmitted() : null,
                          child: Icon(
                            Icons.send,
                            color: _isComposing
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                          ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
