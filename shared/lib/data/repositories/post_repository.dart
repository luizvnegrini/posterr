import 'dart:convert';

import 'package:dependencies/dependencies.dart';
import 'package:shared/domain/repositories/post_repository.dart';

import '../../shared.dart';

class PostRepository implements IPostRepository {
  final ILocalStorageDataSource _cacheStorage;

  PostRepository(this._cacheStorage);

  @override
  Future<Either<PostFailure, Unit>> createNewPost(Post post) async {
    try {
      await _cacheStorage.save(
        key: post.userId.toString(),
        value: jsonEncode(PostModel.fromEntity(post)),
      );

      return const Right(unit);
    } catch (e) {
      return Left(PostFailure(type: ExceptionType.serverError));
    }
  }

  @override
  Future<Either<PostFailure, List<Post>>> fetchUserPosts(int userId) async {
    try {
      // final posts = await _cacheStorage.fetch(userId.toString());
      throw UnimplementedError();
      // return const Right(unit);
    } catch (e) {
      return Left(PostFailure(type: ExceptionType.notFound));
    }
  }
}
