import 'package:dependencies/dependencies.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:profile/profile.dart';
import 'package:shared/shared.dart';

class ProfilePage extends HookConsumerWidget {
  ProfilePage({Key? key}) : super(key: key);

  SizedBox get defaultSpacer => const SizedBox(height: 20);
  final dateFormat = DateFormat.yMMMMd();
  String? _errorText(
    String text,
    IProfileState state,
  ) =>
      text.isEmpty || state.isPostFormValid ? null : 'Invalid post';
  EdgeInsets get defaultPadding => const EdgeInsets.symmetric(horizontal: 16);
  TextStyle get joinedDateStyle => TextStyle(
        color: Colors.grey.withOpacity(.6),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = readProfileViewModel(ref);
    final state = useProfileState(ref);

    final tabController = useTabController(initialLength: 3);
    final controller = useTextEditingController();

    return state.isLoading
        ? const Center(child: CircularProgressIndicator())
        : Builder(
            builder: (context) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                if (state.dailyLimitOfPostsExceeded) {
                  await _openBottomSheet(context);
                }
              });

              final posts = state.user!.posts
                  .where((element) => element.type == PostType.post)
                  .toList();
              final reposts = state.user!.posts
                  .where((element) => element.type == PostType.repost)
                  .toList();
              final quotedPosts = state.user!.posts
                  .where((element) => element.type == PostType.quote)
                  .toList();

              return Scaffold(
                body: SafeArea(
                  child: Padding(
                    padding: defaultPadding,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        defaultSpacer,
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 2,
                                ),
                                shape: BoxShape.circle,
                                color: Colors.grey.shade500,
                              ),
                              child: const Icon(
                                Icons.person,
                                size: 80,
                                color: Colors.white,
                              ),
                            ),
                            Column(
                              children: [
                                Text(state.user!.username),
                                Text(
                                  'Joined at: ${dateFormat.format(state.user!.joinedDate)}',
                                  style: joinedDateStyle,
                                ),
                              ],
                            )
                          ],
                        ),
                        defaultSpacer,
                        TextFormField(
                            autofocus: true,
                            controller: controller,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              labelText: 'Create new post',
                              hintText: 'What\'s happening?',
                              errorText: _errorText(controller.text, state),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  if (_errorText(controller.text, state) ==
                                      null) {
                                    _submit(
                                      context,
                                      controller,
                                      viewModel,
                                      state,
                                      controller.text,
                                    );

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
                                  controller,
                                  viewModel,
                                  state,
                                  text,
                                );
                                if (state.postCreated) {
                                  controller.clear();
                                }
                              }
                            }),
                        defaultSpacer,
                        TabBar(
                          controller: tabController,
                          tabs: [
                            Tab(
                              height: 50,
                              child: Column(
                                children: [
                                  const Text('Posts'),
                                  Text(posts.length.toString()),
                                ],
                              ),
                            ),
                            Tab(
                              height: 50,
                              child: Column(
                                children: [
                                  const Text('Reposts'),
                                  Text(reposts.length.toString()),
                                ],
                              ),
                            ),
                            Tab(
                              height: 50,
                              child: Column(
                                children: [
                                  const Text('Quoted'),
                                  Text(quotedPosts.length.toString()),
                                ],
                              ),
                            ),
                          ],
                        ),
                        defaultSpacer,
                        Expanded(
                          child: TabBarView(
                            controller: tabController,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              ListView.separated(
                                itemBuilder: (context, index) {
                                  final post = posts[index];
                                  return PostWidget(
                                    username: post.author.username,
                                    creationDate: post.creationDate,
                                    text: post.text!,
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    Container(),
                                itemCount: posts.length,
                              ),
                              ListView.separated(
                                itemBuilder: (context, index) {
                                  final post = reposts[index];

                                  return RepostWidget(
                                    authorUsername: post.author.username,
                                    relatedPostAuthorUsername:
                                        post.relatedPost!.author.username,
                                    relatedPostCreationDate:
                                        post.relatedPost!.creationDate,
                                    relatedPostText: post.relatedPost!.text!,
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    Container(),
                                itemCount: reposts.length,
                              ),
                              ListView.separated(
                                itemBuilder: (context, index) {
                                  final post = quotedPosts[index];

                                  return QuotedPostWidget(
                                    creationDate: post.creationDate,
                                    text: post.text!,
                                    username: post.author.username,
                                    relatedPostAuthorUsername:
                                        post.relatedPost!.author.username,
                                    relatedPostCreationDate:
                                        post.relatedPost!.creationDate,
                                    relatedPostText: post.relatedPost!.text!,
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    Container(),
                                itemCount: quotedPosts.length,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }

  Future<void> _openBottomSheet(BuildContext context) async {
    showModalBottomSheet(
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
  }

  void _submit(
    BuildContext context,
    TextEditingController controller,
    IProfileViewModel viewModel,
    IProfileState state,
    String text,
  ) {
    if (state.isPostFormValid) {
      viewModel.createNewPost(text).then((_) => controller.clear());
    }
  }
}
