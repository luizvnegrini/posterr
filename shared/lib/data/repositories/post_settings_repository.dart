import 'dart:convert';

import 'package:dependencies/dependencies.dart';
import 'package:shared/shared.dart';

class PostSettingsRepository implements IPostSettingsRepository {
  @override
  final String key = 'settings';
  final ILocalStorageDataSource _localStorageDataSource;

  PostSettingsRepository(this._localStorageDataSource);

  @override
  Future<Either<PostSettingsFailure, Unit>> createConfig(
    PostSettings settings,
  ) async {
    try {
      await _localStorageDataSource.save(
        key: key,
        value: jsonEncode(PostSettingsModel.fromEntity(settings)),
      );

      return const Right(unit);
    } catch (e) {
      return Left(PostSettingsFailure(type: ExceptionType.serverError));
    }
  }

  @override
  Future<Either<PostSettingsFailure, PostSettings?>> fetchSettings() async {
    try {
      final settingsJson = await _localStorageDataSource.fetch(key);

      if (settingsJson == null) return const Right(null);

      return Right(
          PostSettingsModel.fromJson(jsonDecode(settingsJson)).toEntity());
    } catch (e) {
      return Left(PostSettingsFailure(type: ExceptionType.notFound));
    }
  }
}
