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

  setUp(() {
    spy = ILocalStorageDatasourceMock();
    sut = UserRepository(spy);
  });

  test('should create config', () async {
    final users = <User>[
      UserFactory.makeUser(),
      UserFactory.makeUser(),
      UserFactory.makeUser(),
    ];

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

  test('should fetch config', () async {
    // final users = <User>[
    //   UserFactory.makeUser(),
    //   UserFactory.makeUser(),
    //   UserFactory.makeUser(),
    // ];

    // when(() => spy.fetch(sut.key)).thenAnswer((_) => Future.value(
    //       jsonEncode(
    //         PostSettingsModel.fromEntity(postSettings),
    //       ),
    //     ));

    // final result = await sut.fetchSettings();

    // verify(() => spy.fetch(sut.key)).called(1);
    // result.fold((l) => null, (settings) {
    //   assert(settings != null);
    //   assert(settings!.maxLength == postSettings.maxLength);
    //   assert(settings!.minLength == postSettings.minLength);
    // });
  });
}
