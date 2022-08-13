import 'package:dependencies/dependencies.dart';
import 'package:design_system/design_system.dart';
import 'package:feed/feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared/shared.dart';

import '../../mocks/mocks.dart';
import '../widget_testable.dart';

class IFetchPostSettingsMock extends Mock implements IFetchPostSettings {}

class IFetchPostsMock extends Mock implements IFetchPosts {}

class ICreatePostMock extends Mock implements ICreatePost {}

class IFetchUserMock extends Mock implements IFetchUser {}

class IRepostMock extends Mock implements IRepost {}

class IQuotePostMock extends Mock implements IQuotePost {}

void main() {
  final fetchPostSettingsSpy = IFetchPostSettingsMock();
  final fetchPostsSpy = IFetchPostsMock();
  final createPostSpy = ICreatePostMock();
  final fetchUserSpy = IFetchUserMock();
  const userIdSpy = 1;
  final repostSpy = IRepostMock();
  final quotePostSpy = IQuotePostMock();

  late List<User> users;
  late User user;
  late PostSettings postSettings;

  final defaultTestWidget = WidgetTestable.builder()
      .override(
        providers: [
          fetchPostSettings.overrideWithValue(fetchPostSettingsSpy),
          fetchPosts.overrideWithValue(fetchPostsSpy),
          createPost.overrideWithValue(createPostSpy),
          fetchUser.overrideWithValue(fetchUserSpy),
          userId.overrideWithValue(userIdSpy),
          repost.overrideWithValue(repostSpy),
          quotePost.overrideWithValue(quotePostSpy),
        ],
      )
      .addPage(const FeedPage())
      .build();

  setUp(() {
    user = UserFactory.makeUser();
    user.updatePosts(
      [
        PostFactory.makeOriginalPost(user),
        PostFactory.makeOriginalPost(user),
      ],
    );
    users = List<User>.from([
      user,
      UserFactory.makeUser(),
      UserFactory.makeUser(),
      UserFactory.makeUser(),
      UserFactory.makeUser(),
    ]);

    postSettings = PostSettingsFactory.makePostSettings();

    when(() => fetchUserSpy(userIdSpy)).thenAnswer((_) async => Right(user));
    when(() => fetchPostSettingsSpy())
        .thenAnswer((_) async => Right(postSettings));
    final posts = <Post>[];
    for (var user in users) {
      posts.addAll(user.posts);
    }
    when(() => fetchPostsSpy()).thenAnswer((_) async => Right(posts));
  });

  Future<void> waitForPageInitialization(
      WidgetTester tester, Widget defaultTestWidget) async {
    await tester.pumpWidget(defaultTestWidget);
    await tester.pump();
  }

  testWidgets('Should open with circular progress indicator', (tester) async {
    await tester.pumpWidget(defaultTestWidget);

    final circularProgressIndicator = find.byType(CircularProgressIndicator);
    expect(circularProgressIndicator, findsOneWidget);
  });

  testWidgets('Should find main widgets', (tester) async {
    await waitForPageInitialization(tester, defaultTestWidget);

    final progressIndicator = find.byType(CircularProgressIndicator);
    final postFormWidget = find.byType(PostFormWidget);
    final listView = find.byType(ListView);

    expect(progressIndicator, findsNothing);
    expect(postFormWidget, findsOneWidget);
    expect(listView, findsOneWidget);
  });

  testWidgets('should call load user on page initialization', (tester) async {
    await tester.pumpWidget(defaultTestWidget);

    verify(() => fetchUserSpy(userIdSpy));
  });

  testWidgets('should call load feed on page initialization', (tester) async {
    await tester.pumpWidget(defaultTestWidget);

    verify(() => fetchPostsSpy());
  });

  testWidgets('should call load post settings on page initialization',
      (tester) async {
    await tester.pumpWidget(defaultTestWidget);

    verify(() => fetchPostSettingsSpy());
  });

  testWidgets('should find page title', (tester) async {
    await waitForPageInitialization(tester, defaultTestWidget);

    expect(find.text('Feed'), findsOneWidget);
  });

  testWidgets('should present a list with all posts', (tester) async {
    await waitForPageInitialization(tester, defaultTestWidget);

    for (final post in user.posts) {
      final itemTextOnList = find.text(post.text!);

      expect(itemTextOnList, findsOneWidget);
    }

    expect(find.text(user.username), findsWidgets);
  });
}
