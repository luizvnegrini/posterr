import 'package:dependencies/dependencies.dart';
import 'package:shared/shared.dart';

abstract class IRepost {
  Future<Either<PostFailure, Unit>> call({
    required int userId,
    required int relatedPostId,
    required int relatedPostAuthorId,
  });
}

class Repost implements IRepost {
  final IUserRepository _repository;

  Repost(this._repository);

  @override
  Future<Either<PostFailure, Unit>> call({
    required int userId,
    required int relatedPostId,
    required int relatedPostAuthorId,
  }) async {
    try {
      final usersResponse = await _repository.fetchUsers();
      await usersResponse.fold(
        (l) async => Left(
          PostFailure(type: ExceptionType.notFound),
        ),
        (users) async {
          final user = users.firstWhere((element) => element.id == userId);

          if (user.posts
                  .where((x) =>
                      x.creationDate.difference(DateTime.now()).inDays == 0)
                  .length >=
              5) {
            throw PostFailure(type: ExceptionType.dailyLimitExceeded);
          }

          final relatedPostAuthor =
              users.firstWhere((element) => element.id == relatedPostAuthorId);
          int totalPosts = 0;

          for (var user in users) {
            totalPosts += user.posts.length;
          }

          relatedPostAuthor.posts.add(
            Post.repost(
              author: user,
              creationDate: DateTime.now(),
              relatedPost: relatedPostAuthor.posts
                  .firstWhere((post) => post.id == relatedPostId),
              id: totalPosts + 1,
            ),
          );

          await _repository.saveUsers(users);
        },
      );

      return const Right(unit);
    } on PostFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(PostFailure(type: ExceptionType.serverError));
    }
  }
}
