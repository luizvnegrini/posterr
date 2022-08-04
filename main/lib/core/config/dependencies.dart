import 'package:shared/shared.dart';

import '../../domain/domain.dart';

abstract class IMainDependencies {
  //repositories

  //usecases
  abstract final ICreateUsers createUsers;
  abstract final IFetchPosts fetchUsers;
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
  final IFetchPosts fetchUsers;
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
    required this.fetchUsers,
    required this.fetchPostSettings,
    required this.userId,
    required this.createPost,
  });

  static MainDependencies load(SharedDependencies sharedDependencies) =>
      MainDependencies(
        createUsers: CreateUsers(sharedDependencies.userRepository),
        fetchUsers: FetchPosts(sharedDependencies.userRepository),
        fetchPostSettings:
            FetchPostSettings(sharedDependencies.postSettingsRepository),
        userId: sharedDependencies.userId,
        createPost: sharedDependencies.createPost,
      );
}
