import 'package:flutter/material.dart';

import '../../../../../utils/Constant.dart';
import '../../../bloc/chat_bloc.dart';
import '../../../bloc/chat_bloc_provider.dart';
import '../../../model/chat_data.dart';
import '../../../model/chat_message.dart';
import 'chat_input_field.dart';
import 'message.dart';

class Body extends StatelessWidget {
  List<ChatHistoryMessages> arrMess;
  ScrollController scrollController;
  Body({Key key, this.arrMess, this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatBloc chatBloc = ChatBlocProvider.of(context);
    chatBloc?.fetchAllMessage();
    // scrollToEnd();
    return Column(
      children: [
        Expanded(
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: StreamBuilder<List<ChatMessage>>(
                    stream: chatBloc.stream,
                    builder: (context, snapShot) {
                      if (snapShot.hasData && snapShot.data.isNotEmpty) {
                        return ListView.builder(
                            controller: scrollController,
                            itemCount: snapShot.data.length,
                            itemBuilder: (context, index) =>
                                Message(message: snapShot.data[index]));
                      } else {
                        return Container();
                      }
                    }))),
        ChatInputField(scrollController: scrollController),
      ],
    );
  }
}
