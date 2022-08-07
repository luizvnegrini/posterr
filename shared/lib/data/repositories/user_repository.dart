import 'dart:convert';

import 'package:dependencies/dependencies.dart';

import '../../shared.dart';

class UserRepository implements IUserRepository {
  final ILocalStorageDataSource _localStorageDataSource;

  UserRepository(this._localStorageDataSource);

  @override
  Future<Either<UserFailure, Unit>> saveUsers(List<User> users) async {
    try {
      await _localStorageDataSource.save(
        key: 'users',
        value: jsonEncode(
            users.map((user) => UserModel.fromEntity(user)).toList()),
      );

      return const Right(unit);
    } catch (e) {
      return Left(UserFailure(type: ExceptionType.serverError));
    }
  }

  @override
  Future<Either<UserFailure, List<User>>> fetchUsers() async {
    try {
      final usersJson = await _localStorageDataSource.fetch('users');

      if (usersJson == null) return const Right(<User>[]);
      final usersMap = jsonDecode(usersJson) as List;
      final entities = <User>[];
      final users =
          usersMap.map((userMap) => UserModel.fromJson(userMap)).toList();
      for (var userModel in users) {
        final userPosts = <Post>[];
        for (var post in userModel.posts) {
          switch (post.type) {
            case PostTypeModel.post:
              userPosts.add(
                Post.original(
                  id: post.id,
                  text: post.text,
                  author: User(
                    id: userModel.id,
                    posts: <Post>[],
                    username: userModel.username,
                    joinedDate: userModel.joinedDate,
                  ),
                  creationDate: post.creationDate,
                ),
              );
              break;
            case PostTypeModel.repost:
              final author =
                  users.firstWhere((user) => user.id == post.authorId);
              PostModel? relatedPost;
              for (var user in users) {
                if (user.posts.any((p) => p.id == post.relatedPostId)) {
                  relatedPost = user.posts.firstWhere(
                      (element) => element.id == post.relatedPostId);
                }
              }
              final relatedPostAuthor = users
                  .firstWhere((element) => element.id == relatedPost?.authorId);
              userPosts.add(
                Post.repost(
                  id: post.id,
                  author: User(
                    id: author.id,
                    joinedDate: author.joinedDate,
                    posts: <Post>[],
                    username: author.username,
                  ),
                  relatedPost: Post.original(
                    author: User(
                      id: relatedPostAuthor.id,
                      joinedDate: relatedPostAuthor.joinedDate,
                      posts: <Post>[],
                      username: relatedPostAuthor.username,
                    ),
                    creationDate: relatedPost!.creationDate,
                    id: relatedPost.id,
                    text: relatedPost.text,
                  ),
                  creationDate: post.creationDate,
                ),
              );
              break;
            case PostTypeModel.quote:
              final author =
                  users.firstWhere((user) => user.id == post.authorId);
              PostModel? relatedPost;
              for (var user in users) {
                if (user.posts.any((p) => p.id == post.relatedPostId)) {
                  relatedPost = user.posts.firstWhere(
                      (element) => element.id == post.relatedPostId);
                }
              }
              final relatedPostAuthor = users
                  .firstWhere((element) => element.id == relatedPost?.authorId);
              userPosts.add(
                Post.quote(
                  id: post.id,
                  text: post.text,
                  author: User(
                    id: author.id,
                    joinedDate: author.joinedDate,
                    posts: <Post>[],
                    username: author.username,
                  ),
                  relatedPost: Post.original(
                    author: User(
                      id: relatedPostAuthor.id,
                      joinedDate: relatedPostAuthor.joinedDate,
                      posts: <Post>[],
                      username: relatedPostAuthor.username,
                    ),
                    creationDate: relatedPost!.creationDate,
                    id: relatedPost.id,
                    text: relatedPost.text,
                  ),
                  creationDate: post.creationDate,
                ),
              );
              break;
            default:
              throw UnimplementedError();
          }
        }
        entities.add(
          User(
            id: userModel.id,
            joinedDate: userModel.joinedDate,
            username: userModel.username,
            posts: userPosts,
          ),
        );
      }

      return Right(entities);
    } catch (e) {
      return Left(UserFailure(type: ExceptionType.notFound));
    }
  }
}
