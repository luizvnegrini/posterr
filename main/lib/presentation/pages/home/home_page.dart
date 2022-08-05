import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:posterr/presentation/presentation.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  String get title => 'Feed';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = readHomeVM(ref);
    final controller = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: RefreshIndicator(
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
                  TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: 'What\'s happening?',
                        suffixIcon: GestureDetector(
                          onTap: () {
                            _submit(viewModel, state, controller.text);
                            controller.clear();
                          },
                          child: const Icon(
                            Icons.send,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      maxLength: state.postSettings!.maxLength,
                      minLines: 1,
                      maxLines: 3,
                      onChanged: viewModel.checkIsPostFormValid,
                      keyboardType: TextInputType.text,
                      enabled: !state.isLoading,
                      onSubmitted: (text) {
                        _submit(
                          viewModel,
                          state,
                          text,
                        );
                        controller.clear();
                      }),
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
                ],
              );
            },
          ),
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

  void _submit(
    IHomeViewModel viewModel,
    IHomeState state,
    String text,
  ) {
    if (state.isPostFormValid) {
      viewModel.createNewPost(text);
    }
  }
}
