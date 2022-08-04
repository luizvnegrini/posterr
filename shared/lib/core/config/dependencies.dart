import 'package:dependencies/dependencies.dart';

import '../../shared.dart';

abstract class ISharedDependencies {
  //repositories
  abstract final IUserRepository userRepository;

  //usecases

  //datasources
  abstract final ILocalStorageDataSource localStorageDataSource;
}

class SharedDependencies implements ISharedDependencies {
  //repositories
  @override
  final IUserRepository userRepository;

  //usecases

  //datasources
  @override
  final ILocalStorageDataSource localStorageDataSource;

  SharedDependencies({
    required this.localStorageDataSource,
    required this.userRepository,
  });

  static Future<SharedDependencies> load() async {
    final storage = LocalStorage('posterr');
    await storage.ready;

    final cacheStorageAdapter = LocalStorageAdapter(localStorage: storage);
    final userRepository = UserRepository(cacheStorageAdapter);

    return SharedDependencies(
      localStorageDataSource: cacheStorageAdapter,
      userRepository: userRepository,
    );
  }
}
