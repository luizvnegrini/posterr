import 'package:dependencies/dependencies.dart';
import 'package:shared/shared.dart';

abstract class IFetchUserPosts {
  Future<Either<PostFailure, List<Post>>> call(int userId);
}

class FetchUserPosts implements IFetchUserPosts {
  final IUserRepository _repository;

  FetchUserPosts(this._repository);

  @override
  Future<Either<PostFailure, List<Post>>> call(int userId) async {
    try {
      final response = await _repository.fetchUsers();

      final allPosts = response.fold<List<Post>>(
        (l) => throw Exception(),
        (users) {
          final posts = <Post>[];

          posts.addAll(users.firstWhere((user) => user.id == userId).posts);

          posts.sort((a, b) => b.creationDate.compareTo(a.creationDate));
          return posts;
        },
      );

      return Right(allPosts);
    } catch (e) {
      return Left(PostFailure(type: ExceptionType.serverError));
    }
  }
}
