import 'package:shared/shared.dart';

abstract class IFeedDependencies {
  //repositories

  //usecases
  abstract final ICreatePost createPost;

  //datasources

  //data
  abstract final int userId;
}

class FeedDependencies implements IFeedDependencies {
  //repositories

  //usecases
  @override
  final ICreatePost createPost;

  //datasources

  //data
  @override
  final int userId;

  @override
  FeedDependencies({
    required this.userId,
    required this.createPost,
  });

  static FeedDependencies load(SharedDependencies sharedDependencies) =>
      FeedDependencies(
        userId: sharedDependencies.userId,
        createPost: sharedDependencies.createPost,
      );
}
