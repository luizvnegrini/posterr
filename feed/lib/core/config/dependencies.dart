import 'package:shared/shared.dart';

abstract class IFeedDependencies {
  //repositories

  //usecases
  abstract final IFetchPosts fetchPosts;
  abstract final IFetchPostSettings fetchPostSettings;
  abstract final ICreatePost createPost;

  //datasources

  //data
  abstract final int userId;
}

class FeedDependencies implements IFeedDependencies {
  //repositories

  //usecases
  @override
  final IFetchPosts fetchPosts;
  @override
  final IFetchPostSettings fetchPostSettings;
  @override
  final ICreatePost createPost;

  //datasources

  //data
  @override
  final int userId;

  @override
  FeedDependencies({
    required this.fetchPosts,
    required this.fetchPostSettings,
    required this.userId,
    required this.createPost,
  });

  static FeedDependencies load(SharedDependencies sharedDependencies) =>
      FeedDependencies(
        fetchPosts: sharedDependencies.fetchPosts,
        fetchPostSettings: sharedDependencies.fetchPostSettings,
        userId: sharedDependencies.userId,
        createPost: sharedDependencies.createPost,
      );
}
