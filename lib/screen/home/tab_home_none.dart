import 'package:flutter/material.dart';

class TabHomeNone extends StatefulWidget {
  const TabHomeNone({Key key}) : super(key: key);

  @override
  _TabHomeNoneState createState() => _TabHomeNoneState();
}

class _TabHomeNoneState extends State<TabHomeNone> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Text('Tính năng này đang được phát triển!')));
}
