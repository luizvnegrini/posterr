import 'package:dependencies/dependencies.dart';
import 'package:shared/shared.dart';

abstract class IFetchPosts {
  Future<Either<PostFailure, List<Post>>> call();
}

class FetchPosts implements IFetchPosts {
  final IUserRepository _repository;

  FetchPosts(this._repository);

  @override
  Future<Either<PostFailure, List<Post>>> call() async {
    try {
      final response = await _repository.fetchUsers();

      final allPosts = response.fold<List<Post>>(
        (l) => throw Exception(),
        (users) {
          final posts = <Post>[];

          for (var user in users) {
            posts.addAll(user.posts);
          }

          if (posts.isEmpty) {
            throw PostFailure(type: ExceptionType.notFound);
          }

          posts.sort((a, b) => b.creationDate.compareTo(a.creationDate));
          return posts;
        },
      );

      return Right(allPosts);
    } on BaseException catch (e) {
      return Left(PostFailure(type: e.type));
    } on Exception {
      return Left(PostFailure(type: ExceptionType.serverError));
    }
  }
}
