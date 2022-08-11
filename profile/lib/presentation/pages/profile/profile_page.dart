import 'package:dependencies/dependencies.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:profile/profile.dart';
import 'package:shared/shared.dart';

class ProfilePage extends HookConsumerWidget {
  ProfilePage({Key? key}) : super(key: key);

  SizedBox get defaultSpacer => const SizedBox(height: 20);
  final dateFormat = DateFormat.yMMMMd();
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

  String? _validate(
    String? text,
    IProfileState state,
  ) {
    if (text == null || text.isEmpty) return null;

    final isValid = checkIsFormValid(text, state);

    if (isValid) return null;

    return 'Invalid post';
  }

  bool checkIsFormValid(
    String? text,
    IProfileState state,
  ) =>
      (text != null && text.isNotEmpty) &&
              (text.length >= state.postSettings!.minLength &&
                  text.length <= state.postSettings!.maxLength)
          ? true
          : false;

  void _submit(
    BuildContext context,
    TextEditingController controller,
    IProfileViewModel viewModel,
    IProfileState state,
    String text,
  ) {
    if (checkIsFormValid(text, state)) {
      viewModel.createNewPost(text).then((_) => controller.clear());
    }
  }
}
