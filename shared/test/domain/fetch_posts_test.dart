import 'package:dependencies/dependencies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared/shared.dart';

import '../mocks/mocks.dart';

class IUserRepositoryMock extends Mock implements IUserRepository {}

void main() {
  late IFetchPosts sut;
  late IUserRepositoryMock spy;

  setUp(() {
    spy = IUserRepositoryMock();
    sut = FetchPosts(spy);
  });

  test('should return Post Failure Not Found', () async {
    final user = UserFactory.makeUser();

    when(spy.fetchUsers).thenAnswer((_) async => Right(<User>[user]));

    final result = await sut();

    expect(Left(PostFailure(type: ExceptionType.notFound)), result);
  });

  test('should return all posts from all users', () async {
    final user1 = UserFactory.makeUser();
    final user2 = UserFactory.makeUser();
    user1.updatePosts(<Post>[
      PostFactory.makeOriginalPost(user1),
      PostFactory.makeOriginalPost(user1),
      PostFactory.makeOriginalPost(user1),
    ]);
    user2.updatePosts(<Post>[
      PostFactory.makeOriginalPost(user2),
      PostFactory.makeOriginalPost(user2),
    ]);

    when(spy.fetchUsers).thenAnswer((_) async => Right(<User>[user1, user2]));

    final result = await sut();
    final posts = result.fold((l) => null, (r) => r);

    assert(posts != null);
    expect(posts!.length, [...user1.posts, ...user2.posts].toList().length);
  });
}
