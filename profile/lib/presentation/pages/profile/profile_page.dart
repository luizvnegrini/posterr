import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';

class ProfilePage extends HookConsumerWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: SafeArea(
        child: Text('Profile Page'),
      ),
    );
  }
}
