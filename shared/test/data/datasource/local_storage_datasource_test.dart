import 'package:dependencies/dependencies.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared/shared.dart';

class LocalStorageMock extends Mock implements LocalStorage {}

void main() {
  late LocalStorageMock spy;
  late ILocalStorageDataSource sut;
  late String key;
  late dynamic value;

  setUp(() {
    spy = LocalStorageMock();
    sut = LocalStorageAdapter(localStorage: spy);
    key = faker.randomGenerator.string(5);
    value = faker.randomGenerator.string(400);
  });

  test('should call LocalStorage deleteItem with correct value', () async {
    when(() => spy.deleteItem(key)).thenAnswer((invocation) => Future.value());

    await sut.delete(key);

    verify(() => spy.deleteItem(key)).called(1);
  });

  test('should call LocalStorage getItem with correct value', () async {
    when(() => spy.getItem(key)).thenAnswer((invocation) => any);

    await sut.fetch(key);

    verify(() => spy.getItem(key)).called(1);
  });

  test('should call LocalStorage save with correct value', () async {
    when(() => spy.deleteItem(key)).thenAnswer((invocation) => Future.value());
    when(() => spy.setItem(key, value))
        .thenAnswer((invocation) => Future.value());
    await sut.save(key: key, value: value);

    verify(() => spy.deleteItem(key)).called(1);
    verify(() => spy.setItem(key, value)).called(1);
  });
}
