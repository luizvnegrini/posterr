import 'package:dependencies/dependencies.dart';
import 'package:shared/data/repositories/post_settings_repository.dart';

import '../../shared.dart';

abstract class ISharedDependencies {
  //repositories
  abstract final IUserRepository userRepository;
  abstract final IPostSettingsRepository postSettingsRepository;

  //usecases
  abstract final ICreatePost createPost;

  //datasources
  abstract final ILocalStorageDataSource localStorageDataSource;

  //data
  abstract final int userId;
}

class SharedDependencies implements ISharedDependencies {
  //repositories
  @override
  final IUserRepository userRepository;
  @override
  final IPostSettingsRepository postSettingsRepository;

  //usecases
  @override
  final ICreatePost createPost;

  //datasources
  @override
  final ILocalStorageDataSource localStorageDataSource;

  //data
  @override
  final int userId;

  SharedDependencies({
    required this.localStorageDataSource,
    required this.userRepository,
    required this.postSettingsRepository,
    required this.userId,
    required this.createPost,
  });

  static Future<SharedDependencies> load() async {
    final storage = LocalStorage('posterr');
    await storage.ready;

    final cacheStorageAdapter = LocalStorageAdapter(localStorage: storage);
    final userRepository = UserRepository(cacheStorageAdapter);

    return SharedDependencies(
      localStorageDataSource: cacheStorageAdapter,
      userRepository: userRepository,
      postSettingsRepository: PostSettingsRepository(cacheStorageAdapter),
      userId: 5,
      createPost: CreatePost(userRepository),
    );
  }
}
