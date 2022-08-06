import 'package:shared/shared.dart';

abstract class IProfileDependencies {
  //repositories

  //usecases

  //datasources

  //data
  abstract final int userId;
}

class ProfileDependencies implements IProfileDependencies {
  //repositories

  //usecases

  //datasources

  //data
  @override
  final int userId;

  @override
  ProfileDependencies({
    required this.userId,
  });

  static ProfileDependencies load(SharedDependencies sharedDependencies) =>
      ProfileDependencies(
        userId: sharedDependencies.userId,
      );
}
