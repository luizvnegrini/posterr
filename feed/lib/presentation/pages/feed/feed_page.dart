import 'package:dependencies/dependencies.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

import '../../presentation.dart';

class FeedPage extends HookConsumerWidget {
  const FeedPage({Key? key}) : super(key: key);

  String get _title => 'Feed';
  String? _errorText(
    String text,
    IFeedState state,
  ) =>
      text.isEmpty || state.isPostFormValid ? null : 'Invalid post';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = readFeedViewModel(ref);
    final controller = useTextEditingController();
    final state = useFeedState(ref);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (state.dailyLimitOfPostsExceeded) {
        await _openBottomSheet(context);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: viewModel.loadUserFeed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: HookConsumer(
              builder: (context, ref, child) {
                if (state.postCreated) {
                  controller.text = '';
                }

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
                                _submit(
                                    context, viewModel, state, controller.text);

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
                              context,
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

                          Widget postWidget;

                          switch (post.type) {
                            case PostType.post:
                              postWidget = PostWidget(
                                username: post.author.username,
                                creationDate: post.creationDate,
                                text: post.text!,
                              );
                              break;
                            case PostType.repost:
                              postWidget = RepostWidget(
                                relatedPostAuthorUsername:
                                    post.relatedPost!.author.username,
                                relatedPostCreationDate:
                                    post.relatedPost!.creationDate,
                                relatedPostText: post.relatedPost!.text!,
                              );
                              break;
                            case PostType.quote:
                              postWidget = QuotedPostWidget(
                                creationDate: post.creationDate,
                                text: post.text!,
                                username: post.author.username,
                                relatedPostAuthorUsername:
                                    post.relatedPost!.author.username,
                                relatedPostCreationDate:
                                    post.relatedPost!.creationDate,
                                relatedPostText: post.relatedPost!.text!,
                              );
                              break;
                            default:
                              throw UnimplementedError();
                          }

                          return Card(
                            color: Colors.orangeAccent,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  postWidget,
                                  Align(
                                    child: Row(
                                      children: const [
                                        Spacer(),
                                        IconButton(
                                          onPressed: null,
                                          icon: Icon(Icons.refresh),
                                        ),
                                        IconButton(
                                          onPressed: null,
                                          icon: Icon(Icons.format_quote),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
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
      ),
    );
  }

  void _submit(
    BuildContext context,
    IFeedViewModel viewModel,
    IFeedState state,
    String text,
  ) {
    if (state.isPostFormValid) {
      viewModel.createNewPost(text);
    }
  }

  Future<void> _openBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      // useRootNavigator: true,
      builder: (context) =>
          const DailyLimitOfPostsExceededBottomContentWidget(),
    );
    return;
  }
}
