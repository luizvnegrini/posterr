import 'package:dependencies/dependencies.dart';

import '../../shared.dart';

abstract class IUserRepository {
  Future<Either<UserFailure, Unit>> saveUsers(List<User> users);
  Future<Either<UserFailure, List<User>>> fetchUsers();
}
