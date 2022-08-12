import 'package:dependencies/dependencies.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared/shared.dart';

import '../mocks/user_mock.dart';

class IUserRepositoryMock extends Mock implements IUserRepository {}

void main() {
  late IFetchUser sut;
  late IUserRepositoryMock spy;

  setUp(() {
    spy = IUserRepositoryMock();
    sut = FetchUser(spy);
  });

  test('should return User Failure Not Found', () async {
    when(spy.fetchUsers).thenAnswer(
        (_) async => Left(UserFailure(type: ExceptionType.notFound)));

    final result = await sut(faker.randomGenerator.integer(5));

    expect(Left(UserFailure(type: ExceptionType.notFound)), result);
  });

  test('should return User', () async {
    final users = <User>[
      UserFactory.makeUser(),
      UserFactory.makeUser(),
      UserFactory.makeUser(),
      UserFactory.makeUser(),
    ];

    final user = users.first;

    when(spy.fetchUsers).thenAnswer((_) async => Right(users));

    final result = await sut(user.id);

    expect(Right(user), result);
  });
}
