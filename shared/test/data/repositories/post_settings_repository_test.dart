import 'dart:convert';

import 'package:dependencies/dependencies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared/shared.dart';

import '../../mocks/mocks.dart';

class ILocalStorageDatasourceMock extends Mock
    implements ILocalStorageDataSource {}

void main() {
  late ILocalStorageDatasourceMock spy;
  late IPostSettingsRepository sut;

  setUp(() {
    spy = ILocalStorageDatasourceMock();
    sut = PostSettingsRepository(spy);
  });

  test('should create config', () async {
    final postSettings = PostSettingsFactory.makePostSettings();

    when(() => spy.save(
            key: sut.key,
            value: jsonEncode(PostSettingsModel.fromEntity(postSettings))))
        .thenAnswer((invocation) => Future.value());

    final result = await sut.createConfig(postSettings);

    verify(() => spy.save(
            key: sut.key,
            value: jsonEncode(PostSettingsModel.fromEntity(postSettings))))
        .called(1);
    expect(const Right(unit), result);
  });

  test('should fetch config', () async {
    final postSettings = PostSettingsFactory.makePostSettings();

    when(() => spy.fetch(sut.key)).thenAnswer((_) => Future.value(
          jsonEncode(
            PostSettingsModel.fromEntity(postSettings),
          ),
        ));

    final result = await sut.fetchSettings();

    verify(() => spy.fetch(sut.key)).called(1);
    result.fold((l) => null, (settings) {
      assert(settings != null);
      assert(settings!.maxLength == postSettings.maxLength);
      assert(settings!.minLength == postSettings.minLength);
    });
  });
}
