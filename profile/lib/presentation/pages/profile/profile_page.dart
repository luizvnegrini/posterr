import 'package:dependencies/dependencies.dart';
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
                          controller: controller,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            labelText: 'Create new post',
                            hintText: 'What\'s happening?',
                            errorText: _errorText(controller.text, state),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                if (_errorText(controller.text, state) ==
                                    null) {
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
                            Padding(
                              padding: defaultPadding,
                              child: ListView.separated(
                                itemBuilder: (context, index) => PostWidget(
                                  post: posts[index],
                                ),
                                separatorBuilder: (context, index) =>
                                    Container(),
                                itemCount: posts.length,
                              ),
                            ),
                            Padding(
                              padding: defaultPadding,
                              child: ListView.separated(
                                itemBuilder: (context, index) => PostWidget(
                                  post: reposts[index],
                                ),
                                separatorBuilder: (context, index) =>
                                    Container(),
                                itemCount: reposts.length,
                              ),
                            ),
                            Padding(
                              padding: defaultPadding,
                              child: ListView.separated(
                                itemBuilder: (context, index) => PostWidget(
                                  post: quotedPosts[index],
                                ),
                                separatorBuilder: (context, index) =>
                                    Container(),
                                itemCount: quotedPosts.length,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  void _submit(
    IProfileViewModel viewModel,
    IProfileState state,
    String text,
  ) {
    if (state.isPostFormValid) {
      viewModel.createNewPost(text);
    }
  }
}

class PostWidget extends HookWidget {
  final Post post;
  final postDateFormatter = DateFormat.MMMMEEEEd();
  final creationDateStyle = TextStyle(
    color: Colors.grey.withOpacity(.5),
    fontSize: 10,
  );
  final defaultSizedBox = const SizedBox(width: 10);

  PostWidget({
    required this.post,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  _getUserImageContainer(30),
                ],
              ),
              defaultSizedBox,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        post.type == PostType.repost
                            ? post.relatedPost!.author.username
                            : post.author.username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      defaultSizedBox,
                      const Text('·'),
                      defaultSizedBox,
                      Text(
                        '${postDateFormatter.format(post.creationDate)} at ${(post.creationDate.hour).toString().padLeft(2, '0')}:${(post.creationDate.minute).toString().padLeft(2, '0')}:${(post.creationDate.second).toString().padLeft(2, '0')}',
                        style: creationDateStyle,
                      ),
                    ],
                  ),
                  _getContent(post.type),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _getUserImageContainer(double size) => Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 2,
          ),
          shape: BoxShape.circle,
          color: Colors.grey.shade500,
        ),
        child: Icon(
          Icons.person,
          size: size,
          color: Colors.white,
        ),
      );

  Widget _getContent(PostType postType) {
    switch (postType) {
      case PostType.post:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.text!),
          ],
        );
      case PostType.quote:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.text!),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black, width: .2),
              ),
              padding: const EdgeInsets.all(5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      _getUserImageContainer(15),
                    ],
                  ),
                  defaultSizedBox,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            post.type == PostType.post
                                ? post.author.username
                                : post.relatedPost!.author.username,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                          defaultSizedBox,
                          const Text('·'),
                          defaultSizedBox,
                          Text(
                            '${postDateFormatter.format(post.creationDate)} at ${(post.creationDate.hour).toString().padLeft(2, '0')}:${(post.creationDate.minute).toString().padLeft(2, '0')}:${(post.creationDate.second).toString().padLeft(2, '0')}',
                            style: creationDateStyle.copyWith(fontSize: 8),
                          ),
                        ],
                      ),
                      Text(post.relatedPost!.text!)
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      case PostType.repost:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.relatedPost!.text!),
          ],
        );
      default:
        throw UnimplementedError();
    }
  }
}
