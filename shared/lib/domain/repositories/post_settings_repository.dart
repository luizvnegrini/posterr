import 'package:dependencies/dependencies.dart';

import '../../shared.dart';

abstract class IPostSettingsRepository {
  Future<Either<PostSettingsFailure, Unit>> createConfig(PostSettings settings);
  Future<Either<PostSettingsFailure, PostSettings?>> fetchSettings();
}
