import 'package:shared/shared.dart';

abstract class IProfileDependencies {
  //repositories

  //usecases
  abstract final IFetchUser fetchUser;

  //datasources

  //data
  abstract final int userId;
}

class ProfileDependencies implements IProfileDependencies {
  //repositories

  //usecases
  @override
  IFetchUser fetchUser;

  //datasources

  //data
  @override
  final int userId;

  @override
  ProfileDependencies({
    required this.userId,
    required this.fetchUser,
  });

  static ProfileDependencies load(SharedDependencies sharedDependencies) =>
      ProfileDependencies(
        userId: sharedDependencies.userId,
        fetchUser: FetchUser(sharedDependencies.userRepository),
      );
}
