import 'package:dependencies/dependencies.dart';
import 'package:shared/domain/repositories/post_repository.dart';

import '../../shared.dart';

abstract class IFetchUserPosts {
  Future<Either<PostFailure, List<Post>>> call(int userId);
}

class FetchUserPosts implements IFetchUserPosts {
  final IPostRepository _repository;

  FetchUserPosts(this._repository);

  @override
  Future<Either<PostFailure, List<Post>>> call(int userId) async =>
      _repository.fetchUserPosts(userId);
}
