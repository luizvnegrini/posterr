import 'package:dependencies/dependencies.dart';
import 'package:shared/shared.dart';

abstract class ICreatePost {
  Future<Either<PostFailure, Unit>> call(Post post);
}

class CreatePost implements ICreatePost {
  final IUserRepository _repository;

  CreatePost(this._repository);

  @override
  Future<Either<PostFailure, Unit>> call(Post post) async {
    try {
      final usersResponse = await _repository.fetchUsers();
      await usersResponse.fold(
        (l) async => Left(
          PostFailure(type: ExceptionType.notFound),
        ),
        (users) async {
          users.firstWhere((user) => user.id == post.author.id).posts.add(post);

          await _repository.saveUsers(users);
        },
      );

      return const Right(unit);
    } catch (e) {
      return Left(PostFailure(type: ExceptionType.serverError));
    }
  }
}
