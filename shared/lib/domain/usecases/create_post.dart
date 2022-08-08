import 'package:dependencies/dependencies.dart';
import 'package:shared/shared.dart';

abstract class ICreatePost {
  Future<Either<PostFailure, Unit>> call({
    required String text,
    required int userId,
  });
}

class CreatePost implements ICreatePost {
  final IUserRepository _repository;

  CreatePost(this._repository);

  @override
  Future<Either<PostFailure, Unit>> call({
    required String text,
    required int userId,
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

          int totalPosts = 0;

          for (var user in users) {
            totalPosts += user.posts.length;
          }

          user.posts.add(
            Post.original(
              author: users.firstWhere((element) => element.id == userId),
              creationDate: DateTime.now(),
              text: text,
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
