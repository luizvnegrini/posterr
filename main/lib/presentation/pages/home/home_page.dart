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
        child: HookConsumer(
          builder: (context, ref, child) {
            final state = useHomeState(ref);

            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      final post = state.feedItems![index];

                      return Text(post.creationDate.toIso8601String());
                    },
                    separatorBuilder: ((context, index) => Container()),
                    itemCount: state.feedItems!.length,
                  ),
                ),
                TextField(
                  maxLength: state.postSettings!.maxLength,
                )
              ],
            );
          },
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
