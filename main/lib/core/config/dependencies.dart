import 'package:shared/shared.dart';

import '../../domain/domain.dart';

abstract class IMainDependencies {
  //repositories

  //usecases
  abstract final ICreateUsers createUsers;
  abstract final IFetchPosts fetchPosts;
  abstract final IFetchPostSettings fetchPostSettings;
  abstract final ICreatePost createPost;

  //datasources

  //data
  abstract final int userId;
}

class MainDependencies implements IMainDependencies {
  //repositories

  //usecases
  @override
  final ICreateUsers createUsers;
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
  MainDependencies({
    required this.createUsers,
    required this.fetchPosts,
    required this.fetchPostSettings,
    required this.userId,
    required this.createPost,
  });

  static MainDependencies load(SharedDependencies sharedDependencies) =>
      MainDependencies(
        createUsers: CreateUsers(sharedDependencies.userRepository),
        fetchPosts: sharedDependencies.fetchPosts,
        fetchPostSettings: sharedDependencies.fetchPostSettings,
        userId: sharedDependencies.userId,
        createPost: sharedDependencies.createPost,
      );
}
