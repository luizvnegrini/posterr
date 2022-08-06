import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:profile/profile.dart';
import 'package:shared/shared.dart';

class ProfilePage extends HookConsumerWidget {
  ProfilePage({Key? key}) : super(key: key);

  SizedBox get defaultSpacer => const SizedBox(height: 20);
  final dateFormat = DateFormat.yMMMMd();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 3);
    final state = useProfileState(ref);

    return state.isLoading
        ? const Center(child: CircularProgressIndicator())
        : Builder(
            builder: (context) {
              final posts =
                  state.posts!.where((post) => post.type == PostType.post);
              final reposts =
                  state.posts!.where((post) => post.type == PostType.repost);
              final quotedPosts =
                  state.posts!.where((post) => post.type == PostType.quote);

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
                              const Text('user name'),
                              Text(
                                  'Joined at: ${dateFormat.format(state.user!.joinedDate)}'),
                            ],
                          )
                        ],
                      ),
                      defaultSpacer,
                      const Text('create new post here'),
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
                              itemBuilder: (context, index) =>
                                  const Text('post'),
                              separatorBuilder: (context, index) => Container(),
                              itemCount: posts.length,
                            ),
                            ListView.separated(
                              itemBuilder: (context, index) =>
                                  const Text('repost'),
                              separatorBuilder: (context, index) => Container(),
                              itemCount: reposts.length,
                            ),
                            ListView.separated(
                              itemBuilder: (context, index) =>
                                  const Text('teste'),
                              separatorBuilder: (context, index) => Container(),
                              itemCount: quotedPosts.length,
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
}
