import 'package:shared/core/config/config.dart';

import '../../domain/domain.dart';

abstract class IMainDependencies {
  //repositories

  //usecases
  abstract final ICreateUsers createUsers;
  abstract final IFetchUsers fetchUsers;

  //datasources
}

class MainDependencies implements IMainDependencies {
  //repositories

  //usecases
  @override
  final ICreateUsers createUsers;
  @override
  final IFetchUsers fetchUsers;

  //datasources
  @override
  MainDependencies({
    required this.createUsers,
    required this.fetchUsers,
  });

  static MainDependencies load(SharedDependencies sharedDependencies) =>
      MainDependencies(
        createUsers: CreateUsers(sharedDependencies.userRepository),
        fetchUsers: FetchUsers(sharedDependencies.userRepository),
      );
}
