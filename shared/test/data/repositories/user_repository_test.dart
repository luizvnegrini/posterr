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
  late IUserRepository sut;
  final users = <User>[
    UserFactory.makeUser(),
    UserFactory.makeUser(),
    UserFactory.makeUser(),
  ];

  setUp(() {
    spy = ILocalStorageDatasourceMock();
    sut = UserRepository(spy);
  });

  test('should create users', () async {
    when(() => spy.save(
            key: sut.key,
            value: jsonEncode(
                users.map((user) => UserModel.fromEntity(user)).toList())))
        .thenAnswer((invocation) => Future.value());

    final result = await sut.saveUsers(users);

    verify(() => spy.save(
            key: sut.key,
            value: jsonEncode(
                users.map((user) => UserModel.fromEntity(user)).toList())))
        .called(1);
    expect(const Right(unit), result);
  });

  test('should fetch users', () async {
    when(() => spy.fetch(sut.key)).thenAnswer(
      (_) => Future.value(
        jsonEncode(
          users.map((user) => UserModel.fromEntity(user)).toList(),
        ),
      ),
    );

    final result = await sut.fetchUsers();

    result.fold((l) => null, (usersResult) {
      expect(users.length, usersResult.length);
    });
  });
}
