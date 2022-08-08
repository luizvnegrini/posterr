import 'package:feed/feed.dart';
import 'package:shared/shared.dart';

import '../../domain/domain.dart';

abstract class IMainDependencies {
  //repositories
  abstract final IPostSettingsRepository postSettingsRepository;

  //usecases
  abstract final ICreateUsers createUsers;
  abstract final IFetchPosts fetchPosts;
  abstract final IFetchPostSettings fetchPostSettings;
  abstract final ICreatePost createPost;
  abstract final IRepost repost;
  abstract final IQuotePost quotePost;

  //datasources

  //data
  abstract final int userId;
}

class MainDependencies implements IMainDependencies {
  //repositories
  @override
  final IPostSettingsRepository postSettingsRepository;

  //usecases
  @override
  final ICreateUsers createUsers;
  @override
  final IFetchPosts fetchPosts;
  @override
  final IFetchPostSettings fetchPostSettings;
  @override
  final ICreatePost createPost;
  @override
  final IRepost repost;
  @override
  final IQuotePost quotePost;

  //datasources

  //data
  @override
  final int userId;

  @override
  MainDependencies({
    required this.postSettingsRepository,
    required this.createUsers,
    required this.fetchPosts,
    required this.fetchPostSettings,
    required this.userId,
    required this.createPost,
    required this.repost,
    required this.quotePost,
  });

  static MainDependencies load(SharedDependencies sharedDependencies) {
    final postSettingsRepository =
        PostSettingsRepository(sharedDependencies.localStorageDataSource);

    return MainDependencies(
      postSettingsRepository: postSettingsRepository,
      createUsers: CreateUsers(sharedDependencies.userRepository),
      fetchPosts: FetchPosts(sharedDependencies.userRepository),
      fetchPostSettings: FetchPostSettings(postSettingsRepository),
      userId: sharedDependencies.userId,
      createPost: sharedDependencies.createPost,
      repost: Repost(sharedDependencies.userRepository),
      quotePost: QuotePost(sharedDependencies.userRepository),
    );
  }
}
