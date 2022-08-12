// ignore_for_file: avoid_returning_this

import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';

class WidgetTestable {
  WidgetTestable.builder();

  late Widget basePage;
  late List<Override> overrides;

  WidgetTestable addPage(Widget page) {
    basePage = page;
    return this;
  }

  WidgetTestable override({
    required List<Override> providers,
  }) {
    overrides = providers;
    return this;
  }

  Widget build() => ProviderScope(
        overrides: overrides,
        child: MaterialApp(
          home: basePage,
        ),
      );
}
