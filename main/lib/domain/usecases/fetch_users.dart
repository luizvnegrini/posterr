import 'package:dependencies/dependencies.dart';
import 'package:shared/shared.dart';

abstract class IFetchUsers {
  Future<Either<UserFailure, List<User>>> call();
}

class FetchUsers implements IFetchUsers {
  final IUserRepository _repository;

  FetchUsers(this._repository);

  @override
  Future<Either<UserFailure, List<User>>> call() async =>
      _repository.fetchUsers();
}
