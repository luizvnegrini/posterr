import 'package:shared/core/config/config.dart';

import '../../domain/domain.dart';

abstract class IMainDependencies {
  //repositories

  //usecases
  abstract final ICreateUsers createUsers;
  abstract final IFetchUsers fetchUsers;
  abstract final IFetchPostSettings fetchPostSettings;

  //datasources
}

class MainDependencies implements IMainDependencies {
  //repositories

  //usecases
  @override
  final ICreateUsers createUsers;
  @override
  final IFetchUsers fetchUsers;
  @override
  final IFetchPostSettings fetchPostSettings;

  //datasources
  @override
  MainDependencies({
    required this.createUsers,
    required this.fetchUsers,
    required this.fetchPostSettings,
  });

  static MainDependencies load(SharedDependencies sharedDependencies) =>
      MainDependencies(
        createUsers: CreateUsers(sharedDependencies.userRepository),
        fetchUsers: FetchUsers(sharedDependencies.userRepository),
        fetchPostSettings:
            FetchPostSettings(sharedDependencies.postSettingsRepository),
      );
}
