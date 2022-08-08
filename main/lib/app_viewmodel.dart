// ignore_for_file: unused_local_variable

import 'package:dependencies/dependencies.dart';
import 'package:feed/feed.dart';
import 'package:flutter/material.dart';
import 'package:main/core/config/dependencies.dart';
import 'package:profile/profile.dart';
import 'package:shared/shared.dart';

import 'app_state.dart';
import 'domain/domain.dart';

abstract class IAppViewModel extends ValueNotifier<AsyncValue<IAppState>> {
  IAppViewModel(AsyncValue<IAppState> value) : super(value);

  Future<void> loadDependencies();
}

class AppViewModel extends IAppViewModel {
  AppViewModel() : super(const AsyncValue.loading());
  var _hasRequestedLoading = false;

  @override
  Future<void> loadDependencies() async {
    if (_hasRequestedLoading) {
      return;
    }
    _hasRequestedLoading = true;

    final splashMinDuration =
        Future<dynamic>.delayed(const Duration(seconds: 1));
    SharedDependencies sharedDependencies = await SharedDependencies.load();

    await Future.wait<dynamic>([
      splashMinDuration,
      SeedInitialData(
        createUser: CreateUsers(sharedDependencies.userRepository),
        fetchUsers: FetchPosts(sharedDependencies.userRepository),
        createPostSettings:
            CreatePostSettings(sharedDependencies.postSettingsRepository),
        fetchPostSettings:
            FetchPostSettings(sharedDependencies.postSettingsRepository),
        userId: sharedDependencies.userId,
      ).execute(),
    ]);

    value = AsyncValue.data(
      AppState(
        sharedDependencies: sharedDependencies,
        mainDependencies: MainDependencies.load(sharedDependencies),
        feedDependencies: FeedDependencies.load(sharedDependencies),
        profileDependencies: ProfileDependencies.load(sharedDependencies),
      ),
    );
  }
}

class SeedInitialData {
  final ICreateUsers _createUsers;
  final IFetchPosts _fetchUsers;
  final IFetchPostSettings _fetchPostSettings;
  final ICreatePostSettings _createPostSettings;
  final int _userId;

  SeedInitialData({
    required ICreateUsers createUser,
    required IFetchPosts fetchUsers,
    required IFetchPostSettings fetchPostSettings,
    required ICreatePostSettings createPostSettings,
    required int userId,
  })  : _createUsers = createUser,
        _fetchUsers = fetchUsers,
        _fetchPostSettings = fetchPostSettings,
        _createPostSettings = createPostSettings,
        _userId = userId;

  Future<void> execute() async {
    final usersResponse = await _fetchUsers();
    await usersResponse.fold((l) => throw Exception('unable to initialize'),
        (seedUsers) async {
      if (seedUsers.isNotEmpty) return;

      final users = <User>[];
      final posts = <Post>[];
      final now = DateTime.now();

      for (var i = 1; i < 6; i++) {
        if (i == _userId) {
          final user = User(
            id: i,
            username: 'Luiz Negrini',
            joinedDate: DateTime(2021, 3, 25),
          );

          final uPosts = <Post>[
            Post.original(
              id: 5,
              author: user,
              text: 'Hello! This is my 1 post!!',
              creationDate: now.add(const Duration(days: -2)),
            ),
            Post.quote(
              id: 6,
              text: 'This is a quote post',
              author: user,
              relatedPost: users[0].posts[0],
              creationDate: now.add(const Duration(days: -3)),
            ),
            Post.repost(
              id: 7,
              author: user,
              relatedPost: users[1].posts[0],
              creationDate: now.add(const Duration(days: -4)),
            ),
            Post.repost(
              id: 8,
              author: user,
              relatedPost: users[2].posts[0],
              creationDate: now.add(const Duration(days: -5)),
            ),
            Post.repost(
              id: 9,
              author: user,
              relatedPost: users[3].posts[0],
              creationDate: now.add(const Duration(days: -6)),
            ),
          ];

          user.updatePosts(uPosts);

          users.add(user);
          posts.addAll(uPosts);
        } else {
          final user = User(
            id: i,
            username: 'User gen. $i',
            joinedDate: DateTime.now(),
          );
          final post = Post.original(
            id: i,
            author: user,
            text: 'Hello! This is my first post!!',
            creationDate: now,
          );
          user.updatePosts(<Post>[post]);

          users.add(user);
          posts.add(post);
        }
      }

      await _createUsers(users);
    });

    final postSettingsResponse = await _fetchPostSettings();
    await postSettingsResponse
        .fold((l) => throw Exception('unable to initialize'), (config) async {
      if (config == null) {
        await _createPostSettings(
          PostSettings(
            maxLength: 777,
            minLength: 5,
          ),
        );
      }
    });
  }
}
