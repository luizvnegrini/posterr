import 'package:dependencies/dependencies.dart';
import 'package:shared/domain/repositories/post_repository.dart';

import '../../shared.dart';

abstract class ICreateNewPost {
  Future<Either<PostFailure, Unit>> call(Post post);
}

class CreateNewPost implements ICreateNewPost {
  final IPostRepository _repository;

  CreateNewPost(this._repository);

  @override
  Future<Either<PostFailure, Unit>> call(Post post) async =>
      _repository.createNewPost(post);
}
