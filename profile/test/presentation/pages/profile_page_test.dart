import 'package:dependencies/dependencies.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:profile/profile.dart';
import 'package:shared/shared.dart';

import '../../mocks/mocks.dart';
import '../widget_testable.dart';

class IFetchUserMock extends Mock implements IFetchUser {}

class IFetchPostSettingsMock extends Mock implements IFetchPostSettings {}

class ICreatePostMock extends Mock implements ICreatePost {}

void main() {
  final fetchUserSpy = IFetchUserMock();
  final fetchPostSettingsSpy = IFetchPostSettingsMock();
  final createPostSpy = ICreatePostMock();
  const userIdSpy = 1;

  late User user;
  late PostSettings postSettings;

  final defaultTestWidget = WidgetTestable.builder()
      .override(
        providers: [
          fetchUser.overrideWithValue(fetchUserSpy),
          fetchPostSettings.overrideWithValue(fetchPostSettingsSpy),
          createPost.overrideWithValue(createPostSpy),
          userId.overrideWithValue(userIdSpy),
        ],
      )
      .addPage(ProfilePage())
      .build();

  setUp(() {
    user = UserFactory.makeUser(joinedDate: DateTime(2022, 02, 27));
    user.updatePosts(
      [
        PostFactory.makeOriginalPost(author: user),
        PostFactory.makeOriginalPost(author: user),
        PostFactory.makeRepost(author: user),
        PostFactory.makeRepost(author: user),
        PostFactory.makeRepost(author: user),
        PostFactory.makeRepost(author: user),
        PostFactory.makeQuote(author: user),
        PostFactory.makeQuote(author: user),
        PostFactory.makeQuote(author: user),
        PostFactory.makeQuote(author: user),
        PostFactory.makeQuote(author: user),
        PostFactory.makeQuote(author: user),
        PostFactory.makeQuote(author: user),
      ],
    );
    postSettings = PostSettingsFactory.makePostSettings();

    when(() => fetchUserSpy(userIdSpy)).thenAnswer((_) async => Right(user));
    when(() => fetchPostSettingsSpy())
        .thenAnswer((_) async => Right(postSettings));
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
    final listViews = find.byType(ListView);
    final tabBar = find.byType(TabBar);
    final tabBarView = find.byType(TabBarView);

    expect(progressIndicator, findsNothing);
    expect(postFormWidget, findsOneWidget);
    expect(listViews, findsWidgets);
    expect(tabBar, findsOneWidget);
    expect(tabBarView, findsOneWidget);
  });

  testWidgets('should call load user on page initialization', (tester) async {
    await tester.pumpWidget(defaultTestWidget);

    verify(() => fetchUserSpy(userIdSpy));
  });

  testWidgets('should call load post settings on page initialization',
      (tester) async {
    await tester.pumpWidget(defaultTestWidget);

    verify(() => fetchPostSettingsSpy());
  });

  testWidgets('should present text with user joined date', (tester) async {
    await waitForPageInitialization(tester, defaultTestWidget);

    expect(find.text('Joined at: February 27, 2022'), findsOneWidget);
  });

  testWidgets('should present text with user full name', (tester) async {
    await waitForPageInitialization(tester, defaultTestWidget);

    if (user.posts.where((post) => post.type == PostType.post).isNotEmpty) {
      //if the user has more than 1 original post your name will shows in screen
      //more than 1 time because in item list components the name appears again
      expect(find.text(user.username), findsWidgets);
      return;
    }

    expect(find.text(user.username), findsOneWidget);
  });

  testWidgets('should present all tabs', (tester) async {
    await waitForPageInitialization(tester, defaultTestWidget);

    expect(find.text('Posts'), findsOneWidget);
    expect(find.text('Reposts'), findsOneWidget);
    expect(find.text('Quoted'), findsOneWidget);
  });

  testWidgets('should present tab and list with all user original posts',
      (tester) async {
    await waitForPageInitialization(tester, defaultTestWidget);

    final userOriginalPost =
        user.posts.where((post) => post.type == PostType.post).first;
    final itemTextOnList = find.text(userOriginalPost.text!);
    final tabTitle = find.text('Posts');
    final tabText = find.text(
      user.posts
          .where((element) => element.type == PostType.post)
          .length
          .toString(),
    );

    expect(tabTitle, findsOneWidget);
    expect(tabText, findsOneWidget);
    expect(itemTextOnList, findsOneWidget);
  });

  testWidgets('should present tab and list with all user reposts',
      (tester) async {
    await waitForPageInitialization(tester, defaultTestWidget);

    final userRepost =
        user.posts.where((post) => post.type == PostType.repost).first;
    final itemTextOnList = find.text(userRepost.relatedPost!.text!);
    final tabTitle = find.text('Reposts');
    final tabText = find.text(
      user.posts
          .where((element) => element.type == PostType.repost)
          .length
          .toString(),
    );

    await tester.tap(tabTitle);
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(tabTitle, findsOneWidget);
    expect(tabText, findsOneWidget);
    expect(itemTextOnList, findsOneWidget);
  });

  testWidgets('should present tab and list with all user quoted posts',
      (tester) async {
    await waitForPageInitialization(tester, defaultTestWidget);

    final postToMention =
        user.posts.where((post) => post.type == PostType.quote).first;
    final itemTextOnList = find.text(postToMention.relatedPost!.text!);
    final tabTitle = find.text('Quoted');
    final tabText = find.text(
      user.posts
          .where((element) => element.type == PostType.quote)
          .length
          .toString(),
    );

    await tester.tap(tabTitle);
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(tabTitle, findsOneWidget);
    expect(tabText, findsOneWidget);
    expect(itemTextOnList, findsOneWidget);
  });
}
