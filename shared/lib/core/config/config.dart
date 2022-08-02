import 'package:dependencies/dependencies.dart';
import 'package:shared/domain/repositories/post_repository.dart';

import '../../shared.dart';

abstract class ISharedDependencies {
  //repositories
  abstract final IPostRepository postRepository;

  //usecases
  abstract final ICreateNewPost createNewPost;
  abstract final IFetchUserPosts fetchUserPosts;

  //datasources
  abstract final ILocalStorageDataSource localStorageDataSource;
}

class SharedDependencies implements ISharedDependencies {
  //repositories
  @override
  final IPostRepository postRepository;

  //usecases
  @override
  final ICreateNewPost createNewPost;
  @override
  final IFetchUserPosts fetchUserPosts;

  //datasources
  @override
  final ILocalStorageDataSource localStorageDataSource;

  SharedDependencies({
    required this.postRepository,
    required this.fetchUserPosts,
    required this.createNewPost,
    required this.localStorageDataSource,
  });

  static SharedDependencies load() {
    final cacheStorageAdapter =
        LocalStorageAdapter(localStorage: LocalStorage('posterr'));
    final postRepository = PostRepository(cacheStorageAdapter);

    return SharedDependencies(
      localStorageDataSource: cacheStorageAdapter,
      postRepository: postRepository,
      fetchUserPosts: FetchUserPosts(postRepository),
      createNewPost: CreateNewPost(postRepository),
    );
  }
}
