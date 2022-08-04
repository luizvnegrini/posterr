import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:posterr/presentation/presentation.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  String get title => 'Feed';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = readHomeVM(ref);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: RefreshIndicator(
        onRefresh: viewModel.loadUserFeed,
        child: Column(
          children: [
            HookConsumer(
              builder: (context, ref, child) {
                final state = useHomeState(ref);

                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.separated(
                  itemBuilder: (context, index) => Container(),
                  separatorBuilder: ((context, index) => Container()),
                  itemCount: state.feed!.length,
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.feed),
          label: 'Feed',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ]),
    );
  }
}
