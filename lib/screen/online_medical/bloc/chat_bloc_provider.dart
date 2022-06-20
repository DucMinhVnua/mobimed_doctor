import 'package:flutter/widgets.dart';
import 'chat_bloc.dart';

class ChatBlocProvider extends InheritedWidget {
  final ChatBloc bloc;

  const ChatBlocProvider({@required this.bloc, @required Widget child, Key key})
      : super(key: key, child: child);

  static ChatBloc of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ChatBlocProvider>().bloc;

  @override
  bool updateShouldNotify(ChatBlocProvider oldWidget) => false;
}
