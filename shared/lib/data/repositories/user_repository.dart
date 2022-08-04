import 'dart:convert';

import 'package:dependencies/dependencies.dart';

import '../../shared.dart';

class UserRepository implements IUserRepository {
  final ILocalStorageDataSource _localStorageDataSource;

  UserRepository(this._localStorageDataSource);

  @override
  Future<Either<UserFailure, Unit>> createUsers(List<User> users) async {
    try {
      await _localStorageDataSource.save(
        key: 'users',
        value: jsonEncode(
            users.map((user) => UserModel.fromEntity(user)).toList()),
      );

      return const Right(unit);
    } catch (e) {
      return Left(UserFailure(type: ExceptionType.serverError));
    }
  }

  @override
  Future<Either<UserFailure, List<User>>> fetchUsers() async {
    try {
      final usersJson = await _localStorageDataSource.fetch('users');

      if (usersJson == null) return const Right(<User>[]);
      final usersMap = jsonDecode(usersJson) as List;

      return Right(usersMap
          .map((userMap) => UserModel.fromJson(userMap).toEntity())
          .toList());
    } catch (e) {
      return Left(UserFailure(type: ExceptionType.notFound));
    }
  }
}
