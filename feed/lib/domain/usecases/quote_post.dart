import 'package:dependencies/dependencies.dart';
import 'package:shared/shared.dart';

abstract class IQuotePost {
  Future<Either<PostFailure, Unit>> call({
    required String text,
    required int relatedPostId,
    required int authorId,
  });
}

class QuotePost implements IQuotePost {
  final IUserRepository _repository;

  QuotePost(this._repository);

  @override
  Future<Either<PostFailure, Unit>> call({
    required String text,
    required int relatedPostId,
    required int authorId,
  }) async {
    try {
      final usersResponse = await _repository.fetchUsers();
      await usersResponse.fold(
        (l) async => Left(
          PostFailure(type: ExceptionType.notFound),
        ),
        (users) async {
          final user = users.firstWhere((element) => element.id == authorId);
          int totalPosts = 0;

          if (user.posts
                  .where((x) =>
                      x.creationDate.difference(DateTime.now()).inDays == 0)
                  .length >=
              5) {
            throw PostFailure(type: ExceptionType.dailyLimitExceeded);
          }

          for (var user in users) {
            totalPosts += user.posts.length;
          }

          user.posts.add(
            Post.quote(
              text: text,
              author: user,
              creationDate: DateTime.now(),
              relatedPost:
                  user.posts.firstWhere((post) => post.id == relatedPostId),
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
