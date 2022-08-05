import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:main/presentation/presentation.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  String get _title => 'Feed';
  String? _errorText(
    String text,
    IHomeState state,
  ) =>
      text.isEmpty || state.isPostFormValid ? null : 'Invalid post';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = readHomeVM(ref);
    final controller = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
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
                  TextFormField(
                      controller: controller,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText: 'Create new post',
                        hintText: 'What\'s happening?',
                        errorText: _errorText(controller.text, state),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            if (_errorText(controller.text, state) == null) {
                              _submit(viewModel, state, controller.text);

                              if (state.postCreated) {
                                controller.clear();
                              }
                            }
                          },
                          child: const Icon(
                            Icons.send,
                          ),
                        ),
                      ),
                      maxLength: state.postSettings!.maxLength,
                      minLines: 1,
                      maxLines: 3,
                      onChanged: viewModel.checkIsPostFormValid,
                      keyboardType: TextInputType.text,
                      enabled: !state.isLoading,
                      onFieldSubmitted: (text) {
                        if (_errorText(controller.text, state) == null) {
                          _submit(
                            viewModel,
                            state,
                            text,
                          );
                          if (state.postCreated) {
                            controller.clear();
                          }
                        }
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
      bottomNavigationBar: BottomNavigationBar(
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
