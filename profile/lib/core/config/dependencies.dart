import 'package:profile/profile.dart';
import 'package:shared/shared.dart';

abstract class IProfileDependencies {
  //repositories

  //usecases
  abstract final IFetchUserPosts fetchUserPosts;
  abstract final IFetchUser fetchUser;

  //datasources

  //data
  abstract final int userId;
}

class ProfileDependencies implements IProfileDependencies {
  //repositories

  //usecases
  @override
  IFetchUserPosts fetchUserPosts;
  @override
  IFetchUser fetchUser;

  //datasources

  //data
  @override
  final int userId;

  @override
  ProfileDependencies({
    required this.userId,
    required this.fetchUserPosts,
    required this.fetchUser,
  });

  static ProfileDependencies load(SharedDependencies sharedDependencies) =>
      ProfileDependencies(
        userId: sharedDependencies.userId,
        fetchUserPosts: FetchUserPosts(sharedDependencies.userRepository),
        fetchUser: FetchUser(sharedDependencies.userRepository),
      );
}
