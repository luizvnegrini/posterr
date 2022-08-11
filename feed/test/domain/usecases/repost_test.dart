import 'package:dependencies/dependencies.dart';
import 'package:feed/feed.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared/shared.dart';

import '../../mocks/mocks.dart';

class IUserRepositoryMock extends Mock implements IUserRepository {}

void main() {
  late IRepost sut;
  late IUserRepositoryMock spy;

  setUp(() {
    spy = IUserRepositoryMock();
    sut = Repost(spy);
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
      relatedPostId: 0,
      userId: user.id,
      relatedPostAuthorId: 0,
    );

    expect(Left(PostFailure(type: ExceptionType.dailyLimitExceeded)), result);
  });

  test('should save repost on user posts', () async {
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
      relatedPostAuthorId: userToMention.id,
      relatedPostId: postToMention.id,
      userId: user.id,
    );

    verify(() => spy.saveUsers(users));
    expect(const Right(unit), result);
  });
}
