import 'package:dependencies/dependencies.dart';
import 'package:faker/faker.dart';
import 'package:feed/feed.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared/shared.dart';

import '../../mocks/mocks.dart';

class IUserRepositoryMock extends Mock implements IUserRepository {}

void main() {
  late IQuotePost sut;
  late IUserRepositoryMock spy;

  setUp(() {
    spy = IUserRepositoryMock();
    sut = QuotePost(spy);
  });

  test('should return Daily Limit Exceeded failure', () async {
    final user = UserFactory.makeUser();
    final now = DateTime.now();
    user.updatePosts(<Post>[
      PostFactory.makeOriginalPost(user, now),
      PostFactory.makeOriginalPost(user, now),
      PostFactory.makeOriginalPost(user, now),
      PostFactory.makeOriginalPost(user, now),
      PostFactory.makeOriginalPost(user, now),
    ]);

    when(spy.fetchUsers).thenAnswer((_) async => Right(<User>[user]));

    final result = await sut(
      relatedPostId: 0,
      text: faker.lorem.sentence(),
      userId: user.id,
    );

    expect(Left(PostFailure(type: ExceptionType.dailyLimitExceeded)), result);
  });
}
