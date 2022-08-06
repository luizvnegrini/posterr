import 'package:dependencies/dependencies.dart';
import 'package:feed/feed.dart';
import 'package:flutter/material.dart';
import 'package:main/presentation/presentation.dart';
import 'package:profile/profile.dart';

class HomePage extends HookConsumerWidget {
  HomePage({Key? key}) : super(key: key);

  final bottomNavBarPages = [
    const FeedPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = readHomeViewModel(ref);
    final state = useHomeState(ref);

    return Scaffold(
      body: bottomNavBarPages.elementAt(state.currentBottomNavBarIndex),
      bottomNavigationBar: HookConsumer(
        builder: (context, ref, child) => BottomNavigationBar(
          currentIndex: state.currentBottomNavBarIndex,
          onTap: viewModel.updateBottomNavBarIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.feed),
              label: 'Feed',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
