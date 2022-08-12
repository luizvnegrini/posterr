import 'package:dependencies/dependencies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared/shared.dart';

class IPostSettingsRepositoryMock extends Mock
    implements IPostSettingsRepository {}

void main() {
  late IFetchPostSettings sut;
  late IPostSettingsRepositoryMock spy;

  setUp(() {
    spy = IPostSettingsRepositoryMock();
    sut = FetchPostSettings(spy);
  });

  test('should return post settings', () async {
    final postSettings = PostSettings(
      maxLength: 777,
      minLength: 5,
    );

    when(spy.fetchSettings).thenAnswer((_) async => Right(postSettings));

    final result = await sut();

    expect(Right(postSettings), result);
  });

  test('should return null', () async {
    when(spy.fetchSettings).thenAnswer((_) async => const Right(null));

    final result = await sut();

    expect(const Right(null), result);
  });
}
