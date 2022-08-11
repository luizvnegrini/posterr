import 'package:dependencies/dependencies.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared/shared.dart';

import '../mocks/mocks.dart';

class IUserRepositoryMock extends Mock implements IUserRepository {}

void main() {
  late ICreatePost sut;
  late IUserRepositoryMock spy;

  setUp(() {
    spy = IUserRepositoryMock();
    sut = CreatePost(spy);
  });

  test('should return Daily Limit Exceeded failure', () async {
    final user = UserFactory.makeUser();
    final now = DateTime.now();
    user.updatePosts(<Post>[
      PostFactory.makeOriginalPost(user, creationDate: now),
      PostFactory.makeOriginalPost(user, creationDate: now),
      PostFactory.makeOriginalPost(user, creationDate: now),
      PostFactory.makeOriginalPost(user, creationDate: now),
      PostFactory.makeOriginalPost(user, creationDate: now),
    ]);

    when(spy.fetchUsers).thenAnswer((_) async => Right(<User>[user]));

    final result = await sut(
      text: faker.lorem.sentence(),
      userId: user.id,
    );

    expect(Left(PostFailure(type: ExceptionType.dailyLimitExceeded)), result);
  });

  test('should create new repost', () async {
    final user = UserFactory.makeUser();
    final userToMention = UserFactory.makeUser();
    final postToMention = PostFactory.makeOriginalPost(userToMention);
    userToMention.updatePosts(<Post>[
      postToMention,
    ]);
    final users = <User>[user, userToMention];

    when(spy.fetchUsers).thenAnswer(
      (_) async => Right(users),
    );
    when(() => spy.saveUsers(users))
        .thenAnswer((invocation) async => const Right(unit));

    final result = await sut(
      text: faker.lorem.sentence(),
      userId: user.id,
    );

    verify(() => spy.saveUsers(users));
    expect(const Right(unit), result);
  });
}
