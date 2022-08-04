import 'package:dependencies/dependencies.dart';
import 'package:shared/shared.dart';

abstract class ICreatePostSettings {
  Future<Either<PostSettingsFailure, Unit>> call(PostSettings postSettings);
}

class CreatePostSettings implements ICreatePostSettings {
  final IPostSettingsRepository _repository;

  CreatePostSettings(this._repository);

  @override
  Future<Either<PostSettingsFailure, Unit>> call(
          PostSettings postSettings) async =>
      _repository.createConfig(postSettings);
}
