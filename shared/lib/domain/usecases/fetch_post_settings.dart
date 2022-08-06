import 'package:dependencies/dependencies.dart';

import '../../shared.dart';

abstract class IFetchPostSettings {
  Future<Either<PostSettingsFailure, PostSettings?>> call();
}

class FetchPostSettings implements IFetchPostSettings {
  final IPostSettingsRepository _repository;

  FetchPostSettings(this._repository);

  @override
  Future<Either<PostSettingsFailure, PostSettings?>> call() async =>
      _repository.fetchSettings();
}
