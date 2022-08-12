import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:profile/profile.dart';
import 'package:shared/shared.dart';

import '../../mocks/post_settings_mock.dart';
import '../../mocks/user_mock.dart';
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
    user = UserFactory.makeUser();
    postSettings = PostSettingsFactory.makePostSettings();

    when(() => fetchUserSpy(userIdSpy)).thenAnswer((_) async => Right(user));
    when(() => fetchPostSettingsSpy())
        .thenAnswer((_) async => Right(postSettings));
  });

  testWidgets('Should open with circular progress indicator', (tester) async {
    await tester.pumpWidget(defaultTestWidget);

    final circularProgressIndicator = find.byType(CircularProgressIndicator);
    expect(circularProgressIndicator, findsOneWidget);
  });
}
