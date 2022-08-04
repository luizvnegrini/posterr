import 'package:dependencies/dependencies.dart';
import 'package:shared/shared.dart';

abstract class ICreateUsers {
  Future<Either<UserFailure, Unit>> call(List<User> users);
}

class CreateUsers implements ICreateUsers {
  final IUserRepository _repository;

  CreateUsers(this._repository);

  @override
  Future<Either<UserFailure, Unit>> call(List<User> users) async =>
      _repository.saveUsers(users);
}
