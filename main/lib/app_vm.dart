// ignore_for_file: unused_local_variable

import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:posterr/core/config/dependencies.dart';
import 'package:shared/shared.dart';

import 'app_state.dart';
import 'domain/domain.dart';

abstract class IAppVM extends ValueNotifier<AsyncValue<IAppState>> {
  IAppVM(AsyncValue<IAppState> value) : super(value);

  Future<void> loadDependencies();
}

class AppVM extends IAppVM {
  AppVM() : super(const AsyncValue.loading());
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
        fetchUsers: FetchUsers(sharedDependencies.userRepository),
      ).execute(),
    ]);

    value = AsyncValue.data(
      AppState(
        sharedDependencies: sharedDependencies,
        mainDependencies: MainDependencies.load(sharedDependencies),
      ),
    );
  }
}

class SeedInitialData {
  final ICreateUsers _createUsers;
  final IFetchUsers _fetchUsers;

  SeedInitialData({
    required ICreateUsers createUser,
    required IFetchUsers fetchUsers,
  })  : _createUsers = createUser,
        _fetchUsers = fetchUsers;

  Future<void> execute() async {
    final response = await _fetchUsers();
    response.fold((l) => throw Exception('unable to initialize'), (seedUsers) {
      if (seedUsers.isNotEmpty) return;

      final users = <User>[];
      final posts = <Post>[];
      final now = DateTime.now();

      for (var i = 1; i < 6; i++) {
        if (i == 5) {
          final uPosts = <Post>[
            Post.original(
              userId: i,
              text: 'Hello! This is my 1 post!!',
              id: i + 1,
              creationDate: now,
            ),
            Post.quote(
              userId: i,
              id: i + 2,
              text: 'This is quote post',
              relatedPost: posts.firstWhere((post) => post.id == 1),
              author: users.firstWhere((user) => user.id == 1),
              creationDate: now,
            ),
            Post.repost(
              userId: i,
              id: i + 3,
              relatedPost: posts.firstWhere((post) => post.id == 2),
              creationDate: now,
            ),
            Post.repost(
              userId: i,
              id: i + 4,
              relatedPost: posts.firstWhere((post) => post.id == 3),
              creationDate: now,
            ),
            Post.repost(
              userId: i,
              id: i + 5,
              relatedPost: posts.firstWhere((post) => post.id == 4),
              creationDate: now,
            ),
          ];
          final user = User(
            id: i,
            username: 'User generated $i',
            joinedDate: DateTime(2021, 3, 25),
            posts: uPosts,
          );

          users.add(user);
          posts.addAll(uPosts);
        } else {
          final post = Post.original(
            userId: i,
            text: 'Hello! This is my $i post!!',
            id: i,
            creationDate: now,
          );
          final user = User(
            id: i,
            username: 'User generated $i',
            joinedDate: DateTime.now(),
            posts: <Post>[post],
          );

          users.add(user);
          posts.add(post);
        }
      }

      _createUsers.call(users);
    });
  }
}
