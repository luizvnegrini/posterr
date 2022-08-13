import 'package:dependencies/dependencies.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

import '../../presentation.dart';

class FeedPage extends HookConsumerWidget {
  const FeedPage({Key? key}) : super(key: key);

  String get _title => 'Feed';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = readFeedViewModel(ref);
    final controller = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: viewModel.loadFeed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: HookConsumer(
              builder: (context, ref, child) {
                final state = useFeedState(ref);

                if (state.postCreated) {
                  WidgetsBinding.instance.addPostFrameCallback(
                    ((timeStamp) => showSnackBar(
                          ref,
                          const SnackBar(
                            elevation: .8,
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                            content: Text('Post created with success!'),
                          ),
                        )),
                  );
                }

                WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                  if (state.dailyLimitOfPostsExceeded) {
                    await _openBottomSheet(context);
                  }
                });

                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (state.postToMention == null)
                      PostFormWidget(
                        controller: controller,
                        onFieldSubmitted: (text) => _submit(
                          context,
                          controller,
                          viewModel,
                          state,
                          text,
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () => _submit(
                            context,
                            controller,
                            viewModel,
                            state,
                            controller.text,
                          ),
                          child: const Icon(
                            Icons.send,
                          ),
                        ),
                        validator: (text) => _validate(text, state),
                        enabled: !state.isLoading,
                        maxLength: state.postSettings!.maxLength,
                      ),
                    if (state.postToMention != null)
                      PostFormWidget.quote(
                        controller: controller,
                        onFieldSubmitted: (text) => _submit(
                          context,
                          controller,
                          viewModel,
                          state,
                          text,
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () => _submit(
                            context,
                            controller,
                            viewModel,
                            state,
                            controller.text,
                          ),
                          child: const Icon(
                            Icons.send,
                          ),
                        ),
                        validator: (text) => _validate(text, state),
                        enabled: !state.isLoading,
                        maxLength: state.postSettings!.maxLength,
                        postToMentionCreationDate:
                            state.postToMention!.creationDate,
                        postToMentionText: state.postToMention!.text,
                        postToMentionUsername:
                            state.postToMention!.author.username,
                        removeQuote: viewModel.removeQuote,
                      ),
                    const Divider(height: 40),
                    Expanded(
                      flex: 3,
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
                                authorUsername: post.author.username,
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
                                      children: [
                                        const Spacer(),
                                        IconButton(
                                          onPressed: post.type !=
                                                  PostType.repost
                                              ? () => viewModel.executeRepost(
                                                    authorId: post.author.id,
                                                    relatedPostId: post.id,
                                                  )
                                              : null,
                                          icon: const Icon(Icons.refresh),
                                        ),
                                        IconButton(
                                          onPressed: post.type == PostType.post
                                              ? () =>
                                                  viewModel.mentionPost(post)
                                              : null,
                                          icon: const Icon(Icons.format_quote),
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

  bool checkIsFormValid(
    String? text,
    IFeedState state,
  ) =>
      (text != null && text.isNotEmpty) &&
              (text.length >= state.postSettings!.minLength &&
                  text.length <= state.postSettings!.maxLength)
          ? true
          : false;

  String? _validate(
    String? text,
    IFeedState state,
  ) {
    if (text == null || text.isEmpty) return null;

    final isValid = checkIsFormValid(text, state);

    if (isValid) return null;

    return 'Invalid post';
  }

  void _submit(
    BuildContext context,
    TextEditingController controller,
    IFeedViewModel viewModel,
    IFeedState state,
    String text,
  ) {
    if (checkIsFormValid(text, state)) {
      if (state.postToMention != null) {
        viewModel
            .executeQuotePost(
              text: text,
              relatedPostId: state.postToMention!.id,
              userId: state.user!.id,
            )
            .then((_) => controller.clear());
        return;
      }
      viewModel
          .createNewPost(
            text,
            state.user!.id,
          )
          .then((_) => controller.clear());
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
