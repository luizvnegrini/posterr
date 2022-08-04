import 'package:dependencies/dependencies.dart';
import 'package:shared/data/repositories/post_settings_repository.dart';

import '../../shared.dart';

abstract class ISharedDependencies {
  //repositories
  abstract final IUserRepository userRepository;
  abstract final IPostSettingsRepository postSettingsRepository;

  //usecases

  //datasources
  abstract final ILocalStorageDataSource localStorageDataSource;
}

class SharedDependencies implements ISharedDependencies {
  //repositories
  @override
  final IUserRepository userRepository;
  @override
  final IPostSettingsRepository postSettingsRepository;

  //usecases

  //datasources
  @override
  final ILocalStorageDataSource localStorageDataSource;

  SharedDependencies({
    required this.localStorageDataSource,
    required this.userRepository,
    required this.postSettingsRepository,
  });

  static Future<SharedDependencies> load() async {
    final storage = LocalStorage('posterr');
    await storage.ready;

    final cacheStorageAdapter = LocalStorageAdapter(localStorage: storage);

    return SharedDependencies(
      localStorageDataSource: cacheStorageAdapter,
      userRepository: UserRepository(cacheStorageAdapter),
      postSettingsRepository: PostSettingsRepository(cacheStorageAdapter),
    );
  }
}
