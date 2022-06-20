
import 'package:flutter/material.dart';

class ParentProviderWithSearch extends InheritedWidget {
  final String searchKey;
  final Widget child;

  ParentProviderWithSearch({this.searchKey, this.child});

  @override
  bool updateShouldNotify(ParentProviderWithSearch oldWidget) {
    return true;
  }

  static ParentProviderWithSearch of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ParentProviderWithSearch>();
}