import 'package:dependencies/dependencies.dart';
import 'package:shared/shared.dart';

abstract class IFetchUser {
  Future<Either<UserFailure, User>> call(int userId);
}

class FetchUser implements IFetchUser {
  final IUserRepository _repository;

  FetchUser(this._repository);

  @override
  Future<Either<UserFailure, User>> call(int userId) async {
    try {
      final response = await _repository.fetchUsers();

      final user = response.fold<User>(
        (l) => throw Exception(),
        (users) => users.firstWhere((user) => user.id == userId),
      );

      return Right(user);
    } catch (e) {
      return Left(UserFailure(type: ExceptionType.serverError));
    }
  }
}
