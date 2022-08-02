import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';

import '../../../flavors/flavors.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(F.title),
      ),
      body: const Text('Initial page'),
    );
  }
}
